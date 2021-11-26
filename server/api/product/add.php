<?php
    if (isset($_GET['id_user']) && isset($_GET['id_produk']) && isset($_GET['nama']) && isset($_GET['keterangan']) && isset($_GET['harga']) && isset($_GET['stok']) && isset($_GET['gambar'])) {
        require_once("../koneksi.php");
        
        $id_user = $_GET['id_user'];
        $id_produk = $_GET['id_produk'];
        $nama = $_GET['nama'];
        $keterangan = $_GET['keterangan'];
        $harga = $_GET['harga'];
        $stok = $_GET['stok'];
        $gambar = $_GET['gambar'];
        
        $queryCheckProduct = mysqli_query($koneksi, "SELECT * FROM produk WHERE id='$id_produk'");
        if(mysqli_num_rows($queryCheckProduct) == 0){
            mysqli_query($koneksi, "INSERT INTO produk (id, nama, keterangan, harga, gambar) VALUES ('$id_produk', '$nama', '$keterangan', '$harga', '$gambar')");
        }
        $queryCheckProductUser = mysqli_query($koneksi, "SELECT * FROM produk_toko WHERE id_users='$id_user' AND id_produk='$id_produk'");
        if(mysqli_num_rows($queryCheckProductUser) == 0){
            $sql = "INSERT INTO produk_toko (id_users, id_produk, nama, keterangan, harga, stok, gambar) VALUES ('$id_user', '$id_produk', '$nama', '$keterangan', '$harga', '$stok', '$gambar')";
            
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