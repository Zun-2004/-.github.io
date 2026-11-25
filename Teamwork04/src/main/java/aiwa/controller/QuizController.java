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

		try (Connection conn = DBConnection.getConnection(getServletContext())) {
			List<QuizModel> questions = generateAllLessonsQuiz(conn, languageId, 10);

			HttpSession session = request.getSession();
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
		String sql = "SELECT qt.quizid, qt.question, qt.option_a, qt.option_b, qt.option_c, qt.option_d, q.correct_answer "
				+ "FROM quiz_translations qt "
				+ "JOIN quizzes q ON qt.quizid = q.quizid "
				+ "WHERE qt.languageid = ? "
				+ "ORDER BY q.lessonid, q.questionnumber";

		List<QuizModel> allQuestions = new ArrayList<>();

		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, languageId);
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