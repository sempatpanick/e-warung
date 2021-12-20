<?php
    header('Content-Type: application/json; charset=utf-8');
    if (isset($_POST['id_user']) && isset($_POST['bill']) && isset($_POST['paid']) && isset($_POST['change_bill']) && isset($_POST['products'])) {
        require_once("../koneksi.php");
        
        $id_user = $_POST['id_user'];
        $bill = $_POST['bill'];
        $paid = $_POST['paid'];
        $change_bill = $_POST['change_bill'];
        $products = $_POST['products'];
        
        $sql = "INSERT INTO transaction (id_users, bill, paid, change_bill) VALUES ('$id_user', '$bill', '$paid', '$change_bill')";
        
        if($query = mysqli_query($koneksi, $sql)){
            $dataProducts = json_decode($products);
            
            $dataTransaction = mysqli_query($koneksi, "SELECT * FROM transaction ORDER BY id DESC LIMIT 1");
            
            
            $data = array(
                'status' => true,
                'message' => "Transaksi berhasil."
            );
            
            echo json_encode($data);
            while ($rowTransaction = mysqli_fetch_assoc($dataTransaction)) {
                for ($i = 0; $i < count($dataProducts); $i++) {
                    $id_transaction = $rowTransaction['id'];
                    $id_product = $dataProducts[$i]->id_product;
                    $amount = $dataProducts[$i]->amount;
                    $price = $dataProducts[$i]->price;
                    
                    $sqlProduct = "INSERT INTO transaction_detail (id_transaction, id_produk, amount, price) VALUES ('$id_transaction', '$id_product', '$amount', '$price')";
                    
                    if($queryProduct = mysqli_query($koneksi, $sqlProduct)){
                        $dataTransaction = mysqli_query($koneksi, "SELECT * FROM produk_toko WHERE id_users = '$id_user' AND id_produk = '$id_product'");
                        while ($rowProductStore = mysqli_fetch_assoc($dataTransaction)) {
                            $id_product_store = $rowProductStore['id'];
                            $stock = $rowProductStore['stok'] - $amount;
                            if (mysqli_query($koneksi, "UPDATE produk_toko SET stok='$stock' WHERE id=$id_product_store")) {
                                $jsonProductStock = array(
                                    'status' => true,
                                    'message' => "Pengurangan stok berhasil."
                                );
                            } else {
                                $jsonProductStock = array(
                                    'status' => true,
                                    'message' => "Pengurangan stok gagal."
                                );
                            }
                        }
                        $jsonProduct = array(
                            'status' => true,
                            'message' => "Transaksi product success."
                        );
                    } else {
                        $jsonProduct = array(
                            'status' => false,
                            'message' => "Transaction product failed"
                        );
                    }
                }
            }
        } else {
            $data = array(
                'status' => false,
                'message' => "Transaction failed"
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