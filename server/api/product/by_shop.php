<?php
    if(isset($_GET['id_users']) && isset($_GET['id_produk'])) {
        require_once("../koneksi.php");
        $id_users = $_GET['id_users'];
        $id_produk = $_GET['id_produk'];
        $query = mysqli_query($koneksi, "SELECT * FROM produk_toko WHERE id_users='$id_users' AND id_produk='$id_produk'");
        if(mysqli_num_rows($query) > 0){
            $myArray = array();
            while ($row = $query->fetch_array(MYSQLI_ASSOC)) {
                $myArray[] = $row;
            }
            
            $data = array(
                'status' => true,
                'message' => "success",
                'data' => $myArray
            );
            
            echo json_encode($data);
        } else {
            $data = array(
                'status' => false,
                'message' => "wrong id users or id produk"
            );
            
            echo json_encode($data);
        }
    } else if(isset($_GET['id_users'])) {
        require_once("../koneksi.php");
        $id_users = $_GET['id_users'];
        $query = mysqli_query($koneksi, "SELECT * FROM produk_toko WHERE id_users='$id_users'");
        if(mysqli_num_rows($query) > 0){
            $myArray = array();
            while ($row = $query->fetch_array(MYSQLI_ASSOC)) {
                $myArray[] = $row;
            }
            
            $data = array(
                'status' => true,
                'message' => "success",
                'data' => $myArray
            );
            
            echo json_encode($data);
        } else {
            $data = array(
                'status' => false,
                'message' => "id users not found"
            );
            
            echo json_encode($data);
        }
    } else {
        $data = array(
            'status' => false,
            'message' => "need parameter authentication"
        );
        
        echo json_encode($data);
    }
?>