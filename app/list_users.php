<!DOCTYPE html>
<html>
<head>
    <title>Registered Users</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }
        .container {
            width: 50%;
            margin: 50px auto;
            background: #fff;
            padding: 20px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        h2 {
            text-align: center;
            color: #333;
        }
        ul {
            list-style-type: none;
            padding: 0;
        }
        li {
            background: #f9f9f9;
            margin-bottom: 10px;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Registered Users</h2>
        <ul>
        <?php
        require 'fetch_credentials.php';

        $conn = new mysqli($db_host, $db_username, $db_password, $db_name);

        if ($conn->connect_error) {
            die("Connection failed: " . $conn->connect_error);
        }

        $sql = "SELECT name, email FROM users";
        $result = $conn->query($sql);

        if ($result->num_rows > 0) {
            while($row = $result->fetch_assoc()) {
                echo "<li>" . htmlspecialchars($row["name"]). " - " . htmlspecialchars($row["email"]). "</li>";
            }
        } else {
            echo "<li>No registered users.</li>";
        }
        $conn->close();
        ?>
        </ul>
        <form action="index.php" method="GET">
            <button type="submit">Back to Registration</button>
        </form>
    </div>
</body>
</html>