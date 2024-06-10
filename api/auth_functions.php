<?php
// auth_functions.php

function generateToken() {
    return bin2hex(random_bytes(16)); // Generates a 32-character token
}

function registerUser($pdo, $username, $password) {
    try {
        $hashedPassword = password_hash($password, PASSWORD_BCRYPT);
        $token = generateToken();
        $stmt = $pdo->prepare('INSERT INTO users (username, password, token) VALUES (?, ?, ?)');
        if ($stmt->execute([$username, $hashedPassword, $token])) {
            return ['status' => 'success', 'message' => 'User registered successfully', 'token' => $token];
        } else {
            return ['status' => 'error', 'message' => 'Error registering user'];
        }
    } catch (PDOException $e) {
        return ['status' => 'error', 'message' => 'Error registering user: ' . $e->getMessage()];
    }
}

function loginUser($pdo, $username, $password) {
    try {
        $stmt = $pdo->prepare('SELECT * FROM users WHERE username = ?');
        $stmt->execute([$username]);
        $user = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($user && password_verify($password, $user['password'])) {
            $token = generateToken();
            $updateStmt = $pdo->prepare('UPDATE users SET token = ? WHERE id = ?');
            $updateStmt->execute([$token, $user['id']]);
            return ['status' => 'success', 'message' => 'Login successful', 'token' => $token];
        } else {
            return ['status' => 'error', 'message' => 'Invalid username or password'];
        }
    } catch (PDOException $e) {
        return ['status' => 'error', 'message' => 'Error logging in: ' . $e->getMessage()];
    }
}

function authenticate($pdo, $token) {
    try {
        $stmt = $pdo->prepare('SELECT * FROM users WHERE token = ?');
        $stmt->execute([$token]);
        $user = $stmt->fetch(PDO::FETCH_ASSOC);
        return $user !== false;
    } catch (PDOException $e) {
        return false;
    }
}
?>
