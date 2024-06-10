<?php
// functions.php

function getAllDrivers($pdo) {
    try {
        $stmt = $pdo->query('SELECT * FROM drivers');
        $drivers = $stmt->fetchAll(PDO::FETCH_ASSOC);
        
        if ($drivers) {
            return sendResponse(['message' => 'Drivers retrieved successfully', 'drivers' => $drivers]);
        } else {
            return sendResponse(['message' => 'No drivers found'], 404);
        }
    } catch (PDOException $e) {
        return sendResponse(['message' => 'Error: ' . $e->getMessage()], 500);
    }
}


function addDriver($pdo, $input)
{
    $name = $input['name'] ?? '';
    $phone = $input['phone'] ?? '';

    // Check if required fields are provided
    if (empty($name) || empty($phone)) {
        return sendResponse(['message' => 'Name, license number, and phone are required fields'], 400);
    }

    try {
        $stmt = $pdo->prepare('INSERT INTO drivers (name, phone) VALUES (?, ?)');
        if ($stmt->execute([$name, $phone])) {
            // Retrieve the inserted driver's details from the database
            $driverId = $pdo->lastInsertId();
            $stmt = $pdo->prepare('SELECT * FROM drivers WHERE id = ?');
            if ($stmt->execute([$driverId])) {
                $driver = $stmt->fetch(PDO::FETCH_ASSOC);
                if ($driver) {
                    // Return the driver's details as JSON
                    return sendResponse(['message' => 'Driver added successfully', 'driver' => $driver]);
                } else {
                    return sendResponse(['message' => 'Failed to fetch driver details'], 500);
                }
            } else {
                return sendResponse(['message' => 'Failed to fetch driver details'], 500);
            }
        } else {
            return sendResponse(['message' => 'Failed to add driver'], 500);
        }
    } catch (PDOException $e) {
        return sendResponse(['message' => 'Error: ' . $e->getMessage()], 500);
    }
}



function updateDriver($pdo, $input)
{
    $id = $input['id'] ?? '';
    if (empty($id)) {
        return sendResponse(['message' => 'Invalid input. required: driver id'], 400);
    }

    // Check if the driver with the provided ID exists
    $stmt = $pdo->prepare('SELECT id FROM drivers WHERE id = ?');
    $stmt->execute([$id]);
    $driverExists = $stmt->fetchColumn();

    if (!$driverExists) {
        return sendResponse(['message' => 'Driver not found'], 404);
    }

    // Initialize arrays to store query parameters and update fields
    $params = [];
    $updateFields = [];

    // Iterate through the input data and build the SQL query dynamically
    foreach ($input as $key => $value) {
        // Skip the 'id' field as it's used in the WHERE clause
        if ($key === 'id') continue;

        // Append the field to be updated and its corresponding value to the arrays
        $updateFields[] = "$key = ?";
        $params[] = $value;
    }

    // If no fields to update are provided, return an error
    if (empty($updateFields)) {
        return sendResponse(['message' => 'No fields to update'], 400);
    }

    try {
        // Prepare and execute the SQL query
        $sql = "UPDATE drivers SET " . implode(", ", $updateFields) . " WHERE id = ?";
        $params[] = $id; // Add the id parameter for the WHERE clause
        $stmt = $pdo->prepare($sql);
        $success = $stmt->execute($params);

        if ($success) {
            return sendResponse(['message' => 'Driver updated successfully']);
        } else {
            return sendResponse(['message' => 'Failed to update driver'], 500);
        }
    } catch (PDOException $e) {
        // Print SQL query and detailed error message for debugging
        return sendResponse(['message' => 'Failed to update driver. Error: ' . $e->getMessage()], 500);
    }
}

