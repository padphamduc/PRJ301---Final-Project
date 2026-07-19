package controller.receptionist;

import dal.AppointmentDAO;
import dal.ServiceDAO;
import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;
import model.Appointment;
import model.Doctor;
import model.Service;
import model.User;

@WebServlet(name = "ReceptionistServlet", urlPatterns = {"/receptionist"})
public class ReceptionistServlet extends HttpServlet {

    private final AppointmentDAO appointmentDAO = new AppointmentDAO();
    private final UserDAO userDAO = new UserDAO();
    private final ServiceDAO serviceDAO = new ServiceDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !user.getRole().equals("receptionist")) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");
        if ("getSlots".equals(action)) {
            String doctor = request.getParameter("doctor");
            String dateStr = request.getParameter("date");
            response.setContentType("text/plain;charset=UTF-8");
            try {
                Date date = Date.valueOf(dateStr);
                List<String> bookedSlots = appointmentDAO.getBookedSlotsByDoctorAndDate(doctor, date);
                response.getWriter().write(String.join(",", bookedSlots));
            } catch (Exception e) {
                response.getWriter().write("");
            }
            return;
        }

        String keyword = request.getParameter("searchKeyword");
        List<Appointment> list;
        if (keyword != null && !keyword.trim().isEmpty()) {
            list = appointmentDAO.searchAppointments(keyword.trim());
        } else {
            list = appointmentDAO.getAllAppointmentsToday();
        }

        List<Doctor> doctors = userDAO.getAllDoctors();
        List<Service> services = serviceDAO.getAllServices();

        request.setAttribute("appointments", list);
        request.setAttribute("doctors", doctors);
        request.setAttribute("services", services);
        request.getRequestDispatcher("receptionist/receptionist_dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !user.getRole().equals("receptionist")) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");
        
        if ("checkin".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                String room = request.getParameter("assignedRoom");
                if (appointmentDAO.checkInAppointment(id, room)) {
                    session.setAttribute("successMessage", "Check-in thành công! Đã chuyển trạng thái sang Chờ khám.");
                } else {
                    session.setAttribute("errorMessage", "Không thể thực hiện check-in!");
                }
            } catch (Exception e) {
                session.setAttribute("errorMessage", "Lỗi tham số check-in!");
            }
        } 
        
        else if ("updateStatus".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                String status = request.getParameter("status");
                if (appointmentDAO.updateStatus(id, status)) {
                    session.setAttribute("successMessage", "Cập nhật trạng thái lịch khám thành công!");
                } else {
                    session.setAttribute("errorMessage", "Lỗi cập nhật trạng thái!");
                }
            } catch (Exception e) {
                session.setAttribute("errorMessage", "Tham số trạng thái không hợp lệ!");
            }
        }

        else if ("updateRoom".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                String room = request.getParameter("assignedRoom");
                if (appointmentDAO.updateRoom(id, room)) {
                    session.setAttribute("successMessage", "Điều phối phòng khám thành công!");
                } else {
                    session.setAttribute("errorMessage", "Không thể cập nhật phòng khám!");
                }
            } catch (Exception e) {
                session.setAttribute("errorMessage", "Tham số phòng khám không hợp lệ!");
            }
        }
        
        else if ("book".equals(action)) {
            try {
                String name = request.getParameter("customerName");
                String phone = request.getParameter("customerPhone");
                String doctor = request.getParameter("doctor");
                String dateStr = request.getParameter("date");
                String slot = request.getParameter("timeslot");
                String symptoms = request.getParameter("symptoms");
                String[] servicesArr = request.getParameterValues("services");

                Date date = Date.valueOf(dateStr);

                // Always verify availability again on the server.
                List<String> bookedSlots = appointmentDAO.getBookedSlotsByDoctorAndDate(doctor, date);
                if (bookedSlots.contains(slot)) {
                    session.setAttribute("errorMessage", "Khung giờ này đã có lịch. Vui lòng chọn giờ khác!");
                    response.sendRedirect("receptionist");
                    return;
                }
                
                Doctor doc = userDAO.getDoctorByUsername(doctor);
                String docRoom = doc != null ? doc.getRoom() : "Phòng Khám 101";

                Appointment app = new Appointment();
                app.setCustomerUsername(null);
                app.setCustomerName(name);
                app.setCustomerPhone(phone);
                app.setDoctorUsername(doctor);
                app.setAppointmentDate(date);
                app.setTimeSlot(slot);
                app.setStatus("CheckedIn"); // direct check-in at counter
                app.setSymptoms(symptoms);
                app.setAssignedRoom(docRoom);

                List<Integer> serviceIds = new ArrayList<>();
                if (servicesArr != null) {
                    for (String sId : servicesArr) {
                        serviceIds.add(Integer.parseInt(sId));
                    }
                }

                if (appointmentDAO.bookAppointment(app, serviceIds)) {
                    session.setAttribute("successMessage", "Đặt lịch trực tiếp tại quầy thành công!");
                } else {
                    session.setAttribute("errorMessage", "Có lỗi xảy ra khi đặt lịch tại quầy!");
                }
            } catch (Exception e) {
                session.setAttribute("errorMessage", "Dữ liệu đăng ký không hợp lệ!");
            }
        }

        response.sendRedirect("receptionist");
    }
}
