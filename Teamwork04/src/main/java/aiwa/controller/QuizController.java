package aiwa.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import aiwa.model.LanguageModel;
import aiwa.model.QuizModel;
import aiwa.util.DBConnection;

@WebServlet("/quiz")
public class QuizController extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");

		int languageId = 1;
		String langParam = request.getParameter("lang");
		if (langParam != null && !langParam.trim().isEmpty()) {
			try {
				languageId = Integer.parseInt(langParam.trim());
			} catch (NumberFormatException ignored) {
			}
		}

		HttpSession session = request.getSession();
		Integer lessonId = null;
		Integer courseLanguageId = null;
		boolean premium = session.getAttribute("user_id") != null
				&& Boolean.TRUE.equals(session.getAttribute("demoPremium"));

		try (Connection conn = DBConnection.getConnection(getServletContext())) {
			String lessonParam = request.getParameter("lessonId");
			if (lessonParam != null) {
				Integer userId = (Integer) session.getAttribute("user_id");
				if (userId == null) {
					response.sendRedirect("LoginController");
					return;
				}
				try {
					lessonId = Integer.valueOf(lessonParam);
				} catch (NumberFormatException e) {
					response.sendError(HttpServletResponse.SC_BAD_REQUEST);
					return;
				}

				int[] selection = new LanguageModel().findSelection(getServletContext(), userId);
				if (selection == null) {
					response.sendRedirect("LanguageController");
					return;
				}
				languageId = selection[0];
				courseLanguageId = selection[1];
			}

			List<QuizModel> questions = loadQuiz(conn, languageId, courseLanguageId,
					lessonId, premium, lessonId == null ? 10 : 5);
			session.setAttribute("quizLessonId", lessonId);
			session.setAttribute("quizQuestions", questions);
			session.setAttribute("quizLang", languageId);

			request.setAttribute("questions", questions);
			request.setAttribute("lang", languageId);
			request.getRequestDispatcher("/quiz.jsp").forward(request, response);
		} catch (Exception e) {
			e.printStackTrace();
			throw new ServletException("Failed to load quiz", e);
		}
	}

	@Override
	@SuppressWarnings("unchecked")
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");

		HttpSession session = request.getSession();
		List<QuizModel> questions = (List<QuizModel>) session.getAttribute("quizQuestions");

		int score = 0;
		int total = (questions != null) ? questions.size() : 0;

		if (questions != null) {
			for (int i = 0; i < questions.size(); i++) {
				String userAnswer = request.getParameter("q_" + i);
				if (userAnswer != null && userAnswer.equals(questions.get(i).getCorrectAnswer())) {
					score++;
				}
			}
			request.setAttribute("questions", questions);
		}

		request.setAttribute("score", score);
		request.setAttribute("total", total);
		request.setAttribute("submitted", true);
		request.getRequestDispatcher("/quiz.jsp").forward(request, response);
	}

	public List<QuizModel> generateAllLessonsQuiz(Connection conn, int languageId, int questionCount)
			throws Exception {
		return loadQuiz(conn, languageId, null, null, false, questionCount);
	}

	private List<QuizModel> loadQuiz(Connection conn, int languageId, Integer courseLanguageId,
			Integer lessonId, boolean premium, int questionCount) throws Exception {
		String sql = "SELECT q.quizid, COALESCE(qt.question, q.question) AS question, "
				+ "COALESCE(qt.option_a, q.option_a) AS option_a, "
				+ "COALESCE(qt.option_b, q.option_b) AS option_b, "
				+ "COALESCE(qt.option_c, q.option_c) AS option_c, "
				+ "COALESCE(qt.option_d, q.option_d) AS option_d, q.correct_answer "
				+ "FROM quizzes q JOIN lessons l ON l.lessonid = q.lessonid "
				+ "LEFT JOIN quiz_translations qt ON qt.quizid = q.quizid AND qt.languageid = ? "
				+ "WHERE (l.is_premium = 0 OR ? = 1) "
				+ (lessonId == null ? "AND qt.quizid IS NOT NULL "
						: "AND q.lessonid = ? AND l.languageid = ? ")
				+ "ORDER BY q.lessonid, q.questionnumber";

		List<QuizModel> allQuestions = new ArrayList<>();

		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, languageId);
			ps.setInt(2, premium ? 1 : 0);
			if (lessonId != null) {
				ps.setInt(3, lessonId);
				ps.setInt(4, courseLanguageId);
			}
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					int quizId = rs.getInt("quizid");
					String question = rs.getString("question");
					String optA = rs.getString("option_a");
					String optB = rs.getString("option_b");
					String optC = rs.getString("option_c");
					String optD = rs.getString("option_d");
					String correctCode = rs.getString("correct_answer");

					List<String> options = new ArrayList<>();
					if (optA != null && !optA.trim().isEmpty())
						options.add(optA.trim());
					if (optB != null && !optB.trim().isEmpty())
						options.add(optB.trim());
					if (optC != null && !optC.trim().isEmpty())
						options.add(optC.trim());
					if (optD != null && !optD.trim().isEmpty())
						options.add(optD.trim());

					String correctAnswer = "";
					if (correctCode != null) {
						switch (correctCode.trim().toUpperCase()) {
						case "A":
							correctAnswer = (optA != null) ? optA.trim() : "";
							break;
						case "B":
							correctAnswer = (optB != null) ? optB.trim() : "";
							break;
						case "C":
							correctAnswer = (optC != null) ? optC.trim() : "";
							break;
						case "D":
							correctAnswer = (optD != null) ? optD.trim() : "";
							break;
						default:
							correctAnswer = correctCode.trim();
							break;
						}
					}

					allQuestions.add(new QuizModel(quizId, question, correctAnswer, options));
				}
			}
		}

		Collections.shuffle(allQuestions);
		int limit = Math.min(questionCount, allQuestions.size());
		return new ArrayList<>(allQuestions.subList(0, limit));

	}
}