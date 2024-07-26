import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@WebServlet("/RegisterCourseServlet")
public class RegisterCourseServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String studentId = (String) session.getAttribute("username");
        Connection con = null;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/IIS", "root", "");
            con.setAutoCommit(false);

            for (String key : request.getParameterMap().keySet()) {
                if (key.startsWith("teacher_")) {
                    String courseId = key.substring(8);
                    String teacherName = request.getParameter(key);
                    String insertSql = "INSERT INTO enrollment (student_id, course_id, teacher) VALUES (?, ?, ?)";
                    try (PreparedStatement pstmt = con.prepareStatement(insertSql)) {
                        pstmt.setString(1, studentId);
                        pstmt.setString(2, courseId);
                        pstmt.setString(3, teacherName);
                        pstmt.executeUpdate();
                    }
                }
            }
            con.commit();
            response.sendRedirect("registrationSuccess.jsp");
        } catch (Exception e) {
            if (con != null) try { con.rollback(); } catch(Exception ex) {}
            throw new ServletException("Registration failed", e);
        } finally {
            if (con != null) try { con.close(); } catch(Exception e) {}
        }
    }
}