function addTruck($pdo, $input)
{
    $truck_name = $input['truck_name'] ?? '';
    $license_plate = $input['license_plate'] ?? '';

    // Check if required fields are provided
    if (empty($truck_name) || empty($license_plate)) {
        return sendResponse(['message' => 'truck_name, license plate are required fields'], 400);
    }

    try {
        $stmt = $pdo->prepare('INSERT INTO trucks (truck_name, license_plate) VALUES (?, ?)');
        if ($stmt->execute([$truck_name, $license_plate])) {
            // Retrieve the inserted truck's details from the database
            $truckId = $pdo->lastInsertId();
            $stmt = $pdo->prepare('SELECT * FROM trucks WHERE id = ?');
            if ($stmt->execute([$truckId])) {
                $truck = $stmt->fetch(PDO::FETCH_ASSOC);
                if ($truck) {
                    // Return the truck's details as JSON
                    return sendResponse(['message' => 'Truck added successfully', 'truck' => $truck]);
                } else {
                    return sendResponse(['message' => 'Failed to fetch truck details'], 500);
                }
            } else {
                return sendResponse(['message' => 'Failed to fetch truck details'], 500);
            }
        } else {
            return sendResponse(['message' => 'Failed to add truck'], 500);
        }
    } catch (PDOException $e) {
        return sendResponse(['message' => 'Error: ' . $e->getMessage()], 500);
    }
}

function updateTruck($pdo, $input)
{
    $id = $input['id'] ?? '';
    if (empty($id)) {
        return sendResponse(['message' => 'Invalid input. required: driver id'], 400);
    }

    // Check if the driver with the provided ID exists
    $stmt = $pdo->prepare('SELECT id FROM trucks WHERE id = ?');
    $stmt->execute([$id]);
    $truckExists = $stmt->fetchColumn();

    if (!$truckExists) {
        return sendResponse(['message' => 'Truck not found'], 404);
    }

    // Initialize arrays to store query parameters and update fields
    $params = [];
    $updateFields = [];

    // Iterate through the input data and build the SQL query dynamically
    foreach ($input as $key => $value) {
        // Skip the 'id' field as it's used in the WHERE clause
        if ($key === 'id') continue;

        // Append the field to be updated and its corresponding value to the arrays
        $updateFields[] = "$key = ?";
        $params[] = $value;
    }

    // If no fields to update are provided, return an error
    if (empty($updateFields)) {
        return sendResponse(['message' => 'No fields to update'], 400);
    }

    try {
        // Prepare and execute the SQL query
        $sql = "UPDATE trucks SET " . implode(", ", $updateFields) . " WHERE id = ?";
        $params[] = $id; // Add the id parameter for the WHERE clause
        $stmt = $pdo->prepare($sql);
        $success = $stmt->execute($params);

        if ($success) {
            return sendResponse(['message' => 'Truck updated successfully']);
        } else {
            return sendResponse(['message' => 'Failed to update truck'], 500);
        }
    } catch (PDOException $e) {
        // Print SQL query and detailed error message for debugging
        return sendResponse(['message' => 'Failed to update truck. Error: ' . $e->getMessage()], 500);
    }
}


function getAllTrucks($pdo) {
    try {
        $stmt = $pdo->query('SELECT * FROM trucks');
        $trucks = $stmt->fetchAll(PDO::FETCH_ASSOC);
        
        if ($trucks) {
            return sendResponse(['message' => 'Trucks retrieved successfully', 'trucks' => $trucks]);
        } else {
            return sendResponse(['message' => 'No trucks found'], 404);
        }
    } catch (PDOException $e) {
        return sendResponse(['message' => 'Error: ' . $e->getMessage()], 500);
    }
}

function assignTruckToDriver($pdo, $input)
{
    $driver_id = $input['driver_id'] ?? '';
    $truck_id = $input['truck_id'] ?? '';

    // Check if required fields are provided
    if (empty($driver_id) || empty($truck_id)) {
        return sendResponse(['message' => 'driver_id and truck_id are required fields'], 400);
    }

    try {
        // Check if the driver exists
        $stmt = $pdo->prepare('SELECT id FROM drivers WHERE id = ?');
        $stmt->execute([$driver_id]);
        $driverExists = $stmt->fetchColumn();

        if (!$driverExists) {
            return sendResponse(['message' => 'Driver not found'], 404);
        }

        // Check if the truck exists
        $stmt = $pdo->prepare('SELECT id FROM trucks WHERE id = ?');
        $stmt->execute([$truck_id]);
        $truckExists = $stmt->fetchColumn();

        if (!$truckExists) {
            return sendResponse(['message' => 'Truck not found'], 404);
        }

        // Assign the truck to the driver (assuming there is a `truck_id` column in the drivers table)
        $stmt = $pdo->prepare('UPDATE drivers SET truck_id = ? WHERE id = ?');
        $success = $stmt->execute([$truck_id, $driver_id]);

        if ($success) {
            return sendResponse(['message' => 'Truck assigned to driver successfully']);
        } else {
            return sendResponse(['message' => 'Failed to assign truck to driver'], 500);
        }
    } catch (PDOException $e) {
        return sendResponse(['message' => 'Error: ' . $e->getMessage()], 500);
    }
}

