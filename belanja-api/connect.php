<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$server = "localhost";
$username = "root";
$password = "";
$db = "belanja-api";

$conn = new mysqli($server, $username, $password, $db);
if (!$conn) {
    die("Koneksi gagal: " . mysqli_connect_error());
}
