package dal;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.Appointment;
import model.Prescription;
import model.Service;

public class AppointmentDAO extends DBContext {

    public boolean bookAppointment(Appointment appointment, List<Integer> serviceIds) {
        String sqlApp = "INSERT INTO Appointments (customerUsername, customerName, customerPhone, doctorUsername, appointmentDate, timeSlot, status, symptoms, diagnosis, assignedRoom) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        String sqlService = "INSERT INTO AppointmentServices (appointmentId, serviceId) VALUES (?, ?)";
        
        try {
            connection.setAutoCommit(false);
            try (PreparedStatement psApp = connection.prepareStatement(sqlApp, Statement.RETURN_GENERATED_KEYS)) {
                
                if (appointment.getCustomerUsername() == null || appointment.getCustomerUsername().trim().isEmpty()) {
                    psApp.setNull(1, java.sql.Types.VARCHAR);
                } else {
                    psApp.setString(1, appointment.getCustomerUsername());
                }
                psApp.setString(2, appointment.getCustomerName());
                psApp.setString(3, appointment.getCustomerPhone());
                psApp.setString(4, appointment.getDoctorUsername());
                psApp.setDate(5, appointment.getAppointmentDate());
                psApp.setString(6, appointment.getTimeSlot());
                psApp.setString(7, appointment.getStatus());
                psApp.setString(8, appointment.getSymptoms());
                psApp.setNull(9, java.sql.Types.NVARCHAR); // diagnosis starts as null
                if (appointment.getAssignedRoom() == null || appointment.getAssignedRoom().trim().isEmpty()) {
                    psApp.setNull(10, java.sql.Types.NVARCHAR);
                } else {
                    psApp.setString(10, appointment.getAssignedRoom());
                }
                
                int affectedRows = psApp.executeUpdate();
                if (affectedRows == 0) {
                    throw new SQLException("Creating appointment failed, no rows affected.");
                }

                int appId = 0;
                try (ResultSet generatedKeys = psApp.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        appId = generatedKeys.getInt(1);
                    } else {
                        throw new SQLException("Creating appointment failed, no ID obtained.");
                    }
                }

                // Insert selected services
                if (serviceIds != null && !serviceIds.isEmpty()) {
                    try (PreparedStatement psServ = connection.prepareStatement(sqlService)) {
                        for (int serviceId : serviceIds) {
                            psServ.setInt(1, appId);
                            psServ.setInt(2, serviceId);
                            psServ.addBatch();
                        }
                        psServ.executeBatch();
                    }
                }

                connection.commit();
                return true;
            } catch (SQLException e) {
                connection.rollback();
                e.printStackTrace();
            } finally {
                connection.setAutoCommit(true);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Appointment> getAppointmentsByCustomer(String customerUsername) {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT a.*, u.fullName AS doctorName FROM Appointments a JOIN Users u ON a.doctorUsername = u.username WHERE a.customerUsername = ? ORDER BY a.appointmentDate DESC, a.timeSlot DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, customerUsername);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Appointment app = extractAppointment(rs);
                    app.setDoctorName(rs.getString("doctorName"));
                    list.add(app);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Appointment> getAppointmentsByDoctor(String doctorUsername) {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT a.*, u.fullName AS doctorName FROM Appointments a JOIN Users u ON a.doctorUsername = u.username WHERE a.doctorUsername = ? ORDER BY a.appointmentDate DESC, a.timeSlot DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, doctorUsername);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Appointment app = extractAppointment(rs);
                    app.setDoctorName(rs.getString("doctorName"));
                    list.add(app);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<String> getBookedSlotsByDoctorAndDate(String doctorUsername, Date date) {
        List<String> list = new ArrayList<>();
        String sql = "SELECT timeSlot FROM Appointments WHERE doctorUsername = ? AND appointmentDate = ? AND status <> 'Cancelled'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, doctorUsername);
            ps.setDate(2, date);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(rs.getString("timeSlot"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Appointment> getAllAppointmentsToday() {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT a.*, u.fullName AS doctorName FROM Appointments a JOIN Users u ON a.doctorUsername = u.username WHERE a.appointmentDate = CAST(GETDATE() AS DATE) ORDER BY a.timeSlot ASC";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Appointment app = extractAppointment(rs);
                app.setDoctorName(rs.getString("doctorName"));
                list.add(app);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Appointment> searchAppointments(String keyword) {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT a.*, u.fullName AS doctorName FROM Appointments a JOIN Users u ON a.doctorUsername = u.username WHERE a.customerName LIKE ? OR a.customerPhone LIKE ? ORDER BY a.appointmentDate DESC, a.timeSlot DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            String likeKeyword = "%" + keyword + "%";
            ps.setString(1, likeKeyword);
            ps.setString(2, likeKeyword);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Appointment app = extractAppointment(rs);
                    app.setDoctorName(rs.getString("doctorName"));
                    list.add(app);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Appointment getAppointmentById(int id) {
        String sql = "SELECT a.*, u.fullName AS doctorName FROM Appointments a JOIN Users u ON a.doctorUsername = u.username WHERE a.id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Appointment app = extractAppointment(rs);
                    app.setDoctorName(rs.getString("doctorName"));
                    return app;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean checkInAppointment(int id, String assignedRoom) {
        String sql = "UPDATE Appointments SET status = 'CheckedIn', assignedRoom = ? WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, assignedRoom);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateStatus(int id, String status) {
        String sql = "UPDATE Appointments SET status = ? WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateRoom(int id, String room) {
        String sql = "UPDATE Appointments SET assignedRoom = ? WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, room);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean cancelAppointment(int id) {
        return updateStatus(id, "Cancelled");
    }

    public boolean rescheduleAppointment(int id, String doctorUsername, Date date, String timeSlot) {
        String sql = "UPDATE Appointments SET doctorUsername = ?, appointmentDate = ?, timeSlot = ?, status = 'Pending' WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, doctorUsername);
            ps.setDate(2, date);
            ps.setString(3, timeSlot);
            ps.setInt(4, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Appointment> getMedicalHistoryByCustomerPhone(String phone) {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT a.*, u.fullName AS doctorName FROM Appointments a JOIN Users u ON a.doctorUsername = u.username WHERE a.customerPhone = ? AND a.status IN ('Completed', 'Paid') ORDER BY a.appointmentDate DESC, a.timeSlot DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, phone);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Appointment app = extractAppointment(rs);
                    app.setDoctorName(rs.getString("doctorName"));
                    list.add(app);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean diagnoseAppointment(int id, String diagnosis, String symptoms, List<Integer> serviceIds, List<Prescription> prescriptions) {
        String sqlApp = "UPDATE Appointments SET status = 'Completed', diagnosis = ?, symptoms = ? WHERE id = ?";
        String sqlDelServices = "DELETE FROM AppointmentServices WHERE appointmentId = ?";
        String sqlInsService = "INSERT INTO AppointmentServices (appointmentId, serviceId) VALUES (?, ?)";
        String sqlDelPrescriptions = "DELETE FROM Prescriptions WHERE appointmentId = ?";
        String sqlInsPrescription = "INSERT INTO Prescriptions (appointmentId, medicineId, quantity, boughtQuantity, instructions) VALUES (?, ?, ?, 0, ?)";

        try {
            connection.setAutoCommit(false);
            try {
                // 1. Update appointment record
                try (PreparedStatement ps = connection.prepareStatement(sqlApp)) {
                    ps.setString(1, diagnosis);
                    ps.setString(2, symptoms);
                    ps.setInt(3, id);
                    ps.executeUpdate();
                }

                // 2. Clear and Insert services
                try (PreparedStatement ps = connection.prepareStatement(sqlDelServices)) {
                    ps.setInt(1, id);
                    ps.executeUpdate();
                }
                if (serviceIds != null && !serviceIds.isEmpty()) {
                    try (PreparedStatement ps = connection.prepareStatement(sqlInsService)) {
                        for (int serviceId : serviceIds) {
                            ps.setInt(1, id);
                            ps.setInt(2, serviceId);
                            ps.addBatch();
                        }
                        ps.executeBatch();
                    }
                }

                // 3. Clear and Insert prescriptions
                try (PreparedStatement ps = connection.prepareStatement(sqlDelPrescriptions)) {
                    ps.setInt(1, id);
                    ps.executeUpdate();
                }
                if (prescriptions != null && !prescriptions.isEmpty()) {
                    try (PreparedStatement ps = connection.prepareStatement(sqlInsPrescription)) {
                        for (Prescription p : prescriptions) {
                            ps.setInt(1, id);
                            ps.setInt(2, p.getMedicineId());
                            ps.setInt(3, p.getQuantity());
                            ps.setString(4, p.getInstructions());
                            ps.addBatch();
                        }
                        ps.executeBatch();
                    }
                }

                connection.commit();
                return true;
            } catch (SQLException e) {
                connection.rollback();
                e.printStackTrace();
            } finally {
                connection.setAutoCommit(true);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean payAppointment(int appointmentId, List<Prescription> boughtPrescriptions) {
        String sqlUpdatePrescription = "UPDATE Prescriptions SET boughtQuantity = ? WHERE appointmentId = ? AND medicineId = ?";
        String sqlUpdateStatus = "UPDATE Appointments SET status = 'Paid' WHERE id = ?";
        String sqlUpdateStock = "UPDATE Medicines SET stockQuantity = stockQuantity - ? WHERE id = ?";
        
        try {
            connection.setAutoCommit(false);
            try {
                // Update bought quantity and decrement stock quantity for each medicine
                if (boughtPrescriptions != null) {
                    try (PreparedStatement psPres = connection.prepareStatement(sqlUpdatePrescription);
                         PreparedStatement psStock = connection.prepareStatement(sqlUpdateStock)) {
                        for (Prescription p : boughtPrescriptions) {
                            // Update bought quantity
                            psPres.setInt(1, p.getBoughtQuantity());
                            psPres.setInt(2, appointmentId);
                            psPres.setInt(3, p.getMedicineId());
                            psPres.addBatch();

                            // Update stock quantity
                            psStock.setInt(1, p.getBoughtQuantity());
                            psStock.setInt(2, p.getMedicineId());
                            psStock.addBatch();
                        }
                        psPres.executeBatch();
                        psStock.executeBatch();
                    }
                }

                // Update appointment status to Paid
                try (PreparedStatement ps = connection.prepareStatement(sqlUpdateStatus)) {
                    ps.setInt(1, appointmentId);
                    ps.executeUpdate();
                }

                connection.commit();
                return true;
            } catch (SQLException e) {
                connection.rollback();
                e.printStackTrace();
            } finally {
                connection.setAutoCommit(true);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Service> getServicesByAppointment(int appointmentId) {
        List<Service> list = new ArrayList<>();
        String sql = "SELECT s.* FROM Services s JOIN AppointmentServices aserv ON s.id = aserv.serviceId WHERE aserv.appointmentId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, appointmentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Service(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getDouble("price"),
                        rs.getString("description")
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Prescription> getPrescriptionsByAppointment(int appointmentId) {
        List<Prescription> list = new ArrayList<>();
        String sql = "SELECT p.*, m.name AS medicineName, m.price AS medicinePrice, m.unit AS medicineUnit FROM Prescriptions p JOIN Medicines m ON p.medicineId = m.id WHERE p.appointmentId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, appointmentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Prescription(
                        rs.getInt("appointmentId"),
                        rs.getInt("medicineId"),
                        rs.getString("medicineName"),
                        rs.getDouble("medicinePrice"),
                        rs.getString("medicineUnit"),
                        rs.getInt("quantity"),
                        rs.getInt("boughtQuantity"),
                        rs.getString("instructions")
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private Appointment extractAppointment(ResultSet rs) throws SQLException {
        return new Appointment(
            rs.getInt("id"),
            rs.getString("customerUsername"),
            rs.getString("customerName"),
            rs.getString("customerPhone"),
            rs.getString("doctorUsername"),
            rs.getDate("appointmentDate"),
            rs.getString("timeSlot"),
            rs.getString("status"),
            rs.getString("symptoms"),
            rs.getString("diagnosis"),
            rs.getString("assignedRoom")
        );
    }
}
