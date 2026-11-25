
package aiwa.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import aiwa.util.DBConnection;
import aiwa.util.PasswordUtil;

@WebServlet("/RegisterController")
public class RegisterController extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.getRequestDispatcher("/register.jsp").forward(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		String username = request.getParameter("username");
		String email = request.getParameter("email");
		String password = request.getParameter("password");

		if (username == null || username.trim().isEmpty()
				|| email == null || email.trim().isEmpty()
				|| password == null || password.isEmpty()) {

			request.setAttribute("msg", "Username, Email, Password အားလုံးဖြည့်ပါ။");
			request.getRequestDispatcher("/register.jsp").forward(request, response);
			return;
		}

		String sql = "INSERT INTO users (username, email, password_hash) VALUES (?, ?, ?)";

		try {
			String hashedPassword = PasswordUtil.hashPassword(password);

			try (Connection connection = DBConnection.getConnection(getServletContext());
					PreparedStatement ps = connection.prepareStatement(sql)) {

				ps.setString(1, username.trim());
				ps.setString(2, email.trim());
				ps.setString(3, hashedPassword);
				ps.executeUpdate();
			}

			response.sendRedirect("LoginController");

		} catch (Exception e) {
			e.printStackTrace();
			request.setAttribute("msg", "Can't create account");
			request.getRequestDispatcher("/register.jsp").forward(request, response);
		}
	}
}