<?php
    error_reporting(0);
    $server = "localhost";
    $username = "xxxx_user";
    $password = "xxxx";
    $database = "xxxx_db";

    $koneksi = mysqli_connect($server,$username,$password,$database) OR DIE (json_encode($data = array('status' => false, 'message' => "Error database")));
?>