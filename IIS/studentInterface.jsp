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
%>

<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Student Interface</title>
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
    
        .student-details,
        .timetable {
            background-color: #f4f4f4;
            padding: 20px;
            margin: 40px auto;
            border-radius: 10px;
            box-shadow: 0 1px 8px #393a3d;
        }
    
        .student-details h2,
        .timetable h2 {
            color: #333;
            margin: 5px;
        }
    
        .student-details p {
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
    
        #Course-Registration,
        #Result,
        #Attendence,
        #About-Us {
            display: none;
            height:600px;
        }
    
        #Course-Registration table {
            width: 50%;
            margin: 0 auto;
            border-collapse: collapse;
        }
    
        #Course-Registration th,
        #Course-Registration td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
            font-size: 20px;
    
        }
    
        #Course-Registration th {
            background-color: #f2f2f2;
        }
    
        #Course-Registration h2 {
            text-align: center;
            margin-top: 55px;
            margin-bottom: 20px;
            align-items: center;
            font-size: 40px;
        }
    
        #Course-Registration button {
            display: block;
            margin: 20px auto;
            padding: 10px 20px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
    
        #Course-Registration select {
            width: 100%;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 4px;
            background-color: white;
            box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.1);
            cursor: pointer;
        }
    
        #Course-Registration select:hover {
            border-color: #888;
        }
    
        #Course-Registration select:focus {
            outline: none;
            border-color: #4CAF50;
            box-shadow: 0 0 5px rgba(76, 175, 80, 0.5);
        }
    
        #Result {
            background-color: #f8f9fa;
            padding: 20px;
            margin-top: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
    
        #Result h2 {
            color: #333;
            text-align: center;
            margin-bottom: 20px;
        }
    
        #Result table {
            width: 30%;
            margin: 0 auto;
            border-collapse: collapse;
        }
    
        #Result th,
        #Result td {
            border: 1px solid #dee2e6;
            padding: 10px;
            text-align: center;
        }
    
        #Result th {
            background-color: #e9ecef;
            color: #495057;
        }
    
        #Result td {
            background-color: #ffffff;
            color: #212529;
        }

        #Attendence h2 {
            color: #333;
            text-align: center;
            margin-bottom: 20px;
        }
        #Attendence {
            background-color: #f8f9fa;
            padding: 20px;
            margin-top: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }


    </style>

    <script>
        function showSection(sectionId) {
            var sections = ['Home', 'Course-Registration', 'Result', 'Attendence'];
            sections.forEach(function (id) {
                document.getElementById(id).style.display = 'none';
            });
            document.getElementById(sectionId).style.display = 'block';

            var d = new Date();
            d.setTime(d.getTime() + (7 * 24 * 60 * 60 * 1000));
            var expires = "expires=" + d.toUTCString();
            document.cookie = "lastVisited=" + sectionId + ";" + expires + ";path=/";
        }
    </script>


</head>

