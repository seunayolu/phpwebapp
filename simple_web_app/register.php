<?php
$servername = "simpleweb-db.ct0umckemt54.eu-west-1.rds.amazonaws.com";
$username = "admin";
$password = "4RzE44Lc97ryPQbUi6Zx";
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
