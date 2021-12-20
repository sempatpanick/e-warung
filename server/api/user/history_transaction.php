<?php
    header('Content-Type: application/json; charset=utf-8');
    if(isset($_POST['id_user'])) {
        require_once("../koneksi.php");
        $id_user = $_POST['id_user'];
        $query = mysqli_query($koneksi, "SELECT * FROM transaction WHERE id_users='$id_user' ORDER BY datetime_transaction DESC");
        if(mysqli_num_rows($query) > 0){
            $myArray = array();
            while ($row = $query->fetch_array(MYSQLI_ASSOC)) {
                $detailArray = array();
                $id_transaction = $row['id'];
                $queryDetail = mysqli_query($koneksi, "SELECT * FROM transaction_detail WHERE id_transaction='$id_transaction'");
                while ($detailRow = $queryDetail->fetch_array(MYSQLI_ASSOC)) {
                    $id_product = $detailRow['id_produk'];
                    $queryProduct = mysqli_query($koneksi, "SELECT * FROM produk_toko WHERE id_users='$id_user' AND id_produk='$id_product'");
                    $queryProduct2 = mysqli_query($koneksi, "SELECT * FROM produk WHERE id='$id_product'");
                    $getProduct = $queryProduct->fetch_array(MYSQLI_ASSOC);
                    $getProduct2 = $queryProduct2->fetch_array(MYSQLI_ASSOC);
                    if ($getProduct) {
                        $productName = $getProduct['nama'];
                    } else if ($getProduct2) {
                        $productName = $getProduct2['nama'];
                    } else {
                        $productName = $detailRow['id_produk'];
                    }
                    $detailArray[] = array(
                        "id_transaction" => $detailRow['id_transaction'],
                        "id_produk" => $detailRow['id_produk'],
                        "name" => $productName,
                        "amount" => $detailRow['amount'],
                        "price" => $detailRow['price']
                    );
                }
                $myArray[] = array(
                    "id" => $id_transaction,
                    "id_users" => $row['id_users'],
                    "bill" => $row['bill'],
                    "paid" => $row['paid'],
                    "change_bill" => $row['change_bill'],
                    "datetime_transaction" => $row['datetime_transaction'],
                    "items" => $detailArray
                );
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
                'message' => "History transaction is empty",
                'data' => []
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