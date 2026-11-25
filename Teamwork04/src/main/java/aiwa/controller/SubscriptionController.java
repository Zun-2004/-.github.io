package aiwa.controller;

import java.io.IOException;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/SubscriptionController")
public class SubscriptionController extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("user_id") == null) {
			response.sendRedirect("LoginController");
			return;
		}

		synchronized (session) {
			if (session.getAttribute("demoSubscriptionToken") == null) {
				session.setAttribute("demoSubscriptionToken", UUID.randomUUID().toString());
			}
		}
		request.getRequestDispatcher("/subscription.jsp").forward(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("user_id") == null) {
			response.sendRedirect("LoginController");
			return;
		}

		String token = (String) session.getAttribute("demoSubscriptionToken");
		if (token == null || !token.equals(request.getParameter("token"))) {
			response.sendError(HttpServletResponse.SC_FORBIDDEN);
			return;
		}

		session.setAttribute("demoPremium", true);
		response.sendRedirect("LessonListController");
	}
}
