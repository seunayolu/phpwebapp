<?php
require 'fetch_credentials.php';

session_start();

$conn = new mysqli($db_host, $db_username, $db_password, $db_name);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$username = $_POST['username'];
$password = $_POST['password'];

$sql = "SELECT id, password, is_admin FROM users WHERE username='$username'";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    if (password_verify($password, $row['password'])) {
        $_SESSION['user_id'] = $row['id'];
        $_SESSION['is_admin'] = $row['is_admin'];
        header("Location: " . ($_SESSION['is_admin'] ? "admin.php" : "index.php"));
        exit();
    } else {
        echo "Invalid password";
    }
} else {
    echo "No user found with that username";
}

$conn->close();
?>
