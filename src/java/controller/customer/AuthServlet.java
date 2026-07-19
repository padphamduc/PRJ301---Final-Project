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

@WebServlet(name = "AuthServlet", urlPatterns = {"/login", "/logout", "/signup"})
public class AuthServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        if (path.equals("/logout")) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/home");
        } else if (path.equals("/signup")) {
            request.getRequestDispatcher("customer/signup.jsp").forward(request, response);
        } else { // /login
            request.getRequestDispatcher("customer/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        
        if (path.equals("/login")) {
            String userStr = request.getParameter("username");
            String passStr = request.getParameter("password");
            
            User user = userDAO.login(userStr, passStr);
            if (user != null) {
                // Create a new session after login to prevent session fixation.
                HttpSession oldSession = request.getSession(false);
                if (oldSession != null) {
                    oldSession.invalidate();
                }

                HttpSession session = request.getSession(true);
                session.setAttribute("user", user);
                session.setMaxInactiveInterval(30 * 60);

                String contextPath = request.getContextPath();
                switch (user.getRole()) {
                    case "admin":
                        response.sendRedirect(contextPath + "/admin");
                        break;
                    case "doctor":
                        response.sendRedirect(contextPath + "/doctor");
                        break;
                    case "receptionist":
                        response.sendRedirect(contextPath + "/receptionist");
                        break;
                    default: // customer
                        response.sendRedirect(contextPath + "/customer");
                        break;
                }
            } else {
                request.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không đúng!");
                request.getRequestDispatcher("customer/login.jsp").forward(request, response);
            }
        } else if (path.equals("/signup")) {
            String userStr = request.getParameter("username");
            String passStr = request.getParameter("password");
            String nameStr = request.getParameter("fullName");
            String emailStr = request.getParameter("email");
            String phoneStr = request.getParameter("phone");
            
            if (userDAO.getUserByUsername(userStr) != null) {
                request.setAttribute("error", "Tên đăng nhập đã tồn tại!");
                request.getRequestDispatcher("customer/signup.jsp").forward(request, response);
                return;
            }
            
            User newUser = new User(userStr, passStr, nameStr, "customer", emailStr, phoneStr);
            if (userDAO.register(newUser)) {
                request.setAttribute("success", "Đăng ký thành công! Hãy đăng nhập.");
                request.getRequestDispatcher("customer/login.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Lỗi đăng ký tài khoản. Vui lòng thử lại!");
                request.getRequestDispatcher("customer/signup.jsp").forward(request, response);
            }
        }
    }
}
