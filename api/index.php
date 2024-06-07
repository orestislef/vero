<?php
// index.php
require 'config.php';
require 'functions.php';

//DRIVERS

if ($_SERVER['REQUEST_METHOD'] == 'GET' && isset($_GET['action']) && $_GET['action'] == 'get_all_drivers') {
    $response = getAllDrivers($pdo);
    sendResponse($response);
}

// Add a new driver
if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_GET['action']) && $_GET['action'] == 'add_driver') {
    $input = json_decode(file_get_contents('php://input'), true);
    $response = addDriver($pdo, $input);
    sendResponse($response);
}

// Update driver information
if ($_SERVER['REQUEST_METHOD'] == 'PUT' && isset($_GET['action']) && $_GET['action'] == 'update_driver') {
    $input = json_decode(file_get_contents('php://input'), true);
    $response = updateDriver($pdo, $input);
    sendResponse($response);
}

//TRUCKS

// Add a new truck
if ($_SERVER['REQUEST_METHOD'] == 'GET' && isset($_GET['action']) && $_GET['action'] == 'get_all_trucks') {
    $response = getAllTrucks($pdo);
    sendResponse($response);
}

if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_GET['action']) && $_GET['action'] == 'add_truck') {
    $input = json_decode(file_get_contents('php://input'), true);
    $response = addTruck($pdo, $input);
    sendResponse($response);
}

// Update truck information
if ($_SERVER['REQUEST_METHOD'] == 'PUT' && isset($_GET['action']) && $_GET['action'] == 'update_truck') {
    $input = json_decode(file_get_contents('php://input'), true);
    $response = updateTruck($pdo, $input);
    sendResponse($response);
}

if ($_SERVER['REQUEST_METHOD'] == 'PUT' && isset($_GET['action']) && $_GET['action'] == 'assign_truck_to_driver') {
    $input = json_decode(file_get_contents('php://input'), true);
    $response = assignTruckToDriver($pdo, $input);
    sendResponse($response);
}

//ROUTES

if ($_SERVER['REQUEST_METHOD'] == 'GET' && isset($_GET['action']) && $_GET['action'] == 'get_all_routes') {
    $input = json_decode(file_get_contents('php://input'), true);
    $response = getAllRoutes($pdo);
    sendResponse($response);
}

if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_GET['action']) && $_GET['action'] == 'add_route') {
    $input = json_decode(file_get_contents('php://input'), true);
    $response = addRoute($pdo, $input);
    sendResponse($response);
}

?>