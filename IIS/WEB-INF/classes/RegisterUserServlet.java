import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/RegisterUserServlet")
public class RegisterUserServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();

		String role = request.getParameter("role");
		String id = role.equals("student") ? request.getParameter("studentRegNo") : request.getParameter("teacherId");
		String password = request.getParameter("password");
		String confirmPassword = request.getParameter("confirmPassword");


		Connection conn = null;
		PreparedStatement pst = null;
		ResultSet rs = null;

		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/IIS", "root", "");

			// Check if user already exists
			String checkUser = "SELECT * FROM users WHERE username = ?";
			pst = conn.prepareStatement(checkUser);
			pst.setString(1, id);
			rs = pst.executeQuery();

			if (rs.next()) {
				response.sendRedirect("login.jsp?error=user_already_registered");
                return;
			}

			// If user does not exist, proceed with registration
			String sql = "INSERT INTO users (username, password,role) VALUES (?, ?, ?)";
			pst = conn.prepareStatement(sql);
			pst.setString(1, id);
			pst.setString(2, password);
			pst.setString(3, role);
			int result = pst.executeUpdate();

			if (result > 0) {
				response.sendRedirect("login.jsp?success=registration_successful");
			} else {
				response.sendRedirect("enrollment.jsp?error=registration_failed");
			}
		} catch (Exception e) {
			response.sendRedirect("enrollment.jsp?error=server_error");
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pst != null)
					pst.close();
				if (conn != null)
					conn.close();
			} catch (SQLException ex) {
				out.println("<html><body>");
				out.println("<p>Error closing resources: " + ex.getMessage() + "</p>");
				out.println("</body></html>");
			}
		}
	}
}
