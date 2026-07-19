package controller.doctor;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/** MEMBER 3 TODO: doctor queue, treatment, diagnosis and prescriptions. */
@WebServlet(name = "DoctorServlet", urlPatterns = {"/doctor"})
public class DoctorServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // TODO MEMBER 3: validate doctor role and load appointments/treatment data.
        request.getRequestDispatcher("doctor/doctor_dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // TODO MEMBER 3: start examination, save diagnosis/services/prescriptions.
        response.sendError(HttpServletResponse.SC_NOT_IMPLEMENTED,
                "TODO Member 3: Doctor workflow is not implemented.");
    }
}
