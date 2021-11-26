<?php
    if (isset($_GET['username']) && isset($_GET['password'])) {
        require_once("../koneksi.php");
        
        $username = $_GET['username'];
        $pass = $_GET['password'];
        
        $queryCheck = mysqli_query($koneksi, "SELECT * FROM users WHERE username='$username'");
        if(mysqli_num_rows($queryCheck) == 0){
            $sql = "INSERT INTO users (username, password) VALUES ('$username', '$pass')";
            
            if($query = mysqli_query($koneksi, $sql)){
                $data = array(
                    'status' => true,
                    'message' => $username." has been added."
                );
                
                echo json_encode($data);
            } else {
                $data = array(
                    'status' => false,
                    'message' => "Failure to add"
                );
                
                echo json_encode($data);
            }
        } else {
            $data = array(
                'status' => false,
                'message' => "username already exist"
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