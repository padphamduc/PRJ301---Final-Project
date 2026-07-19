package controller.customer;

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

@WebServlet(name = "CustomerServlet", urlPatterns = {"/customer"})
public class CustomerServlet extends HttpServlet {

    private final AppointmentDAO appointmentDAO = new AppointmentDAO();
    private final UserDAO userDAO = new UserDAO();
    private final ServiceDAO serviceDAO = new ServiceDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !user.getRole().equals("customer")) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");
        if ("getSlots".equals(action)) {
            String doctor = request.getParameter("doctor");
            String dateStr = request.getParameter("date");
            try {
                Date date = Date.valueOf(dateStr);
                List<String> bookedSlots = appointmentDAO.getBookedSlotsByDoctorAndDate(doctor, date);
                response.setContentType("text/plain");
                response.getWriter().write(String.join(",", bookedSlots));
            } catch (Exception e) {
                response.getWriter().write("");
            }
            return;
        }

        if ("cancel".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                Appointment app = appointmentDAO.getAppointmentById(id);
                if (app != null && app.getCustomerUsername().equals(user.getUsername()) && app.getStatus().equals("Pending")) {
                    if (appointmentDAO.cancelAppointment(id)) {
                        session.setAttribute("successMessage", "Hủy lịch khám thành công!");
                    } else {
                        session.setAttribute("errorMessage", "Không thể hủy lịch khám!");
                    }
                }
            } catch (Exception e) {
                session.setAttribute("errorMessage", "Lỗi tham số hủy lịch!");
            }
            response.sendRedirect("customer");
            return;
        }

        if ("reschedule".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                Appointment app = appointmentDAO.getAppointmentById(id);
                if (app != null && app.getCustomerUsername().equals(user.getUsername()) && app.getStatus().equals("Pending")) {
                    List<Doctor> doctors = userDAO.getAllDoctors();
                    request.setAttribute("appointment", app);
                    request.setAttribute("doctors", doctors);
                    request.getRequestDispatcher("customer/reschedule.jsp").forward(request, response);
                    return;
                }
            } catch (Exception e) {
                session.setAttribute("errorMessage", "Lỗi tham số đổi lịch!");
            }
            response.sendRedirect("customer");
            return;
        }

        // Load dashboard info
        List<Appointment> myAppointments = appointmentDAO.getAppointmentsByCustomer(user.getUsername());
        List<Doctor> doctors = userDAO.getAllDoctors();
        List<Service> services = serviceDAO.getAllServices();

        request.setAttribute("myAppointments", myAppointments);
        request.setAttribute("doctors", doctors);
        request.setAttribute("services", services);
        request.getRequestDispatcher("customer/customer_dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !user.getRole().equals("customer")) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");
        if ("reschedule".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                String doctor = request.getParameter("doctor");
                String dateStr = request.getParameter("date");
                String slot = request.getParameter("timeslot");
                Date date = Date.valueOf(dateStr);

                // Double check availability
                List<String> bookedSlots = appointmentDAO.getBookedSlotsByDoctorAndDate(doctor, date);
                if (bookedSlots.contains(slot)) {
                    session.setAttribute("errorMessage", "Khung giờ này bác sĩ đã có lịch hẹn khác. Vui lòng chọn khung giờ khác!");
                    response.sendRedirect("customer?action=reschedule&id=" + id);
                    return;
                }

                if (appointmentDAO.rescheduleAppointment(id, doctor, date, slot)) {
                    session.setAttribute("successMessage", "Thay đổi lịch hẹn khám thành công!");
                } else {
                    session.setAttribute("errorMessage", "Lỗi cập nhật lịch hẹn!");
                }
            } catch (Exception e) {
                session.setAttribute("errorMessage", "Dữ liệu đổi lịch không hợp lệ!");
            }
            response.sendRedirect("customer");
            return;
        }

        // Regular Booking
        try {
            String doctor = request.getParameter("doctor");
            String dateStr = request.getParameter("date");
            String slot = request.getParameter("timeslot");
            String symptoms = request.getParameter("symptoms");
            String[] servicesArr = request.getParameterValues("services");

            Date date = Date.valueOf(dateStr);

            // Double check availability
            List<String> bookedSlots = appointmentDAO.getBookedSlotsByDoctorAndDate(doctor, date);
            if (bookedSlots.contains(slot)) {
                request.setAttribute("error", "Khung giờ này bác sĩ đã có lịch hẹn khác. Vui lòng chọn khung giờ khác!");
                doGet(request, response);
                return;
            }

            // Create appointment
            Appointment app = new Appointment();
            app.setCustomerUsername(user.getUsername());
            app.setCustomerName(user.getFullName());
            app.setCustomerPhone(user.getPhone());
            app.setDoctorUsername(doctor);
            app.setAppointmentDate(date);
            app.setTimeSlot(slot);
            app.setStatus("Pending");
            app.setSymptoms(symptoms);

            List<Integer> serviceIds = new ArrayList<>();
            if (servicesArr != null) {
                for (String sId : servicesArr) {
                    serviceIds.add(Integer.parseInt(sId));
                }
            }

            if (appointmentDAO.bookAppointment(app, serviceIds)) {
                session.setAttribute("successMessage", "Đặt lịch khám thành công!");
            } else {
                session.setAttribute("errorMessage", "Có lỗi xảy ra khi đặt lịch. Vui lòng thử lại!");
            }
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Dữ liệu đặt lịch không hợp lệ!");
        }

        response.sendRedirect("customer");
    }
}
