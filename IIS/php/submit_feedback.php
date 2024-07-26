<?php
session_start();
include 'db_connection.php'; 

if (isset($_POST['submit']) && isset($_SESSION['username']) && !empty($_POST['feedback'])) {
    $username = $_SESSION['username'];
    $feedback = $_POST['feedback'];

    $sql = "INSERT INTO feedback (username, feedback) VALUES (?, ?)";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ss", $username, $feedback);
    $stmt->execute();

    if ($stmt->affected_rows > 0) {
        echo "Feedback submitted successfully.";
    } else {
        echo "Failed to submit feedback.";
    }
    $stmt->close();
    $conn->close();

    header("Refresh: 5; url=http://localhost:8080/IIS/logout.jsp");
    exit();
} else {
    header("Location: http://localhost:8080/IIS/logout.jsp");
    exit();
}
?>