function getAllRoutes($pdo) {
    try {
        $stmt = $pdo->query('SELECT * FROM routes');
        $routes = $stmt->fetchAll(PDO::FETCH_ASSOC);
        
        if ($routes) {
            return sendResponse(['message' => 'Routes retrieved successfully', 'routes' => $routes]);
        } else {
            return sendResponse(['message' => 'No routes found'], 404);
        }
    } catch (PDOException $e) {
        return sendResponse(['message' => 'Error: ' . $e->getMessage()], 500);
    }
}

function addRoute($pdo, $input)
{
    $route_name = $input['route_name'] ?? '';
	$start_location_string = $input['start_location_string'] ??'';
	$end_location_string = $input['end_location_string'] ??'';
	$start_date = $input['start_date'] ?? '';
	$end_date = $input['end_date'] ?? '';

    // Check if required fields are provided
    if (empty($route_name) || empty($start_location_string) || empty($end_location_string) || empty($start_date) || empty($end_date)) {
        return sendResponse(['message' => 'route_name, start_location_string, end_location_string, start_date, end_date are required fields'], 400);
    }

    try {
        $stmt = $pdo->prepare('INSERT INTO routes (route_name, start_location_string, end_location_string, start_date, end_date) VALUES (?, ?, ?, ?, ?)');
        if ($stmt->execute([$route_name, $start_location_string, $end_location_string, $start_date, $end_date])) {
            // Retrieve the inserted route's details from the database
            $routeId = $pdo->lastInsertId();
            $stmt = $pdo->prepare('SELECT * FROM routes WHERE id = ?');
            if ($stmt->execute([$routeId])) {
                $route = $stmt->fetch(PDO::FETCH_ASSOC);
                if ($route) {
                    // Return the route's details as JSON
                    return sendResponse(['message' => 'Route added successfully', 'route' => $route]);
                } else {
                    return sendResponse(['message' => 'Failed to fetch route details'], 500);
                }
            } else {
                return sendResponse(['message' => 'Failed to fetch route details'], 500);
            }
        } else {
            return sendResponse(['message' => 'Failed to add route'], 500);
        }
    } catch (PDOException $e) {
        return sendResponse(['message' => 'Error: ' . $e->getMessage()], 500);
    }
}

function updateRoute($pdo, $input){
	$id = $input['id'] ?? '';
    if (empty($id)) {
        return sendResponse(['message' => 'Invalid input. required: route id'], 400);
    }

    // Check if the driver with the provided ID exists
    $stmt = $pdo->prepare('SELECT id FROM routes WHERE id = ?');
    $stmt->execute([$id]);
    $routeExists = $stmt->fetchColumn();

    if (!$routeExists) {
        return sendResponse(['message' => 'Truck not found'], 404);
    }

    // Initialize arrays to store query parameters and update fields
    $params = [];
    $updateFields = [];

    // Iterate through the input data and build the SQL query dynamically
    foreach ($input as $key => $value) {
        // Skip the 'id' field as it's used in the WHERE clause
        if ($key === 'id') continue;

        // Append the field to be updated and its corresponding value to the arrays
        $updateFields[] = "$key = ?";
        $params[] = $value;
    }

    // If no fields to update are provided, return an error
    if (empty($updateFields)) {
        return sendResponse(['message' => 'No fields to update'], 400);
    }

    try {
        // Prepare and execute the SQL query
        $sql = "UPDATE routes SET " . implode(", ", $updateFields) . " WHERE id = ?";
        $params[] = $id; // Add the id parameter for the WHERE clause
        $stmt = $pdo->prepare($sql);
        $success = $stmt->execute($params);

        if ($success) {
            return sendResponse(['message' => 'Route updated successfully']);
        } else {
            return sendResponse(['message' => 'Failed to update route'], 500);
        }
    } catch (PDOException $e) {
        // Print SQL query and detailed error message for debugging
        return sendResponse(['message' => 'Failed to update route. Error: ' . $e->getMessage()], 500);
    }
}


function sendResponse($data, $status_code = 200) {
    header('Content-Type: application/json');
    http_response_code($status_code);
    echo json_encode($data);
    exit; // Ensure script execution stops after sending the response
}

?>
