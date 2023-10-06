<?php
require 'connect.php';

$method = $_SERVER["REQUEST_METHOD"];

if ($method === "GET") {
    $result = mysqli_query($conn, "select * from daftar_belanja");

    if ($result->num_rows > 0) {
        $daftar = array();
        while ($row = $result->fetch_assoc()) {
            $daftar[] = $row;
        }
        echo json_encode($daftar);
    } else {
        echo "Data kosong";
    }
}

if ($method === "POST") {
    $data = json_decode(file_get_contents("php://input"), true);

    $nama = $data["nama"];
    $jumlah = $data["jumlah"];

    $query = mysqli_query($conn, "insert into daftar_belanja (nama, jumlah) values ('$nama', '$jumlah')");
    if ($query === true) {
        $data['pesan'] = 'Berhasil menambahkan';
    } else {
        $data['pesan'] = "Error" . $query;
    }

    echo json_encode($data);
}

if ($method === "PUT") {
    $data = json_decode(file_get_contents("php://input"), true);

    $id = $data["id"];
    $nama = $data["nama"];
    $jumlah = $data["jumlah"];

    $query = mysqli_query($conn, "update daftar_belanja set nama = '$nama', jumlah = '$jumlah' where id = '$id'");
    if ($query === true) {
        $data["pesan"] = 'Berhasil memperbarui';
    } else {
        echo "Error: " . $query;
    }
}

if ($method === "DELETE") {
    $id = $_GET["id"];

    $query = mysqli_query($conn, "delete from daftar_belanja where id = '$id'");
    if ($query === true) {
        $data['pesan'] = 'Berhasil menghapus';
    } else {
        $data['pesan'] = "Error: " . $query;
    }

    echo json_encode($data);
}

$conn->close();
