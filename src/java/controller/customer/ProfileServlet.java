package controller.customer;

import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile"})
public class ProfileServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !user.getRole().equals("customer")) {
            response.sendRedirect("login");
            return;
        }
        request.getRequestDispatcher("customer/profile.jsp").forward(request, response);
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

        try {
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String password = request.getParameter("password");

            User updatedUser = new User();
            updatedUser.setUsername(user.getUsername());
            updatedUser.setFullName(fullName);
            updatedUser.setEmail(email);
            updatedUser.setPhone(phone);
            updatedUser.setPassword(password);
            updatedUser.setRole("customer");

            if (userDAO.updateUser(updatedUser)) {
                // Update session
                session.setAttribute("user", updatedUser);
                session.setAttribute("successMessage", "Cập nhật hồ sơ cá nhân thành công!");
            } else {
                session.setAttribute("errorMessage", "Không thể cập nhật thông tin hồ sơ!");
            }
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Lỗi dữ liệu đầu vào!");
        }

        response.sendRedirect("profile");
    }
}
