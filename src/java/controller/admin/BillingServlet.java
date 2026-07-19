package controller.admin;

import dal.AppointmentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import model.Appointment;
import model.Prescription;
import model.Service;
import model.User;

@WebServlet(name = "BillingServlet", urlPatterns = {"/billing"})
public class BillingServlet extends HttpServlet {

    private final AppointmentDAO appointmentDAO = new AppointmentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect("home");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            Appointment app = appointmentDAO.getAppointmentById(id);
            if (app != null) {
                if (user.getRole().equals("customer") && !user.getUsername().equals(app.getCustomerUsername())) {
                    response.sendRedirect("customer");
                    return;
                }

                List<Service> services = appointmentDAO.getServicesByAppointment(id);
                List<Prescription> prescriptions = appointmentDAO.getPrescriptionsByAppointment(id);

                request.setAttribute("appointment", app);
                request.setAttribute("services", services);
                request.setAttribute("prescriptions", prescriptions);
                request.getRequestDispatcher("admin/billing.jsp").forward(request, response);
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("home");
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

        try {
            int appointmentId = Integer.parseInt(request.getParameter("id"));
            String[] medIds = request.getParameterValues("medIds");
            
            List<Prescription> boughtPrescriptions = new ArrayList<>();
            if (medIds != null) {
                for (String medIdStr : medIds) {
                    int medId = Integer.parseInt(medIdStr);
                    String buyQtyStr = request.getParameter("buyQty_" + medId);
                    int buyQty = 0;
                    if (buyQtyStr != null && !buyQtyStr.trim().isEmpty()) {
                        buyQty = Integer.parseInt(buyQtyStr);
                    }
                    Prescription p = new Prescription();
                    p.setMedicineId(medId);
                    p.setBoughtQuantity(buyQty);
                    boughtPrescriptions.add(p);
                }
            }

            if (appointmentDAO.payAppointment(appointmentId, boughtPrescriptions)) {
                session.setAttribute("successMessage", "Thanh toán hóa đơn và xuất kho thành công!");
                response.sendRedirect("receptionist");
            } else {
                session.setAttribute("errorMessage", "Thanh toán hóa đơn thất bại!");
                response.sendRedirect("billing?id=" + appointmentId);
            }
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Dữ liệu hóa đơn không hợp lệ!");
            response.sendRedirect("receptionist");
        }
    }
}
