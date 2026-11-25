package aiwa.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import aiwa.entity.Language;
import aiwa.model.LanguageModel;

@WebServlet("/LanguageController")
public class LanguageController extends HttpServlet {

	private Integer currentUserId(HttpServletRequest request) {
		HttpSession session = request.getSession(false);
		return session == null ? null : (Integer) session.getAttribute("user_id");
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		Integer uid = currentUserId(request);
		if (uid == null) {
			response.sendRedirect("LoginController");
			return;
		}

		try {
			LanguageModel model = new LanguageModel();
			request.setAttribute("natives", model.findNative(getServletContext()));
			request.setAttribute("learnings", model.findAll(getServletContext()));
			request.setAttribute("current", model.findSelection(getServletContext(), uid));
		} catch (SQLException e) {
			throw new ServletException(e);
		}

		request.getRequestDispatcher("/selectLanguage.jsp").forward(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		Integer uid = currentUserId(request);
		if (uid == null) {
			response.sendRedirect("LoginController");
			return;
		}

		int nativeId;
		int learningId;
		try {
			nativeId = Integer.parseInt(request.getParameter("native"));
			learningId = Integer.parseInt(request.getParameter("learning"));
		} catch (NumberFormatException e) {
			response.sendRedirect("LanguageController?err=invalid");
			return;
		}

		if (nativeId == learningId) {
			response.sendRedirect("LanguageController?err=same");
			return;
		}

		try {
			LanguageModel model = new LanguageModel();

			if (!contains(model.findNative(getServletContext()), nativeId)
					|| !contains(model.findAll(getServletContext()), learningId)) {
				response.sendRedirect("LanguageController?err=invalid");
				return;
			}

			model.saveSelection(getServletContext(), uid, nativeId, learningId);
		} catch (SQLException e) {
			throw new ServletException(e);
		}

		response.sendRedirect("LessonListController");
	}

	private boolean contains(List<Language> list, int id) {
		for (Language l : list) {
			if (l.getLanguageId() == id)
				return true;
		}
		return false;
	}
}