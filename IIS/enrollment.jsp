<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1.
    response.setHeader("Pragma", "no-cache"); // HTTP 1.0.
    response.setDateHeader("Expires", 0); // Proxies.
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Registration</title>
    <style type="text/css">
        * {
            padding: 0;
            margin: 0;
        }
        body {
            background-color: #e0e0e0;
            font-family: Arial, sans-serif;
        }
        h2 {
            text-align: center;
            padding: 30px;
        }
        label {
            display: block;
            margin-bottom: 5px;
        }
        input[type="text"], input[type="password"], select {
            width: 295px;
            padding: 10px;
            margin: 5px;
            border: 1px solid #ddd;
            border-radius: 3px;
        }
        .section {
            margin: 30px;
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
            background-color: rgb(3, 123, 252, 1.0);
        }
        .top-links {
            position: absolute;
            top: 10px;
            right: 10px;
            display: flex;
            gap: 10px; 
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
        .registration-container {
            width: 450px;
            margin: 100px auto;
            padding: 70px;
            background-color: #f0f0f0;
            border: 2px solid #ddd;
            box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.2);
        }
        #verifyDataSection {
    		align-items: center; 
		}
		input[type="checkbox"] {
			margin: 5px;
		}

		.verify-label {
    		margin-left: 5px; 
    		font-size: 12px; 
		}
        #verifyDataSection, #passwordSection, #confirmPasswordSection, #registerButton {
        	display: none;
        }
    </style>
</head>
<body>
    <div class="top-links">
        <a href="login.jsp" class="login-link">Login</a>
    </div>
    <div class="registration-container">
        <h2>Registration</h2>
        <form id="registrationForm" method="post" action="RegisterUserServlet" onsubmit="return validatePassword()">
            <div id="role-selection">
                <label for="role">User type:</label>
                <select id="role" name="role" required onchange="toggleRegistrationField()">
                    <option value="">Select Role</option>
                    <option value="student">Student</option>
                    <option value="teacher">Teacher</option>
                </select>
            </div>
            </br>
            <div id="studentSection" style="display:none;">
                <label for="studentRegNo">Student Registration No:</label>
                <input type="text" id="studentRegNo" name="studentRegNo" class="form-control" oninput="fetchData()">
            </div>
            <div id="teacherSection" style="display:none;">
                <label for="teacherId">Teacher ID:</label>
                <input type="text" id="teacherId" name="teacherId" class="form-control" oninput="fetchData()">
            </div>
            </br>
            
            <div id="dataSection">
                <!-- Data fetched from the server -->
            </div>
         
            <div id="verifyDataSection">
    			<input type="checkbox" id="verifyData" name="verifyData">
    			<label for="verifyData" class="verify-label">Verified that above information is correct.</label>
			</div>
			</br></br>
			<div id="passwordSection">
    			<label for="password">Create Password:</label>
    			<input type="password" id="password" name="password">
			</div>
			</br>
			<div id="confirmPasswordSection">
    			<label for="confirmPassword">Confirm Password:</label>
    			<input type="password" id="confirmPassword" name="confirmPassword">
			</div>
			</br>
			<div class="controls">
    			<button type="submit" id="registerButton">Register</button>
			</div>
        </form>
    </div>
    <script>
        function toggleRegistrationField() {
            var role = document.getElementById('role').value;
            var studentSection = document.getElementById('studentSection');
            var teacherSection = document.getElementById('teacherSection');
            studentSection.style.display = (role === 'student') ? 'block' : 'none';
            teacherSection.style.display = (role === 'teacher') ? 'block' : 'none';
        }

        function fetchData() {
            var role = document.getElementById('role').value;
            var id = (role === 'student') ? document.getElementById('studentRegNo').value : document.getElementById('teacherId').value;
            if (id.trim() !== '') {
                var xhr = new XMLHttpRequest();
                xhr.open('GET', 'fetchData.jsp?role=' + role + '&id=' + id, true);
                xhr.onreadystatechange = function() {
                    if (xhr.readyState == 4 && xhr.status == 200) {
                        var responseData = xhr.responseText.trim();
                        document.getElementById('dataSection').innerHTML = responseData;
                        
                        if (responseData !== '' && responseData !== '<p>No records found. Please check the ID and try again.</p>') {
                            document.getElementById('verifyDataSection').style.display = 'flex';
                            document.getElementById('verifyData').checked = false; 
                        } else {
                            document.getElementById('verifyDataSection').style.display = 'none';
                        }
                        togglePasswordAndRegisterVisibility(); 
                    }
                };
                xhr.send();
            } else {
                document.getElementById('dataSection').innerHTML = '';
                document.getElementById('verifyDataSection').style.display = 'none';
                togglePasswordAndRegisterVisibility(); 
            }
        }

        function togglePasswordAndRegisterVisibility() {
            
            var isChecked = document.getElementById('verifyData').checked;
            document.getElementById('passwordSection').style.display = isChecked ? 'block' : 'none';
            document.getElementById('confirmPasswordSection').style.display = isChecked ? 'block' : 'none';
            document.getElementById('registerButton').style.display = isChecked ? 'inline' : 'none';
        }

        document.getElementById('verifyData').onchange = togglePasswordAndRegisterVisibility;	
        
        function validatePassword() {
            var password = document.getElementById('password').value;
            var confirmPassword = document.getElementById('confirmPassword').value;
            var minPasswordLength = 6; 

            if (password.length < minPasswordLength) {
                alert('Password must be at least ' + minPasswordLength + ' characters long.');
                return false;
            }

            if (password !== confirmPassword) {
                alert('Passwords do not match.');
                return false;
            }

            return true;
        }
    </script>
</body>
</html>