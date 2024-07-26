<%@ page import="java.sql.*, javax.servlet.http.HttpSession" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1.
    response.setHeader("Pragma", "no-cache"); // HTTP 1.0.
    response.setDateHeader("Expires", 0); // Proxies.

    String errorMessage = request.getParameter("error");
    String successMessage = request.getParameter("success");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Login</title>
    <style type="text/css">
        *{
            padding:0;
            margin:0;
        }
        body {
            background-color: #e0e0e0;
            font-family: Arial, sans-serif;
        }

        .top-links {
            position: absolute;
            top: 10px;
            right: 10px;
            display: flex;
            gap: 10px; /* Adjust the space between links */
        }

        .top-links a {
            text-decoration: none;
            color: #333;
            padding: 8px 15px;
            background-color: #f0f0f0;
            border: 2px solid #3f3e3e;
            border-radius: 3px;
        }   

        .top-links a:hover {
            background-color: #e0e0e0;
        }
        .container {
            width: 315px;
            margin:150px auto;
            padding:20px;
            background-color: #f0f0f0;
            border: 2px solid #ddd;
            box-shadow: 2px 2px 5px rgba(0,0,0,0.2);
            height: auto; /* Adjusted to auto for flexibility */
        }
        h2 {
            text-align: center;
            padding: 10px;
        }

        .username, .password,
        label{
            display: block;
            margin-bottom: 5px;
        }
        .username input[type="text"],
        .password input[type="password"] {
            width:295px;
            padding: 10px;
            margin:5px;
            border: 1px solid #ddd;
            border-radius: 3px;
        }

        .controls {
            text-align: center; 
            padding-top: 10px;
        }

        button {
            padding: 10px 20px;
            margin-right: 10px;
            border: none;
            border-radius: 3px;
            cursor: pointer;
            color: white;
        }
        .login-button {
        	background-color: rgb(3, 153, 26, 1.0);
        }
        .clear-button {
        	background-color: rgb(255, 50, 44, 1.0);
        }

        /*.forgot-link {
            display: block;
            text-align: center;
            margin-top: 10px;
        }*/
    </style>
    <script type="text/javascript">
        window.onload = function() {
            // Clear the browser cache when the page is loaded to prevent form data from being reloaded
            if (window.history.replaceState) {
                window.history.replaceState(null, null, window.location.href);
            }
        };
    </script>
    <script type="text/javascript">
        function display(message) {
            document.getElementById("mes").style.display="block";
            if(message == "registration_successful") {
                document.getElementById("mes").style.color="green";
                document.getElementById("mes").textContent=message;
            }
            else if(message == "user_already_registered") {
                document.getElementById("mes").style.color="orange";
                document.getElementById("mes").textContent=message;
            }
            else {
                document.getElementById("mes").style.color="red";
                document.getElementById("mes").textContent=message;
            }
        }
    </script>
</head>
<body>
    <div class="top-links">
        <a href="enrollment.jsp" class="enrollment-link">Enroll</a>
    </div>
    <div class="container">
        <h2>LOGIN</h2>
        <form id="loginForm" method="post">
            <div class="username">
                <label for="username">Username:</label>
                <input type="text" id="username" name="username" class="form-control" required />
            </div>
            <div class="password">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" class="form-control" required />
            </div>

            <div class="controls">
                <p id="mes" style="margin:10px; text-align: center; display: none;"></p>
                <button type="reset" class="clear-button">Clear</button>
                <button type="submit" class="login-button">Login</button>
            </div>

            <!-- <a href="#" class="forgot-link">Forgot password!</a> -->
        </form>
        <% 
            String user = request.getParameter("username");
            String pwd = request.getParameter("password");

            if (errorMessage != null) {
                %>
                    <script type="text/javascript">
                        display("<%= errorMessage %>");
                    </script>
                <%
            } else if (successMessage != null) {
                %>
                    <script type="text/javascript">
                        display("<%= successMessage %>");
                    </script>
                <%
            }

            if (user != null && pwd != null) {
                Connection conn = null;
                PreparedStatement pst = null;
                ResultSet rs = null;
                try {
                    Class.forName("com.mysql.jdbc.Driver");
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/IIS", "root", "");
                    String sql = "SELECT * FROM users WHERE username=? AND password=?";
                    pst = conn.prepareStatement(sql);
                    pst.setString(1, user);
                    pst.setString(2, pwd);
                    rs = pst.executeQuery();
                    if (rs.next()) {
                        // Login success
                        //out.println("<p>Login successful!</p>");

                        String role = rs.getString("role");
                        HttpSession ses = request.getSession();
                        ses.setAttribute("username", user);
                        ses.setAttribute("role", role);

                        if ("student".equals(role)) {
                            response.sendRedirect("studentInterface.jsp");

                        } else if ("teacher".equals(role)) {
                            response.sendRedirect("teacherInterface.jsp");
                        } else {
                            // Handle unexpected role or add default redirection
                            response.sendRedirect("login.jsp");
                        }

                    } else {
                        // Login failure
                        %>
                        <script type="text/javascript">
                            display("Invalid username or password!");
                        </script>
                        <%
                    }
                } catch (Exception e) {
                    out.println("<p>Error: " + e.getMessage() + "</p>");
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException e) {}
                    if (pst != null) try { pst.close(); } catch (SQLException e) {}
                    if (conn != null) try { conn.close(); } catch (SQLException e) {}
                }
            }
        %>
    </div>

    <!-- <div class="enrollment-link" style="text-align: center; margin-top: 20px;">
        <a href="enrollment.jsp" style="text-decoration: none; color: #333; font-size: 16px;">Go to Enrollment Page</a>
    </div> -->
    

</body>
</html>
