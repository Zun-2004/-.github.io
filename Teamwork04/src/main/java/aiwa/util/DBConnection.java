package aiwa.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import javax.servlet.ServletContext;

public class DBConnection {

	public static Connection getConnection(ServletContext context) throws SQLException {
		try {
			Class.forName("org.sqlite.JDBC");
		} catch (ClassNotFoundException e) {
			throw new SQLException("SQLite driver not found", e);
		}
		String dbPath = context.getRealPath("/WEB-INF/teamwork04.db");
		return DriverManager.getConnection("jdbc:sqlite:" + dbPath);
	}
}