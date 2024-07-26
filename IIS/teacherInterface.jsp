<%@ page import="java.sql.*,java.util.Base64, java.util.List, java.util.ArrayList, java.util.Map, java.util.LinkedHashMap, java.util.Map.Entry" %>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1.
    response.setHeader("Pragma", "no-cache"); // HTTP 1.0.
    response.setDateHeader("Expires", 0); // Proxies.

    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String username = (String) sess.getAttribute("username"); 
    Connection con = null;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/IIS", "root", "");

        if ("POST".equalsIgnoreCase(request.getMethod()) && "attendance".equals(request.getParameter("formType"))) {
            String selectedCourse = request.getParameter("selectedCourse");
            Map<String, String[]> parameters = request.getParameterMap();
            try {
                if (con == null || con.isClosed()) {
                    Class.forName("com.mysql.jdbc.Driver");
                    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/IIS", "root", "");
                }
                for (String key : parameters.keySet()) {
                    if (key.startsWith("attendance_")) {
                        String studentId = key.substring(11); // Extract student ID
                        String attendance = request.getParameter(key); // This will be "Present" if checked
                        // Insert or update attendance in the database
                        String insertSql = "INSERT INTO attendance (student_id, course_id, attendance) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE attendance=?";
                        PreparedStatement insertStmt = con.prepareStatement(insertSql);
                        insertStmt.setString(1, studentId);
                        insertStmt.setString(2, selectedCourse);
                        insertStmt.setString(3, attendance);
                        insertStmt.setString(4, attendance);
                        insertStmt.executeUpdate();
                    }
                }
            } catch (Exception e) {
                out.println("Error: " + e.getMessage());
            } finally {
                if (con != null) try { con.close(); } catch(SQLException e) {}
            }
        }
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        if (con != null) try { con.close(); } catch(SQLException e) {}
    }
%>

<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Teacher Interface</title>
    <style type="text/css">
        * {
            padding: 0;
            margin: 0;
        }
    
        body {
            font-family: Arial, sans-serif;
        }
    
        .top {
            display: flex;
            align-items: center;
            background-color: #959d86;
            box-shadow: 0 1px 8px #888e99;
            padding: 0 20px;
        }
    
        #logo {
            width: 100px;
        }
    
        #heading {
            color: rgb(234, 226, 226);
            font-size: 35px;
            left: 300px;
            margin-left: 340px;
        }
    
        .navbar {
            background-color: #e0e0e0;
            padding: 10px 0;
            border-radius: 10px;
            width: 1100px;
            margin: 30px auto;
            padding: 13px;
        }
    
        .navbar ul {
            list-style: none;
            text-align: center;
        }
    
        .navbar li {
            display: inline;
            margin: 0 50px;
        }
    
        .navbar li a {
            font-size: 1.1rem;
            text-decoration: none;
            text-transform: uppercase;
            font-weight: bold;
            color: #262020;
        }
    
        #rol {
            text-align: center;
            font-size: 20px;
            margin: 15px;
        }
    
        .cards {
            display: flex;
            margin: 30px;
        }
    
        .teacher-details,
        .assignments {
            background-color: #f4f4f4;
            padding: 20px;
            margin: 40px auto;
            border-radius: 10px;
            box-shadow: 0 1px 8px #393a3d;
        }
    
        .teacher-details h2,
        .assignments h2 {
            color: #333;
            margin: 5px;
        }
    
        .teacher-details p {
            color: #666;
            margin: 8px;
        }
    
        .bottom {
            left: 0;
            bottom: 0;
            width: 100%;
            background-color: #959d86;
            color: white;
            text-align: center;
            padding: 10px 0;
        }
    
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
    
        th,
        td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
    
        th {
            background-color: #f2f2f2;
        }
    
        input[type="text"] {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            box-sizing: border-box;
    
        }
    
        input[type="submit"] {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            margin: 20px 0;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
    
        input[type="submit"]:hover {
            background-color: #45a049;
        }
    
        #Enter-Marks,
        #Enter-Attendance,
        #About {
            display: none;
            height: 700px;
        }
    
        #Home {
            height: 500px;
        }
    
        #Enter-Marks table {
            width: 90%;
            margin: 20px auto;
            border-collapse: collapse;
            background-color: #fff;
            box-shadow: 0 2px 3px #ccc;
        }
    
        #Enter-Marks th,
        #Enter-Marks td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: left;
        }
    
        #Enter-Marks th {
            background-color: #4CAF50;
            color: white;
        }
    
        #Enter-Marks input[type="text"],
        #Enter-Attendance input[type="text"] {
            width: 90%;
            padding: 8px;
            margin-top: 5px;
            box-sizing: border-box;
        }
    
        #Enter-Marks input[type="submit"],
        #Enter-Attendance input[type="submit"] {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            margin: 20px 0;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            display: block;
            width: 200px;
            margin: 20px auto;
        }
    
        #Enter-Marks input[type="submit"]:hover {
            background-color: #45a049;
        }
        
        #Enter-Marks h2,
        #Enter-Attendance h2 {
            text-align: center;
            font-size: 30px;
            margin: 15px;
        }
        #selectedCourse {
            margin: 3px auto;
        }
        #Enter-Marks,
        #Enter-Attendance {
            text-align: center; 
        }
    </style>

    <script>
        function setCookie(name, value, days) {
            var expires = "";
            if (days) {
                var date = new Date();
                date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
                expires = "; expires=" + date.toUTCString();
            }
            document.cookie = name + "=" + (value || "") + expires + "; path=/";
        }

        function getCookie(name) {
            var nameEQ = name + "=";
            var ca = document.cookie.split(';');
            for (var i = 0; i < ca.length; i++) {
                var c = ca[i];
                while (c.charAt(0) == ' ') c = c.substring(1, c.length);
                if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length, c.length);
            }
            return null;
        }

        function showSection(sectionId) {
            var sections = ['Home', 'Enter-Marks', 'Enter-Attendance'];
            sections.forEach(function (id) {
                var element = document.getElementById(id);
                if (element) {
                    element.style.display = 'none';
                }
            });
            var activeSection = document.getElementById(sectionId);
            if (activeSection) {
                activeSection.style.display = 'block';
                setCookie('lastVisited', sectionId, 7); // Set cookie to expire in 7 days
            }
        }

        function fetchStudents(courseId) {
            var xhr = new XMLHttpRequest();
            xhr.onreadystatechange = function () {
                if (xhr.readyState == 4 && xhr.status == 200) {
                    document.getElementById("studentsTable").innerHTML = xhr.responseText;
                }
            };
            xhr.open("GET", "FetchStudentsServlet?courseId=" + courseId, true);
            xhr.send();
        }

        function fetchStudentsForAttendance(courseId) {
            var xhr = new XMLHttpRequest();
            xhr.onreadystatechange = function () {
                if (xhr.readyState == 4 && xhr.status == 200) {
                    document.getElementById("attendanceTable").innerHTML = xhr.responseText;
                } else if (xhr.readyState == 4 && xhr.status != 200) {
                    document.getElementById("attendanceTable").innerHTML = "Failed to fetch data.";
                }
            };
            xhr.open("GET", "FetchStudentsForAttendanceServlet?courseId=" + courseId, true);
            xhr.send();
        }

    </script>

