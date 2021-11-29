<?php
    if (isset($_POST['email']) && isset($_POST['password'])) {
        require_once("../koneksi.php");

        $email = $_POST['email'];
        $pass = $_POST['password'];

        $query = mysqli_query($koneksi, "SELECT * FROM users WHERE email='$email' AND password='$pass'");
        if(mysqli_num_rows($query) > 0){
            $myArray = null;
            while ($row = $query->fetch_array(MYSQLI_ASSOC)) {
                $myArray = $row;
            }

            $data = array(
                'status' => true,
                'message' => "Login success",
                'data' => $myArray
            );

            echo json_encode($data);
        } else {
            $data = array(
                'status' => false,
                'message' => "Username/password salah",
            );

            echo json_encode($data);
        }
    } else {
        $data = array(
            'status' => false,
            'message' => "invalid query parameters",
        );
        
        echo json_encode($data);
    }
?>