<?php
    header('Content-Type: application/json; charset=utf-8');
    if(isset($_POST['id_user'])) {
        require_once("../koneksi.php");
        $id_user = $_POST['id_user'];
        
        $queryGetTransaction = mysqli_query($koneksi, "SELECT * FROM transaction WHERE id_users='$id_user' ORDER BY datetime_transaction DESC");
        $totalTransaction = mysqli_num_rows($queryGetTransaction);
        $queryGetRevenue = mysqli_query($koneksi, "SELECT SUM(bill) AS total_revenue FROM transaction WHERE id_users='$id_user'");
        $totalRevenue = $queryGetRevenue->fetch_array(MYSQLI_ASSOC)['total_revenue'];
        
        $queryGetToday = mysqli_query($koneksi, "SELECT * FROM transaction WHERE id_users='$id_user' AND DAY(datetime_transaction)=DAY(NOW()) AND MONTH(datetime_transaction)=MONTH(NOW()) AND YEAR(datetime_transaction)=YEAR(NOW()) ORDER BY datetime_transaction DESC");
        $totalTodayTransaction = mysqli_num_rows($queryGetToday);
        $queryGetTodayRevenue = mysqli_query($koneksi, "SELECT SUM(bill) AS total_revenue FROM transaction WHERE id_users='$id_user' AND DAY(datetime_transaction)=DAY(NOW()) AND MONTH(datetime_transaction)=MONTH(NOW()) AND YEAR(datetime_transaction)=YEAR(NOW())");
        $totalTodayRevenue = $queryGetTodayRevenue->fetch_array(MYSQLI_ASSOC)['total_revenue'];
        
        $queryGetMonth = mysqli_query($koneksi, "SELECT * FROM transaction WHERE id_users='$id_user' AND MONTH(datetime_transaction)=MONTH(NOW()) AND YEAR(datetime_transaction)=YEAR(NOW()) ORDER BY datetime_transaction DESC");
        $totalMonthTransaction = mysqli_num_rows($queryGetMonth);
        $queryGetMonthRevenue = mysqli_query($koneksi, "SELECT SUM(bill) AS total_revenue FROM transaction WHERE id_users='$id_user' AND MONTH(datetime_transaction)=MONTH(NOW()) AND YEAR(datetime_transaction)=YEAR(NOW())");
        $totalMonthRevenue = $queryGetMonthRevenue->fetch_array(MYSQLI_ASSOC)['total_revenue'];
        
        $queryGetYear = mysqli_query($koneksi, "SELECT * FROM transaction WHERE id_users='$id_user' AND YEAR(datetime_transaction)=YEAR(NOW()) ORDER BY datetime_transaction DESC");
        $totalYearTransaction = mysqli_num_rows($queryGetYear);
        $queryGetYearRevenue = mysqli_query($koneksi, "SELECT SUM(bill) AS total_revenue FROM transaction WHERE id_users='$id_user' AND YEAR(datetime_transaction)=YEAR(NOW())");
        $totalYearRevenue = $queryGetYearRevenue->fetch_array(MYSQLI_ASSOC)['total_revenue'];
        
        $queryUserProducts = mysqli_query($koneksi, "SELECT * FROM produk_toko WHERE id_users='$id_user'");
        $totalUserProducts = mysqli_num_rows($queryUserProducts);
        
        $data = array(
            'status' => true,
            'message' => "success",
            'data' => array(
                'total_orders' => $totalTransaction,
                'today_orders' => $totalTodayTransaction,
                'month_orders' => $totalMonthTransaction,
                'year_orders' => $totalYearTransaction,
                'total_today_revenue' => (int) $totalTodayRevenue,
                'total_month_revenue' => (int) $totalMonthRevenue,
                'total_year_revenue' => (int) $totalYearRevenue,
                'total_revenue' => (int) $totalRevenue,
                'total_products' => $totalUserProducts,
            )
        );
        
        echo json_encode($data);
    } else {
        $data = array(
            'status' => false,
            'message' => "invalid query parameter"
        );
        
        echo json_encode($data);
    }
?>