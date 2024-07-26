import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;
import com.google.gson.Gson;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.Unmarshaller;

@WebServlet("/SubmitMarksServlet")
public class SubmitMarksServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String contentType = request.getContentType();
        MarkEntry[] marks = null;

        if (contentType.contains("application/json")) {

            StringBuilder sb = new StringBuilder();
            String s;
            while ((s = request.getReader().readLine()) != null) {
                sb.append(s);
            }
            Gson gson = new Gson();
            marks = gson.fromJson(sb.toString(), MarkEntry[].class);
        } else if (contentType.contains("application/xml")) {
            
            JAXBContext jaxbContext = JAXBContext.newInstance(MarkEntry[].class);
            Unmarshaller unmarshaller = jaxbContext.createUnmarshaller();
            marks = (MarkEntry[]) unmarshaller.unmarshal(request.getReader());
        }

        if (marks == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Unsupported content type: " + contentType);
            return;
        }

        try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/IIS", "root", "")) {
            String query = "INSERT INTO internal_marks (student_id, course_id, marks) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE marks = ?";
            PreparedStatement pst = con.prepareStatement(query);

            for (MarkEntry mark : marks) {
                pst.setString(1, mark.studentId);
                pst.setString(2, mark.courseId);
                pst.setInt(3, Integer.parseInt(mark.mark));
                pst.setInt(4, Integer.parseInt(mark.mark));
                pst.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Database error: " + e.getMessage());
        }
    }

    static class MarkEntry {
        String studentId;
        String courseId;
        String mark;
    }
}