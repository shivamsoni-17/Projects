import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/FetchStudentsServlet")
public class FetchStudentsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String courseId = request.getParameter("courseId");
        String teacherId = (String) request.getSession().getAttribute("username"); // Assuming username is the teacher ID

        Connection con = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/IIS", "root", "");

            // Query to get semester and department based on the course ID and teacher ID
            String sql = "SELECT semester, department FROM faculty_assignment WHERE course_id=? AND teacher_id=?";
            pst = con.prepareStatement(sql);
            pst.setString(1, courseId);
            pst.setString(2, teacherId);
            rs = pst.executeQuery();

            if (rs.next()) {
                String semester = rs.getString("semester");
                String department = rs.getString("department");

                sql = "SELECT registration_number, name FROM students WHERE semester=? AND department=?";
                pst = con.prepareStatement(sql);
                pst.setString(1, semester);
                pst.setString(2, department);
                rs = pst.executeQuery();

                StringBuilder sb = new StringBuilder("<table><tr><th>Student ID</th><th>Name</th><th>Marks</th></tr>");
                while (rs.next()) {
                    sb.append("<tr><td>").append(rs.getString("registration_number"))
                    .append("</td><td>").append(rs.getString("name"))
                    .append("</td><td><input type='text' name='mark_")
                    .append(rs.getString("registration_number")).append("'></td></tr>");
                }
                sb.append("</table>");
                response.getWriter().write(sb.toString());
            } else {
                response.getWriter().write("No students found for the selected course.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Error: " + e.getMessage());
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (pst != null) pst.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}