<?php
require 'fetch_credentials.php';

header('Content-Type: text/csv');
header('Content-Disposition: attachment; filename="users.csv"');

$conn = new mysqli($db_host, $db_username, $db_password, $db_name);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$output = fopen('php://output', 'w');
fputcsv($output, array('Name', 'Email', 'Username'));

$sql = "SELECT name, email, username FROM users";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        fputcsv($output, $row);
    }
}

fclose($output);
$conn->close();
?>
