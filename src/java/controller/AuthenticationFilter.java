package controller;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;

/**
 * Protects pages that require login and checks role-based access.
 *
 * Public pages such as home, login, signup and services are allowed without a
 * session. Protected requests must contain a User object in the session.
 */
@WebFilter(filterName = "AuthenticationFilter", urlPatterns = {"/*"})
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // No initialization is required.
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
            FilterChain chain) throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String contextPath = httpRequest.getContextPath();
        String requestPath = httpRequest.getRequestURI().substring(contextPath.length());

        if (isPublicPath(requestPath) || !isProtectedPath(requestPath)) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = httpRequest.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("user");

        if (user == null) {
            httpResponse.sendRedirect(contextPath + "/login");
            return;
        }

        if (!hasPermission(user, requestPath)) {
            session.setAttribute("errorMessage", "Bạn không có quyền truy cập chức năng này!");
            httpResponse.sendRedirect(contextPath + dashboardFor(user.getRole()));
            return;
        }

        // Prevent protected pages from being displayed from browser cache after logout.
        httpResponse.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        httpResponse.setHeader("Pragma", "no-cache");
        httpResponse.setDateHeader("Expires", 0);

        chain.doFilter(request, response);
    }

    private boolean isPublicPath(String path) {
        return path.equals("")
                || path.equals("/")
                || path.equals("/home")
                || path.equals("/login")
                || path.equals("/signup")
                || path.equals("/logout")
                || path.equals("/services")
                || path.equals("/index.jsp")
                || path.equals("/header.jsp")
                || path.equals("/footer.jsp")
                || path.equals("/customer/home.jsp")
                || path.equals("/customer/login.jsp")
                || path.equals("/customer/signup.jsp")
                || path.equals("/customer/services.jsp")
                || path.equals("/favicon.ico")
                || isStaticResource(path);
    }

    private boolean isStaticResource(String path) {
        String lowerPath = path.toLowerCase();
        return lowerPath.endsWith(".css")
                || lowerPath.endsWith(".js")
                || lowerPath.endsWith(".png")
                || lowerPath.endsWith(".jpg")
                || lowerPath.endsWith(".jpeg")
                || lowerPath.endsWith(".gif")
                || lowerPath.endsWith(".svg")
                || lowerPath.endsWith(".ico")
                || lowerPath.endsWith(".woff")
                || lowerPath.endsWith(".woff2")
                || lowerPath.endsWith(".ttf");
    }

    private boolean isProtectedPath(String path) {
        return path.equals("/admin")
                || path.startsWith("/admin/")
                || path.equals("/doctor")
                || path.startsWith("/doctor/")
                || path.equals("/receptionist")
                || path.startsWith("/receptionist/")
                || path.equals("/customer")
                || path.equals("/profile")
                || path.equals("/billing")
                || path.equals("/customer/customer_dashboard.jsp")
                || path.equals("/customer/profile.jsp")
                || path.equals("/customer/reschedule.jsp");
    }

    private boolean hasPermission(User user, String path) {
        String role = user.getRole();
        if (role == null) {
            return false;
        }

        if (path.equals("/admin") || path.startsWith("/admin/")) {
            // billing.jsp is reached through a server-side forward from /billing.
            return "admin".equals(role);
        }

        if (path.equals("/doctor") || path.startsWith("/doctor/")) {
            return "doctor".equals(role);
        }

        if (path.equals("/receptionist") || path.startsWith("/receptionist/")) {
            return "receptionist".equals(role);
        }

        if (path.equals("/customer")
                || path.equals("/profile")
                || path.equals("/customer/customer_dashboard.jsp")
                || path.equals("/customer/profile.jsp")
                || path.equals("/customer/reschedule.jsp")) {
            return "customer".equals(role);
        }

        if (path.equals("/billing")) {
            return "customer".equals(role) || "receptionist".equals(role);
        }

        return true;
    }

    private String dashboardFor(String role) {
        if ("admin".equals(role)) {
            return "/admin";
        }
        if ("doctor".equals(role)) {
            return "/doctor";
        }
        if ("receptionist".equals(role)) {
            return "/receptionist";
        }
        if ("customer".equals(role)) {
            return "/customer";
        }
        return "/home";
    }

    @Override
    public void destroy() {
        // No resources to release.
    }
}
