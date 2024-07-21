CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL
);


ALTER TABLE users
ADD COLUMN username VARCHAR(50) NOT NULL UNIQUE,
ADD COLUMN password VARCHAR(255) NOT NULL;

USE myappdb;

-- Delete the existing users table if it exists
DROP TABLE IF EXISTS users;

-- Create the users table again with the new structure
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL
);


mysql -h your-rds-endpoint -u admin -p

INSERT INTO users (name, email, username, password)
VALUES ('Admin', 'admin@example.com', 'admin', '$2y$10$IzMwB5jfxmy.rBV16muIB.gpR0Mmqfqbtz7lGvwfuOO3s8kT0296C');

ALTER TABLE users ADD COLUMN is_admin BOOLEAN NOT NULL DEFAULT FALSE;
UPDATE users SET is_admin = TRUE WHERE username = 'admin';


