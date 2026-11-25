package aiwa.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.servlet.ServletContext;

import aiwa.entity.Lesson;
import aiwa.util.DBConnection;

public class LessonModel {

	public ArrayList<Lesson> findAll(ServletContext context) throws SQLException {
		ArrayList<Lesson> list = new ArrayList<>();
		String sql = "SELECT lessonid, lessonnumber, lessontitle, is_premium "
				+ "FROM lessons ORDER BY lessonnumber";

		try (Connection conn = DBConnection.getConnection(context);
				PreparedStatement stmt = conn.prepareStatement(sql);
				ResultSet rs = stmt.executeQuery()) {

			while (rs.next()) {
				Lesson l = new Lesson();
				l.setLessonId(rs.getInt("lessonid"));
				l.setLessonNo(rs.getInt("lessonnumber"));
				l.setTitle(rs.getString("lessontitle"));
				l.setPremium(rs.getInt("is_premium") == 1);
				list.add(l);
			}
		}
		return list;
	}

	public ArrayList<Lesson> findByLanguage(ServletContext context, int languageId)
			throws SQLException {
		ArrayList<Lesson> list = new ArrayList<>();
		String sql = "select lessonid, lessonnumber, lessontitle, is_premium "
				+ "from lessons where languageid=? order by lessonnumber";

		try (Connection conn = DBConnection.getConnection(context);
				PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setInt(1, languageId);
			try (ResultSet rs = stmt.executeQuery()) {
				while (rs.next()) {
					Lesson l = new Lesson();
					l.setLessonId(rs.getInt("lessonid"));
					l.setLessonNo(rs.getInt("lessonnumber"));
					l.setTitle(rs.getString("lessontitle"));
					l.setPremium(rs.getInt("is_premium") == 1);
					list.add(l);
				}
			}
		}
		return list;
	}

	public Lesson findById(ServletContext context, int id) throws SQLException {
		String sql = "select lessonid, lessonnumber, lessontitle, is_premium "
				+ "from lessons where lessonid=?";
		try (Connection conn = DBConnection.getConnection(context);
				PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setInt(1, id);
			try (ResultSet rs = stmt.executeQuery()) {
				if (rs.next()) {
					Lesson l = new Lesson();
					l.setLessonId(rs.getInt("lessonid"));
					l.setLessonNo(rs.getInt("lessonnumber"));
					l.setTitle(rs.getString("lessontitle"));
					l.setPremium(rs.getInt("is_premium") == 1);
					return l;
				}
			}
		}
		return null;
	}
}