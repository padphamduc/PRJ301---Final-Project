package dal;

import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Appointment;
import model.Prescription;
import model.Service;

/**
 * Shared DAO skeleton. Each member must only implement the methods marked for them.
 * Before editing this shared file, always pull/rebase from GitHub.
 */
public class AppointmentDAO extends DBContext {

    // ==================== MEMBER 1: CUSTOMER ====================
    public boolean bookAppointment(Appointment appointment, List<Integer> serviceIds) {
        // TODO MEMBER 1: transaction insert Appointments + AppointmentServices.
        return false;
    }

    public List<Appointment> getAppointmentsByCustomer(String customerUsername) {
        // TODO MEMBER 1.
        return new ArrayList<>();
    }

    public List<String> getBookedSlotsByDoctorAndDate(String doctorUsername, Date date) {
        // TODO MEMBER 1 (shared with Member 2): return occupied time slots.
        return new ArrayList<>();
    }

    public boolean cancelAppointment(int id) {
        // TODO MEMBER 1: only Pending appointments should be cancelled.
        return false;
    }

    public boolean rescheduleAppointment(int id, String doctorUsername, Date date, String timeSlot) {
        // TODO MEMBER 1.
        return false;
    }

    // ==================== MEMBER 2: RECEPTIONIST ====================
    public List<Appointment> getAllAppointmentsToday() {
        // TODO MEMBER 2: use SQL Server GETDATE and order by timeSlot.
        return new ArrayList<>();
    }

    public List<Appointment> searchAppointments(String keyword) {
        // TODO MEMBER 2: search customerName OR customerPhone using LIKE.
        return new ArrayList<>();
    }

    public boolean checkInAppointment(int id, String assignedRoom) {
        // TODO MEMBER 2: set CheckedIn and assignedRoom.
        return false;
    }

    public boolean updateStatus(int id, String status) {
        // TODO MEMBER 2: validate allowed appointment statuses.
        return false;
    }

    public boolean updateRoom(int id, String room) {
        // TODO MEMBER 2.
        return false;
    }

    // ==================== MEMBER 3: DOCTOR ====================
    public List<Appointment> getAppointmentsByDoctor(String doctorUsername) {
        // TODO MEMBER 3.
        return new ArrayList<>();
    }

    public List<Appointment> getMedicalHistoryByCustomerPhone(String phone) {
        // TODO MEMBER 3.
        return new ArrayList<>();
    }

    public boolean diagnoseAppointment(int id, String diagnosis, String symptoms,
            List<Integer> serviceIds, List<Prescription> prescriptions) {
        // TODO MEMBER 3: transaction for diagnosis, services and prescriptions.
        return false;
    }

    // ==================== MEMBER 4: BILLING ====================
    public boolean payAppointment(int appointmentId, List<Prescription> boughtPrescriptions) {
        // TODO MEMBER 4: update stock and appointment status to Paid in transaction.
        return false;
    }

    // ==================== SHARED READ METHODS ====================
    public Appointment getAppointmentById(int id) {
        // TODO: first member who needs this method may implement it, then others reuse it.
        return null;
    }

    public List<Service> getServicesByAppointment(int appointmentId) {
        // TODO MEMBER 3/4.
        return new ArrayList<>();
    }

    public List<Prescription> getPrescriptionsByAppointment(int appointmentId) {
        // TODO MEMBER 3/4.
        return new ArrayList<>();
    }

    private Appointment extractAppointment(ResultSet rs) throws SQLException {
        // TODO SHARED: map one ResultSet row to Appointment.
        return null;
    }
}
