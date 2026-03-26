<?php
echo "<h1>LAMP Stack con Docker</h1>";
echo "<p>PHP Version: " . phpversion() . "</p>";

// Conexión a MySQL
$servername = "lamp_mysql";
$username = "lamp_user";
$password = "lamp_pass";
$dbname = "lamp_db";

try {
    $conn = new mysqli($servername, $username, $password, $dbname);
    if ($conn->connect_error) {
        throw new Exception("Connection failed: " . $conn->connect_error);
    }
    echo "<p>Conexión a MySQL exitosa!</p>";
} catch (Exception $e) {
    echo "<p>Error de conexión: " . $e->getMessage() . "</p>";
}
?>
