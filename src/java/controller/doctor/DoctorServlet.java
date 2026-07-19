package controller.doctor;

import dal.AppointmentDAO;
import dal.MedicineDAO;
import dal.ServiceDAO;
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
import model.Medicine;
import model.Prescription;
import model.Service;
import model.User;

@WebServlet(name = "DoctorServlet", urlPatterns = {"/doctor"})
public class DoctorServlet extends HttpServlet {

    private final AppointmentDAO appointmentDAO = new AppointmentDAO();
    private final ServiceDAO serviceDAO = new ServiceDAO();
    private final MedicineDAO medicineDAO = new MedicineDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !user.getRole().equals("doctor")) {
            response.sendRedirect("login");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                int id = Integer.parseInt(idStr);
                Appointment app = appointmentDAO.getAppointmentById(id);
                if (app != null && app.getDoctorUsername().equals(user.getUsername())) {
                    List<Service> allServices = serviceDAO.getAllServices();
                    List<Service> currentServices = appointmentDAO.getServicesByAppointment(id);
                    List<Medicine> allMedicines = medicineDAO.getAllMedicines();
                    
                    // Load patient medical history
                    List<Appointment> medicalHistory = appointmentDAO.getMedicalHistoryByCustomerPhone(app.getCustomerPhone());
                    
                    request.setAttribute("appointment", app);
                    request.setAttribute("allServices", allServices);
                    request.setAttribute("currentServices", currentServices);
                    request.setAttribute("allMedicines", allMedicines);
                    request.setAttribute("medicalHistory", medicalHistory);
                    
                    request.getRequestDispatcher("doctor/doctor_treatment.jsp").forward(request, response);
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            response.sendRedirect("doctor");
            return;
        }

        // List doctor appointments
        List<Appointment> appointments = appointmentDAO.getAppointmentsByDoctor(user.getUsername());
        request.setAttribute("appointments", appointments);
        request.getRequestDispatcher("doctor/doctor_dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !user.getRole().equals("doctor")) {
            response.sendRedirect("login");
            return;
        }

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String symptoms = request.getParameter("symptoms");
            String diagnosis = request.getParameter("diagnosis");
            String[] servicesArr = request.getParameterValues("services");
            String[] medicinesArr = request.getParameterValues("medicines");

            List<Integer> serviceIds = new ArrayList<>();
            if (servicesArr != null) {
                for (String sId : servicesArr) {
                    serviceIds.add(Integer.parseInt(sId));
                }
            }

            List<Prescription> prescriptions = new ArrayList<>();
            if (medicinesArr != null) {
                for (String medIdStr : medicinesArr) {
                    int medId = Integer.parseInt(medIdStr);
                    String qtyStr = request.getParameter("qty_" + medId);
                    String inst = request.getParameter("inst_" + medId);
                    
                    int qty = 1;
                    if (qtyStr != null && !qtyStr.trim().isEmpty()) {
                        qty = Integer.parseInt(qtyStr);
                    }
                    
                    Prescription p = new Prescription();
                    p.setMedicineId(medId);
                    p.setQuantity(qty);
                    p.setInstructions(inst);
                    prescriptions.add(p);
                }
            }

            if (appointmentDAO.diagnoseAppointment(id, diagnosis, symptoms, serviceIds, prescriptions)) {
                session.setAttribute("successMessage", "Ghi nhận kết quả khám và kê đơn thành công!");
            } else {
                session.setAttribute("errorMessage", "Không thể lưu hồ sơ khám!");
            }
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Lỗi định dạng dữ liệu hồ sơ khám!");
            e.printStackTrace();
        }

        response.sendRedirect("doctor");
    }
}
