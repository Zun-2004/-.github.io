package aiwa.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletContext;

import aiwa.util.DBConnection;

public class UserModel {
	
	public boolean updateSubscription(ServletContext context, int userId) {
		
		String sql = "update users set subscription = 'PREMIUM' where id = ?";
		
		try (Connection conn = DBConnection.getConnection(context);
			 PreparedStatement stmt = conn.prepareStatement(sql)){
			
			stmt.setInt(1, userId);
			
			return stmt.executeUpdate() > 0;
			
			
		}catch(Exception e) {
			e.printStackTrace();
			return false;
		}
	}
	
	public String getSubscription (ServletContext context, int userId) {
		
		String sql = "select subscription from users where id = ?";
		
		try (Connection conn = DBConnection.getConnection(context);
			 PreparedStatement stmt = conn.prepareStatement(sql)) {
			
			stmt.setInt(1, userId);
			
				try(ResultSet rs = stmt.executeQuery()) {
					
					if(rs.next()) {
						return rs.getString("subscription");
					}
				}
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		return "Free";
	}

}
