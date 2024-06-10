<?php
// index.php
require 'config.php';
require 'functions.php';
require 'auth_functions.php';

// User Registration
if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_GET['action']) && $_GET['action'] == 'register') {
    $input = json_decode(file_get_contents('php://input'), true);
    $username = $input['username'];
    $password = $input['password'];
    $response = registerUser($pdo, $username, $password);
    sendResponse($response);
}

// User Login
if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_GET['action']) && $_GET['action'] == 'login') {
    $input = json_decode(file_get_contents('php://input'), true);
    $username = $input['username'];
    $password = $input['password'];
    $response = loginUser($pdo, $username, $password);
    sendResponse($response);
}

// Protect other endpoints with token authentication
function isAuthenticated($level) {
    $headers = apache_request_headers();
    if (!isset($headers['Authorization'])) {
        header('HTTP/1.0 401 Unauthorized');
        sendResponse(['status' => 'error', 'message' => 'Unauthorized']);
    }

    $token = str_replace('Bearer ', '', $headers['Authorization']);
    global $pdo;
    return authenticate($pdo, $token, $level);
}

//DRIVERS

if ($_SERVER['REQUEST_METHOD'] == 'GET' && isset($_GET['action']) && $_GET['action'] == 'get_all_drivers') {
    if (!isAuthenticated('admin')) {
        sendResponse(['status' => 'error', 'message' => 'Unauthorized']);
    } else {
        $response = getAllDrivers($pdo);
        sendResponse($response);
    }
}

// Add a new driver
if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_GET['action']) && $_GET['action'] == 'add_driver') {
	if (!isAuthenticated('admin')) {
        sendResponse(['status' => 'error', 'message' => 'Unauthorized']);
    } else {
		$input = json_decode(file_get_contents('php://input'), true);
		$response = addDriver($pdo, $input);
		sendResponse($response);
	}
}

// Update driver information
if ($_SERVER['REQUEST_METHOD'] == 'PUT' && isset($_GET['action']) && $_GET['action'] == 'update_driver') {
	if (!isAuthenticated('admin')) {
        sendResponse(['status' => 'error', 'message' => 'Unauthorized']);
    } else {
		$input = json_decode(file_get_contents('php://input'), true);
		$response = updateDriver($pdo, $input);
		sendResponse($response);
	}
}

//TRUCKS

// Add a new truck
if ($_SERVER['REQUEST_METHOD'] == 'GET' && isset($_GET['action']) && $_GET['action'] == 'get_all_trucks') {
    if (!isAuthenticated('admin')) {
        sendResponse(['status' => 'error', 'message' => 'Unauthorized']);
    } else {
		$response = getAllTrucks($pdo);
		sendResponse($response);
	}
}

if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_GET['action']) && $_GET['action'] == 'add_truck') {
	if (!isAuthenticated('admin')) {
        sendResponse(['status' => 'error', 'message' => 'Unauthorized']);
    } else {
		$input = json_decode(file_get_contents('php://input'), true);
		$response = addTruck($pdo, $input);
		sendResponse($response);
	}
}

// Update truck information
if ($_SERVER['REQUEST_METHOD'] == 'PUT' && isset($_GET['action']) && $_GET['action'] == 'update_truck') {
	if (!isAuthenticated('admin')) {
        sendResponse(['status' => 'error', 'message' => 'Unauthorized']);
    } else {
		$input = json_decode(file_get_contents('php://input'), true);
		$response = updateTruck($pdo, $input);
		sendResponse($response);
	}
}

if ($_SERVER['REQUEST_METHOD'] == 'PUT' && isset($_GET['action']) && $_GET['action'] == 'assign_truck_to_driver') {
	if (!isAuthenticated('admin')) {
        sendResponse(['status' => 'error', 'message' => 'Unauthorized']);
    } else {
		$input = json_decode(file_get_contents('php://input'), true);
		$response = assignTruckToDriver($pdo, $input);
		sendResponse($response);
	}
}

//ROUTES

if ($_SERVER['REQUEST_METHOD'] == 'GET' && isset($_GET['action']) && $_GET['action'] == 'get_all_routes') {
	if (!isAuthenticated('admin')) {
        sendResponse(['status' => 'error', 'message' => 'Unauthorized']);
    } else {
		$input = json_decode(file_get_contents('php://input'), true);
		$response = getAllRoutes($pdo);
		sendResponse($response);
	}
}

if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_GET['action']) && $_GET['action'] == 'add_route') {
	if (!isAuthenticated('admin')) {
        sendResponse(['status' => 'error', 'message' => 'Unauthorized']);
    } else {
		$input = json_decode(file_get_contents('php://input'), true);
		$response = addRoute($pdo, $input);
		sendResponse($response);
	}
}

if ($_SERVER['REQUEST_METHOD'] == 'PUT' && isset($_GET['action']) && $_GET['action'] == 'update_route') {
	if (!isAuthenticated('admin')) {
        sendResponse(['status' => 'error', 'message' => 'Unauthorized']);
    } else {
		$input = json_decode(file_get_contents('php://input'), true);
		$response = updateRoute($pdo, $input);
		sendResponse($response);
	}
}

if ($_SERVER['REQUEST_METHOD'] == 'PUT' && isset($_GET['action']) && $_GET['action'] == 'assign_truck_to_route') {
	if (!isAuthenticated('admin')) {
        sendResponse(['status' => 'error', 'message' => 'Unauthorized']);
    } else {
		$input = json_decode(file_get_contents('php://input'), true);
		$response = assignTruckToRoute($pdo, $input);
		sendResponse($response);
	}
}

//USERS

if ($_SERVER['REQUEST_METHOD'] == 'GET' && isset($_GET['action']) && $_GET['action'] == 'get_all_users') {
	if (!isAuthenticated('admin')) {
        sendResponse(['status' => 'error', 'message' => 'Unauthorized']);
    } else {
		$input = json_decode(file_get_contents('php://input'), true);
		$response = getAllUsers($pdo);
		sendResponse($response);
	}
}

if ($_SERVER['REQUEST_METHOD'] == 'PUT' && isset($_GET['action']) && $_GET['action'] == 'update_user') {
	if (!isAuthenticated('admin')) {
        sendResponse(['status' => 'error', 'message' => 'Unauthorized']);
    } else {
		$input = json_decode(file_get_contents('php://input'), true);
		$response = updateUser($pdo, $input);
		sendResponse($response);
	}
}

?>