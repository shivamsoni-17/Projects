<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String role = request.getParameter("role");
    String id = request.getParameter("id");
    Connection conn = null;
    PreparedStatement pst = null;
    ResultSet rs = null;
    String sql = "";
    try {
        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/IIS", "root", "");
        if ("student".equals(role)) {
            sql = "SELECT name, section, department, year, course FROM students WHERE registration_number = ?";
        } else if ("teacher".equals(role)) {
            sql = "SELECT name, department, post FROM teachers WHERE teacher_id = ?";
        }
        if (!sql.isEmpty()) {
            pst = conn.prepareStatement(sql);
            pst.setString(1, id);
            rs = pst.executeQuery();
            if (rs.next()) {
                out.println("<label>Name:</label><input type='text' value='" + rs.getString("name") + "' readonly/><br/></br>");
                out.println("<label>Department:</label><input type='text' value='" + rs.getString("department") + "' readonly/><br/></br>");
                if ("student".equals(role)) {
                    out.println("<label>Section:</label><input type='text' value='" + rs.getString("section") + "' readonly/><br/></br>");
                    out.println("<label>Batch:</label><input type='text' value='" + rs.getString("year") + "' readonly/><br/></br>");
                    out.println("<label>Course:</label><input type='text' value='" + rs.getString("course") + "' readonly/><br/></br>");
                } else {
                    out.println("<label>Post:</label><input type='text' value='" + rs.getString("post") + "' readonly/><br/></br>");
                }
            } else {
                out.println("<p>No records found. Please check the ID and try again.</p>");
            }
        }
    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) {}
        if (pst != null) try { pst.close(); } catch (SQLException e) {}
        if (conn != null) try { conn.close(); } catch (SQLException e) {}
    }
%>