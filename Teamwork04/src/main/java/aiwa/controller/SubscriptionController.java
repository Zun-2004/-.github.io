
package aiwa.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import aiwa.model.UserModel;

@WebServlet("/SubscriptionController")
public class SubscriptionController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private UserModel model = new UserModel();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check whether the user is logged in
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int userId = (Integer) session.getAttribute("userId");

            // Get current subscription
            String subscription = model.getSubscription(
                    getServletContext(), userId);

            session.setAttribute("subscription", subscription);

            request.getRequestDispatcher("subscription.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check whether the user is logged in
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int userId = (Integer) session.getAttribute("userId");

            // Update subscription
            boolean result = model.updateSubscription(
                    getServletContext(), userId);

            if (result) {
                session.setAttribute("subscription", "PREMIUM");

                response.sendRedirect("SubscriptionController");

            } else {
                request.setAttribute("message", "Subscription failed");

                request.getRequestDispatcher("subscription.jsp")
                        .forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();

            request.setAttribute("message", "An error occurred while updating subscription.");

            request.getRequestDispatcher("subscription.jsp")
                    .forward(request, response);
        }
    }
}
