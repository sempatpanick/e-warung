<?php
    if (isset($_GET['username']) && isset($_GET['password'])) {
        require_once("../koneksi.php");
        
        $username = $_GET['username'];
        $pass = $_GET['password'];
        
        $query = mysqli_query($koneksi, "SELECT * FROM users WHERE username='$username' AND password='$pass'");
        if(mysqli_num_rows($query) > 0){
            $data = array(
                'status' => true,
                'message' => "Login success"
            );
            
            echo json_encode($data);
        } else {
            $data = array(
                'status' => false,
                'message' => "Username/password salah"
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