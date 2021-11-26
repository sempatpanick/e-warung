<?php
    if(isset($_GET['id_produk'])) {
        require_once("../koneksi.php");
        $id_produk = $_GET['id_produk'];
        $query = mysqli_query($koneksi, "SELECT * FROM produk WHERE id='$id_produk'");
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
                'message' => "produk tidak tersedia"
            );
            
            echo json_encode($data);
        }
    } else {
        $data = array(
            'status' => false,
            'message' => "invalid query parameter"
        );
        
        echo json_encode($data);
    }
?>