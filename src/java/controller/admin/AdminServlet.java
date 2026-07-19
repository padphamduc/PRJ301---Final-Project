package controller.admin;

import dal.MedicineDAO;
import dal.ServiceDAO;
import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.Doctor;
import model.Medicine;
import model.Service;
import model.User;

@WebServlet(name = "AdminServlet", urlPatterns = {"/admin"})
public class AdminServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final ServiceDAO serviceDAO = new ServiceDAO();
    private final MedicineDAO medicineDAO = new MedicineDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !user.getRole().equals("admin")) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            List<User> users = userDAO.getAllUsers();
            List<Doctor> doctors = userDAO.getAllDoctors();
            List<Service> services = serviceDAO.getAllServices();
            List<Medicine> medicines = medicineDAO.getAllMedicines();
            
            request.setAttribute("users", users);
            request.setAttribute("doctors", doctors);
            request.setAttribute("services", services);
            request.setAttribute("medicines", medicines);
            request.getRequestDispatcher("admin/admin_dashboard.jsp").forward(request, response);
            return;
        }

        // Service actions
        if (action.equals("addService")) {
            request.setAttribute("title", "Thêm Dịch Vụ Mới");
            request.getRequestDispatcher("admin/admin_edit_service.jsp").forward(request, response);
        } else if (action.equals("editService")) {
            int id = Integer.parseInt(request.getParameter("id"));
            Service s = serviceDAO.getServiceById(id);
            request.setAttribute("service", s);
            request.setAttribute("title", "Chỉnh Sửa Dịch Vụ");
            request.getRequestDispatcher("admin/admin_edit_service.jsp").forward(request, response);
        } else if (action.equals("deleteService")) {
            int id = Integer.parseInt(request.getParameter("id"));
            serviceDAO.deleteService(id);
            response.sendRedirect("admin");
        } 
        
        // Medicine actions
        else if (action.equals("addMedicine")) {
            request.setAttribute("title", "Thêm Thuốc Mới");
            request.getRequestDispatcher("admin/admin_edit_medicine.jsp").forward(request, response);
        } else if (action.equals("editMedicine")) {
            int id = Integer.parseInt(request.getParameter("id"));
            Medicine m = medicineDAO.getMedicineById(id);
            request.setAttribute("medicine", m);
            request.setAttribute("title", "Chỉnh Sửa Thuốc & Kho");
            request.getRequestDispatcher("admin/admin_edit_medicine.jsp").forward(request, response);
        } else if (action.equals("deleteMedicine")) {
            int id = Integer.parseInt(request.getParameter("id"));
            medicineDAO.deleteMedicine(id);
            response.sendRedirect("admin");
        }
        
        // User actions
        else if (action.equals("addUser")) {
            request.setAttribute("title", "Thêm Thành Viên Mới");
            request.getRequestDispatcher("admin/admin_edit_user.jsp").forward(request, response);
        } else if (action.equals("editUser")) {
            String username = request.getParameter("username");
            User u = userDAO.getUserByUsername(username);
            if (u != null && u.getRole().equals("doctor")) {
                Doctor d = userDAO.getDoctorByUsername(username);
                request.setAttribute("targetUser", d);
            } else {
                request.setAttribute("targetUser", u);
            }
            request.setAttribute("title", "Chỉnh Sửa Thành Viên");
            request.getRequestDispatcher("admin/admin_edit_user.jsp").forward(request, response);
        } else if (action.equals("deleteUser")) {
            String username = request.getParameter("username");
            userDAO.deleteUser(username);
            response.sendRedirect("admin");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !user.getRole().equals("admin")) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");
        if ("saveService".equals(action)) {
            String idStr = request.getParameter("id");
            String name = request.getParameter("name");
            double price = Double.parseDouble(request.getParameter("price"));
            String desc = request.getParameter("description");
            
            Service s = new Service();
            s.setName(name);
            s.setPrice(price);
            s.setDescription(desc);
            
            if (idStr == null || idStr.trim().isEmpty() || idStr.equals("0")) {
                serviceDAO.addService(s);
            } else {
                s.setId(Integer.parseInt(idStr));
                serviceDAO.updateService(s);
            }
        } else if ("saveMedicine".equals(action)) {
            String idStr = request.getParameter("id");
            String name = request.getParameter("name");
            double price = Double.parseDouble(request.getParameter("price"));
            String unit = request.getParameter("unit");
            int stock = Integer.parseInt(request.getParameter("stockQuantity"));
            
            Medicine m = new Medicine();
            m.setName(name);
            m.setPrice(price);
            m.setUnit(unit);
            m.setStockQuantity(stock);
            
            if (idStr == null || idStr.trim().isEmpty() || idStr.equals("0")) {
                medicineDAO.addMedicine(m);
            } else {
                m.setId(Integer.parseInt(idStr));
                medicineDAO.updateMedicine(m);
            }
        } else if ("saveUser".equals(action)) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String fullName = request.getParameter("fullName");
            String role = request.getParameter("role");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            boolean isEdit = "true".equals(request.getParameter("isEdit"));
            
            if (role.equals("doctor")) {
                String specialty = request.getParameter("specialty");
                String room = request.getParameter("room");
                Doctor doc = new Doctor(username, password, fullName, "doctor", email, phone, specialty, room);
                if (isEdit) {
                    userDAO.updateDoctor(doc);
                } else {
                    userDAO.addDoctor(doc);
                }
            } else {
                User u = new User(username, password, fullName, role, email, phone);
                if (isEdit) {
                    userDAO.updateUser(u);
                } else {
                    userDAO.register(u);
                }
            }
        }

        response.sendRedirect("admin");
    }
}
