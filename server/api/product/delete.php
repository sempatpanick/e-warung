<?php
    header('Content-Type: application/json; charset=utf-8');
    if (isset($_POST['id_users']) && isset($_POST['id_produk'])) {
        require_once("../koneksi.php");
        
        $id_user = $_POST['id_users'];
        $id_produk = $_POST['id_produk'];
        
        $sql = "DELETE FROM produk_toko WHERE id_users='$id_user' AND id_produk='$id_produk'";
        
        if($query = mysqli_query($koneksi, $sql)){
            $data = array(
                'status' => true,
                'message' => "Produk telah dihapus"
            );
            
            echo json_encode($data);
        } else {
            $data = array(
                'status' => false,
                'message' => "Failure to delete"
            );
            
            echo json_encode($data);
        }
    } else {
        $data = array(
            'status' => false,
            'message' => "invalid query parameters"
        );
        
        echo json_encode($data);
    }
?>