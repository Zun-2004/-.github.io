package service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import aiwa.model.QuizModel;

public class QuizService {

	public List<QuizModel> generateAllLessonsQuiz(Connection conn, int languageId, int questionCount) throws Exception {
		String sql = "SELECT f.flashcardid, f.word, t.translatedword "
				+ "FROM flashcards f "
				+ "Join lessons l on f.lessonid=l.lessonid"
				+ "JOIN flashcard_translations t ON f.flashcardid = t.flashcardid "
				+ "where l.languageid=?"
				+ "WHERE t.languageid = ? "
				+ "AND t.translatedword IS NOT NULL "
				+ "AND TRIM(t.translatedword) != '' "
				+ "AND TRIM(t.translatedword) != '-'";

		Map<Integer, String[]> pool = new LinkedHashMap<>();

		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, languageId);
			ps.setInt(2, languageId);

			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					int id = rs.getInt("flashcardid");
					String word = rs.getString("word");
					String answer = rs.getString("translatedword").trim();
					pool.put(id, new String[] { word, answer });
				}
			}
		}

		List<Integer> ids = new ArrayList<>(pool.keySet());
		Collections.shuffle(ids);

		int limit = Math.min(questionCount, ids.size());
		List<QuizModel> questions = new ArrayList<>();

		for (int i = 0; i < limit; i++) {
			int currentId = ids.get(i);
			String promptWord = pool.get(currentId)[0];
			String correctAnswer = pool.get(currentId)[1];

			List<String> distractors = new ArrayList<>();
			for (Map.Entry<Integer, String[]> entry : pool.entrySet()) {
				if (entry.getKey() != currentId) {
					String candidate = entry.getValue()[1];
					if (!candidate.equals(correctAnswer) && !distractors.contains(candidate)) {
						distractors.add(candidate);
					}
				}
			}
			Collections.shuffle(distractors);

			List<String> options = new ArrayList<>();
			options.add(correctAnswer);
			for (int j = 0; j < Math.min(3, distractors.size()); j++) {
				options.add(distractors.get(j));
			}
			Collections.shuffle(options);

			questions.add(new QuizModel(currentId, promptWord, correctAnswer, options));
		}

		return questions;
	}
}
