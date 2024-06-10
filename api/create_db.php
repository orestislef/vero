<?php
$host = 'localhost';
$user = 'root';
$pass = '';

// Create connection
$conn = new mysqli($host, $user, $pass);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Create database
$dbName = 'vero_db';
$sql = "CREATE DATABASE IF NOT EXISTS $dbName";
if ($conn->query($sql) === TRUE) {
    echo "Database created successfully\n";
} else {
    echo "Error creating database: " . $conn->error . "\n";
}

// Select the database
$conn->select_db($dbName);

// Create tables
$tables = [
	"CREATE TABLE users (
		id INT AUTO_INCREMENT PRIMARY KEY,
		username VARCHAR(255) NOT NULL UNIQUE,
		password VARCHAR(255) NOT NULL,
		token VARCHAR(255) NULL,
		status ENUM('admin', 'mod','driver') DEFAULT 'driver',
		created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
	)",

    // Create trucks table
    "CREATE TABLE IF NOT EXISTS trucks (
        id INT AUTO_INCREMENT PRIMARY KEY,
        truck_name VARCHAR(255) NOT NULL,
        license_plate VARCHAR(255),
		status ENUM('available', 'on_route', 'off_duty') DEFAULT 'available'
    )",
    
    // Create drivers table
    "CREATE TABLE IF NOT EXISTS drivers (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        phone VARCHAR(15) NOT NULL,
        last_location_date TIMESTAMP NULL,
        current_location_string VARCHAR(255),
        current_location_json TEXT,
        status ENUM('available', 'on_route', 'off_duty') DEFAULT 'available',
        truck_id INT,
		user_id INT,
        FOREIGN KEY (truck_id) REFERENCES trucks(id),
		FOREIGN KEY (user_id) REFERENCES users(id)
    )",
    
    // Create routes table    
    "CREATE TABLE IF NOT EXISTS routes (
        id INT AUTO_INCREMENT PRIMARY KEY,
        route_name VARCHAR(255) NOT NULL,
        start_location_string VARCHAR(255),
        end_location_string VARCHAR(255),
        start_date TIMESTAMP NULL,
        end_date TIMESTAMP NULL,
        status ENUM('completed', 'pending','canceled') DEFAULT 'pending',
        truck_id INT,
        FOREIGN KEY (truck_id) REFERENCES trucks(id)
    )",
    
    // Create points_assigned table
    "CREATE TABLE IF NOT EXISTS points (
        id INT AUTO_INCREMENT PRIMARY KEY,
        point_name VARCHAR(255) NOT NULL,
        lat_lng POINT NOT NULL,
		date TIMESTAMP NOT NULL,
        route_id INT,		
        FOREIGN KEY (route_id) REFERENCES routes(id)
    )"
];

foreach ($tables as $table_sql) {
    if ($conn->query($table_sql) === TRUE) {
        echo "Table created successfully\n";
    } else {
        echo "Error creating table: " . $conn->error . "\n";
    }
}

// Close connection
$conn->close();
?>
