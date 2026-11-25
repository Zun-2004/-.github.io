package aiwa.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletContext;

import aiwa.entity.Language;
import aiwa.util.DBConnection;

public class LanguageModel {

	public List<Language> findAll(ServletContext context) throws SQLException {
		return query(context,
				"select languageid, languagename, languagecode from languages order by languageid");
	}

	public List<Language> findNative(ServletContext context) throws SQLException {
		return query(context,
				"select languageid, languagename, languagecode from languages "
						+ "where languagecode in ('my','en','ja') order by languageid");
	}

	private List<Language> query(ServletContext context, String sql) throws SQLException {
		List<Language> list = new ArrayList<>();
		try (Connection conn = DBConnection.getConnection(context);
				PreparedStatement stmt = conn.prepareStatement(sql);
				ResultSet rs = stmt.executeQuery()) {
			while (rs.next()) {
				Language l = new Language();
				l.setLanguageId(rs.getInt("languageid"));
				l.setLanguageName(rs.getString("languagename"));
				l.setLanguageCode(rs.getString("languagecode"));
				list.add(l);
			}
		}
		return list;
	}

	public int[] findSelection(ServletContext context, int userId) throws SQLException {
		String sql = "select nativeLanguageid, learningLanguageid from user_languages "
				+ "where userid=? order by selectionid desc limit 1";
		try (Connection conn = DBConnection.getConnection(context);
				PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setInt(1, userId);
			try (ResultSet rs = stmt.executeQuery()) {
				if (rs.next()) {
					return new int[] { rs.getInt("nativeLanguageid"), rs.getInt("learningLanguageid") };
				}
			}
		}
		return null;
	}

	public void saveSelection(ServletContext context, int userId, int nativeId, int learningId)
			throws SQLException {
		try (Connection conn = DBConnection.getConnection(context)) {
			conn.setAutoCommit(false);
			try (PreparedStatement del = conn.prepareStatement("delete from user_languages where userid=?");
					PreparedStatement ins = conn.prepareStatement(
							"insert into user_languages(userid, nativeLanguageid, learningLanguageid) "
									+ "values(?,?,?)")) {

				del.setInt(1, userId);
				del.executeUpdate();

				ins.setInt(1, userId);
				ins.setInt(2, nativeId);
				ins.setInt(3, learningId);
				ins.executeUpdate();

				conn.commit();
			} catch (SQLException e) {
				conn.rollback();
				throw e;
			}
		}
	}
}
