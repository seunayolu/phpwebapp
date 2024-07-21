<?php
$servername = "phpapp-db.cb4wsgmaiwwm.eu-west-2.rds.amazonaws.com";
$username = "admin";
$password = "0jrIXBCeGRBXK5fvfZ4f";
$dbname = "account";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$name = $_POST['name'];
$email = $_POST['email'];

$sql = "INSERT INTO users (name, email) VALUES ('$name', '$email')";

if ($conn->query($sql) === TRUE) {
    echo "New record created successfully";
} else {
    echo "Error: " . $sql . "<br>" . $conn->error;
}

$conn->close();

header("Location: /");
exit();
?>
