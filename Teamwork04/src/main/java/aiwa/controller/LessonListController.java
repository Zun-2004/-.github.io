package aiwa.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import aiwa.entity.Lesson;
import aiwa.model.LanguageModel;
import aiwa.model.LessonModel;

@WebServlet("/LessonListController")
public class LessonListController extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		Integer uid = (session == null) ? null : (Integer) session.getAttribute("user_id");
		if (uid == null) {
			response.sendRedirect("LoginController");
			return;
		}

		try {
			int[] selection = new LanguageModel().findSelection(getServletContext(), uid);
			if (selection == null) {
				response.sendRedirect("LanguageController");
				return;
			}

			ArrayList<Lesson> lessons = new LessonModel().findByLanguage(getServletContext(), selection[1]);
			request.setAttribute("lessons", lessons);

		} catch (SQLException e) {
			throw new ServletException(e);
		}

		request.getRequestDispatcher("/LessonListView.jsp").forward(request, response);
	}
}