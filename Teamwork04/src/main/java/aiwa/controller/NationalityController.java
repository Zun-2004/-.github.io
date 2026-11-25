package aiwa.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/NationalityController")
public class NationalityController extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	
		try {
			HttpSession session = request.getSession(false);
			
			if (session == null || session.getAttribute("userId") == null) {
				response.sendRedirect("login.jsp");
				return;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			
			request.setCharacterEncoding("UTF-8");
			HttpSession session = request.getSession(false);
			
			if (session == null || session.getAttribute("userId") == null) {
				response.sendRedirect("login.jsp");
				return;
			}
			
			int userId = (Integer) session.getAttribute("userId");
			
			String nationality = request.getParameter("nationality");
			
			if (nationality == null || nationality.isBlank()) {
				
				request.setAttribute("message", "Please Select Your Nationality");
				
				request.getRequestDispatcher("nationality.jsp").forward(request, response);
				
			}
			
			String[] allowed = {
					"Myanmar", "English", "Japan", "China", "Korea"
			};
			
			boolean valid = false;
			
			for (String country : allowed) {
				if (country.equals(nationality)) {
					valid = true;
					break;
				}
			}
			
			if (!valid) {
				request.setAttribute("message", "Invalid nationality");
				
				request.getRequestDispatcher("nationality.jsp");
				
				return;
			}
			
		}catch(Exception e) {
			e.printStackTrace();
		}
	}

}
