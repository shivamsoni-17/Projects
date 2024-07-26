import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

@WebServlet("/StudentUploadServlet")
@MultipartConfig
public class StudentUploadServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Get the uploaded file
        Part filePart = request.getPart("image"); // This line was causing the error without proper configuration
        if (filePart != null) {
            // Obtain input stream
            InputStream inputStream = filePart.getInputStream();

            Connection conn = null;
            PreparedStatement pstmt = null;
            try {
                // Connect to the database
                Class.forName("com.mysql.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/IIS", "root", "");

                // Update the student's image
                String sql = "UPDATE students SET image = ? WHERE registration_number = ?";
                pstmt = conn.prepareStatement(sql);

                // Set parameters
                pstmt.setBlob(1, inputStream);
                pstmt.setString(2, (String) session.getAttribute("username"));

                // Execute update
                int row = pstmt.executeUpdate();
                if (row > 0) {
                    response.sendRedirect("studentInterface.jsp?status=uploadsuccess");
                } else {
                    response.sendRedirect("studentInterface.jsp?status=uploadfail");
                }
            } catch (Exception e) {
                response.getWriter().append("SQL Error: ").append(e.getMessage());
            } finally {
                if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
                if (conn != null) try { conn.close(); } catch (Exception e) {}
                if (inputStream != null) try { inputStream.close(); } catch (Exception e) {}
            }
        }
    }
}