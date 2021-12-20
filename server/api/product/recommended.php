<?php
    header('Content-Type: application/json; charset=utf-8');
    if(isset($_POST['id_product'])) {
        require_once("../koneksi.php");
        $id_product = $_POST['id_product'];
        $query = mysqli_query($koneksi, "SELECT * FROM produk WHERE id='$id_product'");
        if(mysqli_num_rows($query) > 0){
            $myArray = array();
            while ($row = $query->fetch_array(MYSQLI_ASSOC)) {
                $myArray = $row;
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