<body>
    <div class="top">
        <img id="logo" src="images/SS.jpeg" alt="logo">
        <pre id="heading">INSTITUTE INFORMATION SYSTEM</pre>
        <br>
    </div>
    <h3 id="rol">Student Portal</h3>
    <nav class="navbar">
        <ul>
            <li><a href="#" onclick="showSection('Home'); return false;">Home</a></li>
            <li><a href="#" onclick="showSection('Course-Registration'); return false;">Course Registration</a></li>
            <li><a href="#" onclick="showSection('Result'); return false;">Results</a></li>
            <li><a href="#" onclick="showSection('Attendence'); return false;">Attendence</a></li>
            <li><a href="http://localhost/feedback.php">LOGOUT</a></li>
        </ul>
    </nav>
    <div id="Home">
        <div class="cards">
            <div class="student-details">
                <h2>Student Details</h2>
                <%
                HttpSession ses = request.getSession(false);
                if (ses != null && ses.getAttribute("username") != null) {
                String role = (String) ses.getAttribute("role");
                PreparedStatement pst = null;
                ResultSet rs = null;
                try {
                    Class.forName("com.mysql.jdbc.Driver");
                    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/IIS", "root", "");
                    String sql = "SELECT registration_number, name, section, department, year, course, image, semester FROM students WHERE registration_number=?";
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
                            <form action="StudentUploadServlet" method="post" enctype="multipart/form-data">
                                <input type="file" name="image" required>
                                <button type="submit">Upload Image</button>
                            </form>
                            <%
                        }
                        %>
                    <table>
                        <tr>
                            <th>Reg. No:</th>
                            <td><%= rs.getString("registration_number") %></td>
                        </tr>
                        <tr>
                            <th>Name:</th>
                            <td><%= rs.getString("name") %></td>
                        </tr>
                        <tr>
                            <th>Section:</th>
                            <td><%= rs.getString("section") %></td>
                        </tr>
                        <tr>
                            <th>Semester:</th>
                            <td><%= rs.getString("semester") %></td>
                        </tr>
                        <tr>
                            <th>Department:</th>
                            <td><%= rs.getString("department") %></td>
                        </tr>
                        <tr>
                            <th>Batch:</th>
                            <td><%= rs.getString("year") %></td>
                        </tr>
                        <tr>
                            <th>Course:</th>
                            <td><%= rs.getString("course") %></td>
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
            <div class="timetable">
                <h2>Class Schedule</h2>
                <%
                try {
                    // Reuse the connection if it's still open, or create a new one
                    if (con == null || con.isClosed()) {
                        Class.forName("com.mysql.jdbc.Driver");
                        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/IIS", "root", "");
                    }
                    String timetableSql = "SELECT semester, department, section FROM students WHERE registration_number=?";
                    PreparedStatement timetablePst = con.prepareStatement(timetableSql);
                    timetablePst.setString(1, username);
                    ResultSet timetableRs = timetablePst.executeQuery();
                    if (timetableRs.next()) {
                        String semester = timetableRs.getString("semester");
                        String department = timetableRs.getString("department");
                        String section = timetableRs.getString("section");
                        String imageName = semester + "_" + department + "_" + section + ".jpg";
                        String imagePath = "images/timetables/" + imageName;
                    %>
                        <img src="<%= imagePath %>" alt="Timetable" style="width:100%; max-width:600px; height:auto; display:block; margin:auto;">
                    <%
                    } else {
                    %>
                        <p>No timetable available.</p>
                    <%
                    }
                    timetableRs.close();
                    timetablePst.close();
                } catch (Exception e) {
                    out.println("Error: " + e.getMessage());
                }
                %>
            </div>
        </div>
    </div>
    <div id="Course-Registration">
        <h2>Course Registration</h2>
        <%
        List<String> teachers = new ArrayList<>();
        Map<String, String> courses = new LinkedHashMap<>(); // Using LinkedHashMap to preserve insertion order
        try {
            if (con == null || con.isClosed()) {
                Class.forName("com.mysql.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/IIS", "root", "");
            }
    
            String semSql = "SELECT semester,department FROM students WHERE registration_number=?";
            PreparedStatement semPst = con.prepareStatement(semSql);
            semPst.setString(1, username);
            ResultSet semRs = semPst.executeQuery();
            if (semRs.next()) {
                String semester = semRs.getString("semester");
                String dept = semRs.getString("department");
                String courseQuery = "SELECT course_id, course_name FROM courses WHERE semester=? and department=?";
                PreparedStatement courseStmt = con.prepareStatement(courseQuery);
                courseStmt.setString(1, semester);
                courseStmt.setString(2, dept);
                ResultSet courseRs = courseStmt.executeQuery();
                while (courseRs.next()) {
                    courses.put(courseRs.getString("course_id"), courseRs.getString("course_name"));
                }
                courseRs.close();
                courseStmt.close();
            }
            semRs.close();
            semPst.close();
    
            String teacherQuery = "SELECT teacher_id, name FROM teachers";
            PreparedStatement teacherStmt = con.prepareStatement(teacherQuery);
            ResultSet teacherRs = teacherStmt.executeQuery();
            while (teacherRs.next()) {
                teachers.add(teacherRs.getString("name"));
            }
            teacherRs.close();
            teacherStmt.close();
        } catch (Exception e) {
            out.println("Error fetching courses or teachers: " + e.getMessage());
        }
        %>
        <form>
            <table>
                <tr>
                    <th>Course ID</th>
                    <th>Course Name</th>
                    <th>Select Teacher</th>
                </tr>
                <% for (Map.Entry<String, String> entry : courses.entrySet()) { %>
                <tr>
                    <td><%= entry.getKey() %></td>
                    <td><%= entry.getValue() %></td>
                    <td>
                        <select name="teacher_<%= entry.getKey() %>">
                            <% for (String teacher : teachers) { %>
                            <option value="<%= teacher %>"><%= teacher %></option>
                            <% } %>
                        </select>
                    </td>
                </tr>
                <% } %>
            </table>
            <button type="submit">Register</button>
        </form>
    </div>
    <div id="Result">
        <h2>Academic Results for Previous Semester</h2>
        <%
        if (con == null || con.isClosed()) {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/IIS", "root", "");
        }
    
        String currentSemesterQuery = "SELECT semester FROM students WHERE registration_number=?";
        PreparedStatement currentSemesterStmt = con.prepareStatement(currentSemesterQuery);
        currentSemesterStmt.setString(1, username);
        ResultSet currentSemesterRs = currentSemesterStmt.executeQuery();
        String previousSemester = null;
        if (currentSemesterRs.next()) {
            String currentSemester = currentSemesterRs.getString("semester");
            if(currentSemester.equals("8th")) {
                previousSemester = "7th";
            } else if(currentSemester.equals("7th")) {
                previousSemester = "6th";
            } else if(currentSemester.equals("6th")) {
                previousSemester = "5th";
            } else if(currentSemester.equals("5th")) {
                previousSemester = "4th";
            } else if(currentSemester.equals("4th")) {
                previousSemester = "3rd";
            } else if(currentSemester.equals("3rd")) {
                previousSemester = "2nd";
            } else if(currentSemester.equals("2nd")) {
                previousSemester = "1st";
            } else {
                previousSemester = null;
            }
        }
        currentSemesterRs.close();
        currentSemesterStmt.close();
    
        if (previousSemester != null) {
            String resultsQuery = "SELECT course_id,course_name, grade FROM results WHERE student_id=? AND semester=?";
            PreparedStatement resultsStmt = con.prepareStatement(resultsQuery,ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            resultsStmt.setString(1, username);
            resultsStmt.setString(2, previousSemester);
            ResultSet resultsRs = resultsStmt.executeQuery();
            if (resultsRs.next()) {
            %>
            <table>
                <tr>
                    <th>Course ID</th>
                    <th>Course Name</th>
                    <th>Grade</th>
                </tr>
                <%
                resultsRs.previous();
                while (resultsRs.next()) {
                    %>
                    <tr>
                        <td><%= resultsRs.getString("course_id") %></td>
                        <td><%= resultsRs.getString("course_name") %></td>
                        <td><%= resultsRs.getString("grade") %></td>
                    </tr>
                    <%
                }
                resultsRs.close();
                resultsStmt.close();
                %>
            </table>
            <% }
            else {
                %>
                <p style="text-align: center;">No previous semester data available.</p>
            <%
            }
        } else {
            %>
            <p style="text-align: center;">No previous semester data available.</p>
            <%
        }
        %>
    </div>
    <div id="Attendence">
        <h2>Current Semester Attendence</h2>
        <%
        try {
            if (con == null || con.isClosed()) {
                Class.forName("com.mysql.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/IIS", "root", "");
            }

            String currentSemesterQ = "SELECT semester FROM students WHERE registration_number=?";
            PreparedStatement currentSemesterS = con.prepareStatement(currentSemesterQ);
            currentSemesterS.setString(1, username);
            ResultSet currentSemRs = currentSemesterS.executeQuery();
            String seme = null;
            if (currentSemRs.next()) {
                seme = currentSemRs.getString("semester");
            }

            String attendanceQuery = "SELECT subject, total_classes, attended_classes FROM attendance WHERE student_id=? AND semester=?";
            PreparedStatement attendanceStmt = con.prepareStatement(attendanceQuery,ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            attendanceStmt.setString(1, username);
            attendanceStmt.setString(2, seme); 
            ResultSet attendanceRs = attendanceStmt.executeQuery();
            if (attendanceRs.next()) {
        %>
        <table>
            <tr>
                <th>Subject</th>
                <th>Total Classes</th>
                <th>Attended Classes</th>
                <th>Attendance Percentage</th>
            </tr>
            <%
            attendanceRs.previous();
            while (attendanceRs.next()) {
                String subject = attendanceRs.getString("subject");
                int totalClasses = attendanceRs.getInt("total_classes");
                int attendedClasses = attendanceRs.getInt("attended_classes");
                double attendancePercentage = (double) attendedClasses / totalClasses * 100;
                %>
                <tr>
                    <td><%= subject %></td>
                    <td><%= totalClasses %></td>
                    <td><%= attendedClasses %></td>
                    <td><%= String.format("%.2f", attendancePercentage) %> %</td>
                </tr>
                <%
            }
            attendanceRs.close();
            attendanceStmt.close();
            %>
        </table>
        <% }
        else {
            %>
            <p style="text-align: center;">No previous semester data available.</p>
        <%
        }
        } catch (Exception e) {
            out.println("Error fetching attendance data: " + e.getMessage());
        } finally {
            if (con != null) try { con.close(); } catch(SQLException e) {}
        }
        %>
    </div>
    <div class="bottom">
        <p>© 2024 Institute Information System</p>
        <p>Developed by SS Solutions</p>
    </div>

    <script>
        window.onload = function() {
            var lastVisited = getCookie("lastVisited");
            if (lastVisited != "") {
                showSection(lastVisited);
            } else {
                showSection('Home'); // Default to Home if no cookie is found
            }
        };
    
        function getCookie(cname) {
            var name = cname + "=";
            var decodedCookie = decodeURIComponent(document.cookie);
            var ca = decodedCookie.split(';');
            for(var i = 0; i < ca.length; i++) {
                var c = ca[i];
                while (c.charAt(0) == ' ') {
                    c = c.substring(1);
                }
                if (c.indexOf(name) == 0) {
                    return c.substring(name.length, c.length);
                }
            }
            return "";
        }
    </script>
</body>

</html>