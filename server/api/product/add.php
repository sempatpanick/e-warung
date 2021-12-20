<?php
    header('Content-Type: application/json; charset=utf-8');
    if (isset($_POST['id_user']) && isset($_POST['id_product']) && isset($_POST['nama']) && isset($_POST['harga']) && isset($_POST['stok']) && isset($_POST['gambar'])) {
        require_once("../koneksi.php");
        
        $id_user = $_POST['id_user'];
        $id_product = $_POST['id_product'];
        $nama = $_POST['nama'];
        if (isset($_POST['keterangan'])) {
            $keterangan = $_POST['keterangan'];
        } else {
            $keterangan = "";
        }
        $harga = $_POST['harga'];
        $stok = $_POST['stok'];
        if (isset($_POST['base_image'])) {
            $base64_string = $_POST["base_image"];
            if ($base64_string != "") {
                $gambar = $_POST['gambar'];
                $savePath = "../../assets/users/".$gambar;
                // $savePath = "uploads/".$gambar;
                
                $filehandler = fopen($savePath, 'wb' ); 
                
                fwrite($filehandler, base64_decode($base64_string));
                fclose($filehandler);
            } else {
                $gambar = $_POST['gambar'];
            }
        } else {
            $gambar = $_POST['gambar'];
        }
        
        $queryCheckProduct = mysqli_query($koneksi, "SELECT * FROM produk WHERE id='$id_product'");
        if(mysqli_num_rows($queryCheckProduct) == 0){
            mysqli_query($koneksi, "INSERT INTO produk (id, nama, keterangan, harga, gambar) VALUES ('$id_product', '$nama', '$keterangan', '$harga', '$gambar')");
        }
        
        $queryCheckProductUser = mysqli_query($koneksi, "SELECT * FROM produk_toko WHERE id_users='$id_user' AND id_produk='$id_product'");
        if(mysqli_num_rows($queryCheckProductUser) == 0){
            $sql = "INSERT INTO produk_toko (id_users, id_produk, nama, keterangan, harga, stok, gambar) VALUES ('$id_user', '$id_product', '$nama', '$keterangan', '$harga', '$stok', '$gambar')";
            
            if($query = mysqli_query($koneksi, $sql)){
                $data = array(
                    'status' => true,
                    'message' => "Produk ".$nama." telah ditambahkan ke toko."
                );
                
                echo json_encode($data);
            } else {
                $data = array(
                    'status' => false,
                    'message' => "Failure to add product"
                );
                
                echo json_encode($data);
            }
        } else {
            $data = array(
                'status' => false,
                'message' => "produk sudah ada di toko anda"
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