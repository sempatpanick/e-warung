<?php
    header('Content-Type: application/json; charset=utf-8');
    require_once("koneksi.php");
    $query = mysqli_query($koneksi, "SELECT * FROM news ORDER BY date DESC LIMIT 5");
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
            'message' => "no news content",
            'data' => []
        );
        
        echo json_encode($data);
    }
?>