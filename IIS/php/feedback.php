<?php
session_start();
if (isset($_GET['user'])) {
    $_SESSION['username'] = $_GET['user'];
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Feedback Form</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        form {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            width: 300px;
        }
        h1 {
            text-align: center;
            color: #333;
        }
        textarea {
            width: 100%;
            height: 100px;
            margin-bottom: 10px;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            resize: none;
        }
        input[type="submit"], input[type="button"] {
            width: 100%;
            padding: 10px;
            border: none;
            border-radius: 4px;
            color: white;
            cursor: pointer;
        }
        input[type="submit"] {
            background-color: #5cb85c;
        }
        input[type="button"] {
            background-color: #f0ad4e;
            margin-top: 5px;
        }
        input[type="submit"]:hover, input[type="button"]:hover {
            opacity: 0.9;
        }
    </style>
</head>
<body>
    <h1>Feedback Form</h1>
    <form action="submit_feedback.php" method="post">
        <textarea name="feedback" required></textarea>
        <br>
        <input type="submit" name="submit" value="Submit Feedback" onclick="window.location='http://localhost:8080/IIS/login.jsp';">
        <input type="button" value="Skip" onclick="window.location='http://localhost:8080/IIS/login.jsp';">
    </form>
</body>
</html>