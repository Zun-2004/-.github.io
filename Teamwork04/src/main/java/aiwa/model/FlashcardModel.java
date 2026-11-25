package aiwa.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.servlet.ServletContext;

import aiwa.entity.Flashcard;
import aiwa.util.DBConnection;

public class FlashcardModel {

	public ArrayList<Flashcard> findByLesson(ServletContext context, int lessonId, int nativeLanguageId)
			throws SQLException {
		ArrayList<Flashcard> list = new ArrayList<>();
		String sql = "select f.flashcardid, f.word, t.translatedword "
				+ "from flashcards f "
				+ "left join flashcard_translations t "
				+ "  on t.flashcardid = f.flashcardid and t.languageid = ? "
				+ "where f.lessonid = ? order by f.cardnumber, f.flashcardid";

		try (Connection conn = DBConnection.getConnection(context);
				PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setInt(1, nativeLanguageId);
			stmt.setInt(2, lessonId);
			try (ResultSet rs = stmt.executeQuery()) {
				while (rs.next()) {
					Flashcard f = new Flashcard();
					f.setFlashcardId(rs.getInt("flashcardid"));
					f.setWord(rs.getString("word"));
					f.setTranslated(rs.getString("translatedword"));
					list.add(f);
				}
			}
		}
		return list;
	}
}
