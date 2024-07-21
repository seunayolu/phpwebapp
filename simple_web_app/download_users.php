<?php
$servername = "simpleweb-db.ct0umckemt54.eu-west-1.rds.amazonaws.com";
$username = "admin";
$password = "4RzE44Lc97ryPQbUi6Zx";
$dbname = "account";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$sql = "SELECT name, email FROM users";
$result = $conn->query($sql);

header('Content-Type: text/csv');
header('Content-Disposition: attachment; filename="registered_users.csv"');

$output = fopen('php://output', 'w');
fputcsv($output, array('Name', 'Email'));

if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        fputcsv($output, $row);
    }
}

fclose($output);
$conn->close();
exit();
?>