</head>

<body>
    <div class="top">
        <img id="logo" src="images/SS.jpeg" alt="logo">
        <pre id="heading">INSTITUTE INFORMATION SYSTEM</pre>
    </div>
    <h3 id="rol">Faculty Portal</h3>
    <nav class="navbar">
        <ul>
            <li><a href="#" onclick="showSection('Home'); return false;">Home</a></li>
            <li><a href="#" onclick="showSection('Enter-Marks'); return false;">Enter Marks</a></li>
            <li><a href="#" onclick="showSection('Enter-Attendance'); return false;">Enter Attendance</a></li>
            <li><a href="http://localhost/feedback.php">LOGOUT</a></li>
        </ul>
    </nav>
    <div id="Home">
        <div class="cards">
            <div class="teacher-details">
                <h2>Teacher Details</h2>
                <%
                HttpSession ses = request.getSession(false);
                if (ses != null && ses.getAttribute("username") != null) {
                String role = (String) ses.getAttribute("role");
                PreparedStatement pst = null;
                ResultSet rs = null;
                try {
                    Class.forName("com.mysql.jdbc.Driver");
                    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/IIS", "root", "");
                    String sql = "SELECT teacher_id, name, department, post, image FROM teachers WHERE teacher_id=?";
                    pst = con.prepareStatement(sql);
                    pst.setString(1, username);
                    rs = pst.executeQuery();
                    if(rs.next()) {
                        byte[] imgData = rs.getBytes("image");
                        if (imgData != null && imgData.length > 0) {
                            String encode = Base64.getEncoder().encodeToString(imgData);
                            %>
                            <div style="text-align: center; margin: 20px;">
                                <img src="data:image/jpeg;base64,<%= encode %>" alt="Student Image" style="width:100px; height:100px; border: 2px solid black; display: block; margin: auto;">
                            </div>
                            <%
                        } else {
                            %>
                            <form action="TeacherUploadServlet" method="post" enctype="multipart/form-data">
                                <input type="file" name="image" required>
                                <button type="submit">Upload Image</button>
                            </form>
                            <%
                        }
                        %>
                    <table>
                        <tr>
                            <th>Teacher Id:</th>
                            <td><%= rs.getString("teacher_id") %></td>
                        </tr>
                        <tr>
                            <th>Name:</th>
                            <td><%= rs.getString("name") %></td>
                        </tr>
                        <tr>
                            <th>Department:</th>
                            <td><%= rs.getString("department") %></td>
                        </tr>
                        <tr>
                            <th>Post:</th>
                            <td><%= rs.getString("post") %></td>
                        </tr>
                    </table>
                    <%
                    }
                } catch(Exception e) {
                    out.println("Error: " + e.getMessage());
                } finally {
                    if (rs != null) try { rs.close(); } catch(SQLException e) {}
                    if (pst != null) try { pst.close(); } catch(SQLException e) {}
                    if (con != null) try { con.close(); } catch(SQLException e) {}
                }
                } else {
                    response.sendRedirect("login.jsp");
                }
                %>
            </div>
            <div class="assignments">
                <h2>Assignments</h2>
                <%
                PreparedStatement pst2 = null;
                ResultSet rs2 = null;
                try {
                    if (con == null || con.isClosed()) {
                        Class.forName("com.mysql.jdbc.Driver");
                        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/IIS", "root", "");
                    }
                    String sql2 = "SELECT semester, department, course_id, course FROM faculty_assignment WHERE teacher_id=?";
                    pst2 = con.prepareStatement(sql2, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    pst2.setString(1, username);
                    rs2 = pst2.executeQuery();
                    if (rs2.next()){
                    %>
                    <table>
                        <tr>
                            <th>Semester</th>
                            <th>Department</th>
                            <th>Course ID</th>
                            <th>Course</th>
                        </tr>
                        <%
                        rs2.previous();
                        while (rs2.next()) {
                            %>
                            <tr>
                                <td><%= rs2.getString("semester") %></td>
                                <td><%= rs2.getString("department") %></td>
                                <td><%= rs2.getString("course_id") %></td>
                                <td><%= rs2.getString("course") %></td>
                            </tr>
                            <%
                        }
                        %>
                    </table>
                    <% 
                    } else {
                    %>
                        <p>No Class Allocated.</p>
                    <%
                    }
                } catch(Exception e) {
                    out.println("Error: " + e.getMessage());
                } finally {
                    if (rs2 != null) try { rs2.close(); } catch(SQLException e) {}
                    if (pst2 != null) try { pst2.close(); } catch(SQLException e) {}
                }
                %>
            </div>
        </div>
    </div>
    <div id="Enter-Marks">  
        <h2>Enter Marks</h2>
        <form>
            <label for="selectedCourse">Select Course:</label>
            <select name="selectedCourse" id="selectedCourse" onchange="fetchStudents(this.value);">
                <option value="">Select a Course</option>
                <%
                PreparedStatement pst3 = null;
                ResultSet rs3 = null;
                try {
                    if (con == null || con.isClosed()) {
                        Class.forName("com.mysql.jdbc.Driver");
                        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/IIS", "root", "");
                    }
                    String sql3 = "SELECT course_id, course FROM faculty_assignment WHERE teacher_id=?";
                    pst3 = con.prepareStatement(sql3);
                    pst3.setString(1, username);
                    rs3 = pst3.executeQuery();
                    while (rs3.next()) {
                        %>
                        <option value="<%= rs3.getString("course_id") %>"><%= rs3.getString("course") %></option>
                        <%
                    }
                } catch(Exception e) {
                    out.println("Error: " + e.getMessage());
                } finally {
                    if (rs3 != null) try { rs3.close(); } catch(SQLException e) {}
                    if (pst3 != null) try { pst3.close(); } catch(SQLException e) {}
                }
                %>
            </select>
            <div id="studentsTable"></div>
            <input type="submit" value="Submit Marks">
        </form>
    </div>
    <div id="Enter-Attendance">
        <h2>Enter Attendance</h2>
        <form>
            <input type="hidden" name="formType" value="attendance">
            <label for="selectedCourseAttendance">Select Course (Subject):</label>
            <select name="selectedCourse" id="selectedCourseAttendance" onchange="fetchStudentsForAttendance(this.value, 1);"> <!-- Assuming semester 1 for simplicity -->
                <option value="">Select a Course</option>
                <%
                PreparedStatement pst4 = null;
                ResultSet rs4 = null;
                try {
                    if (con == null || con.isClosed()) {
                        Class.forName("com.mysql.jdbc.Driver");
                        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/IIS", "root", "");
                    }
                    String sql4 = "SELECT course_id, course FROM faculty_assignment WHERE teacher_id=?";
                    pst4 = con.prepareStatement(sql4);
                    pst4.setString(1, username);
                    rs4 = pst4.executeQuery();
                    while (rs4.next()) {
                        %>
                        <option value="<%= rs4.getString("course_id") %>"><%= rs4.getString("course") %></option>
                        <%
                    }
                } catch(Exception e) {
                    out.println("Error: " + e.getMessage());
                } finally {
                    if (rs4 != null) try { rs4.close(); } catch(SQLException e) {}
                    if (pst4 != null) try { pst4.close(); } catch(SQLException e) {}
                }
                %>
            </select>
            <div id="attendanceTable"></div>
            <input type="submit" value="Submit Attendance">
        </form>
    </div>    
    <div class="bottom">
        <p>� 2024 Institute Information System</p>
        <p>Developed by SS Solutions</p>
    </div>

    <script>
        window.onload = function() {
            var lastVisited = getCookie("lastVisited");
            if (lastVisited) {
                showSection(lastVisited);
            } else {
                showSection('Home'); 
            }
        };
    </script>
</body>

</html>