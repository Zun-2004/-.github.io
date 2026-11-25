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

import aiwa.entity.Flashcard;
import aiwa.entity.Lesson;
import aiwa.model.FlashcardModel;
import aiwa.model.LanguageModel;
import aiwa.model.LessonModel;

@WebServlet("/LessonDetailController")
public class LessonDetailController extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		Integer uid = (session == null) ? null : (Integer) session.getAttribute("user_id");
		if (uid == null) {
			response.sendRedirect("LoginController");
			return;
		}

		int lessonId;
		try {
			lessonId = Integer.parseInt(request.getParameter("id"));
		} catch (NumberFormatException e) {
			response.sendRedirect("LessonListController");
			return;
		}

		try {
			int[] selection = new LanguageModel().findSelection(getServletContext(), uid);
			if (selection == null) {
				response.sendRedirect("LanguageController");
				return;
			}

			Lesson lesson = new LessonModel().findById(getServletContext(), lessonId);
			if (lesson == null) {
				response.sendRedirect("LessonListController");
				return;
			}
			if (lesson.isPremium()) {
				response.sendRedirect("subscription.jsp?lessonNo=" + lesson.getLessonNo());
				return;
			}

			ArrayList<Flashcard> cards = new FlashcardModel().findByLesson(getServletContext(), lessonId, selection[0]);

			ArrayList<Lesson> allLessons = new LessonModel().findByLanguage(getServletContext(), selection[1]);
			Integer nextLessonId = null;
			if (allLessons != null) {
				for (int i = 0; i < allLessons.size() - 1; i++) {
					if (allLessons.get(i).getLessonId() == lesson.getLessonId()) {
						nextLessonId = allLessons.get(i + 1).getLessonId();
						break;
					}
				}
			}

			request.setAttribute("lesson", lesson);
			request.setAttribute("flashcards", cards);
			request.setAttribute("nextLessonId", nextLessonId);
			request.setAttribute("quizLangId", selection[1]);
		} catch (SQLException e) {
			throw new ServletException(e);
		}

		request.getRequestDispatcher("/lessonDetailView.jsp").forward(request, response);
	}
}