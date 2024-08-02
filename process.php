<?php
require 'vendor/autoload.php';

use Aws\S3\S3Client;
use Aws\Ssm\SsmClient;
use Dotenv\Dotenv;

// Load environment variables from .env file
$dotenv = Dotenv::createImmutable(__DIR__);
$dotenv->load();

// Fetch database credentials from AWS Parameter Store
$ssm = new SsmClient([
    'version' => 'latest',
    'region'  => 'eu-west-1'
]);

function getParameter($ssm, $name) {
    $result = $ssm->getParameter([
        'Name' => $name,
        'WithDecryption' => true,
    ]);
    return $result['Parameter']['Value'];
}

$db_host = getParameter($ssm, $_ENV['PARAMETER_STORE_DB_HOST']);
$db_user = getParameter($ssm, $_ENV['PARAMETER_STORE_DB_USER']);
$db_pass = getParameter($ssm, $_ENV['PARAMETER_STORE_DB_PASS']);
$db_name = getParameter($ssm, $_ENV['PARAMETER_STORE_DB_NAME']);

// Create database connection
$conn = new mysqli($db_host, $db_user, $db_pass, $db_name);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Create table if it doesn't exist
$table_query = "
CREATE TABLE IF NOT EXISTS contacts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    message TEXT NOT NULL,
    attachment VARCHAR(255) DEFAULT NULL
)";
$conn->query($table_query);

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $name = $_POST['name'];
    $email = $_POST['email'];
    $message = $_POST['message'];
    $attachment = '';

    // Upload to S3 if file is uploaded
    if (isset($_FILES['attachment']) && $_FILES['attachment']['error'] == 0) {
        $s3 = new S3Client([
            'version' => 'latest',
            'region'  => 'eu-west-1'
        ]);

        $bucket = $_ENV['S3_BUCKET_NAME'];
        $key = 'uploads/' . basename($_FILES['attachment']['name']);
        $file_path = $_FILES['attachment']['tmp_name'];

        try {
            $result = $s3->putObject([
                'Bucket' => $bucket,
                'Key'    => $key,
                'SourceFile' => $file_path,
                //'ACL'    => 'public-read' // Optional: adjust permissions as needed
            ]);
            $attachment = $result['ObjectURL'];
        } catch (Exception $e) {
            echo "There was an error uploading the file.\n";
            echo $e->getMessage();
        }
    }

    $stmt = $conn->prepare("INSERT INTO contacts (name, email, message, attachment) VALUES (?, ?, ?, ?)");
    $stmt->bind_param("ssss", $name, $email, $message, $attachment);

    if ($stmt->execute()) {
        echo "Message sent successfully!";
    } else {
        echo "Error: " . $stmt->error;
    }

    $stmt->close();
}

$conn->close();
?>