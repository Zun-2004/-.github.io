
package aiwa.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import aiwa.util.DBConnection;
import aiwa.util.PasswordUtil;

@WebServlet("/LoginController")
public class LoginController extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.getRequestDispatcher("/login.jsp").forward(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		String email = request.getParameter("email");
		String password = request.getParameter("password");

		// Check empty fields
		if (email == null || email.trim().isEmpty()
				|| password == null || password.isEmpty()) {

			response.sendRedirect("login.jsp?error=empty");
			return;
		}

		String sql = "SELECT userid, username, email, password_hash FROM users WHERE email = ?";

		try (Connection connection = DBConnection.getConnection(getServletContext());
				PreparedStatement ps = connection.prepareStatement(sql)) {

			ps.setString(1, email.trim());

			try (ResultSet rs = ps.executeQuery()) {

				if (rs.next()) {

					String storedHash = rs.getString("password_hash");

					if (PasswordUtil.verifyPassword(
							password, storedHash)) {

						HttpSession session = request.getSession();
						request.changeSessionId();
						session.removeAttribute("demoPremium");
						session.removeAttribute("demoSubscriptionToken");
						session.removeAttribute("quizQuestions");
						session.removeAttribute("quizLessonId");

						session.setAttribute("user_id",
								rs.getInt("userid"));

						session.setAttribute("username",
								rs.getString("username"));

						session.setAttribute("email",
								rs.getString("email"));

						response.sendRedirect("LanguageController");
						return;
					}
				}
			}

			response.sendRedirect("login.jsp?error=invalid");

		} catch (Exception e) {

			e.printStackTrace();

			response.sendError(
					HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
					"Login error. Please check the server console.");
		}
	}
}
