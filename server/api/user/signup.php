<?php
    header('Content-Type: application/json; charset=utf-8');
    if (isset($_POST['email']) && isset($_POST['password'])) {
        require_once("../koneksi.php");
        
        $username = $_POST['username'];
        $email = $_POST['email'];
        $pass = $_POST['password'];
        $queryCheckEmail = mysqli_query($koneksi, "SELECT * FROM users WHERE email='$email'");
            if(mysqli_num_rows($queryCheckEmail) == 0){
            $sql = "INSERT INTO users (username, email, password) VALUES ('$username', '$email', '$pass')";
            
            if($query = mysqli_query($koneksi, $sql)){
                try {
                    $queryGetLast = mysqli_query($koneksi, "SELECT * FROM users ORDER BY id DESC LIMIT 1");
                    $getLast = $queryGetLast->fetch_array(MYSQLI_ASSOC);
                    $path1 = "../../assets/users/" . $getLast['id'];
                    mkdir($path1);
                    $path2 = "../../assets/users/" . $getLast['id'] . "/products";
                    mkdir($path2);
                    $data = array(
                        'status' => true,
                        'message' => $username." berhasil didaftarkan, silahkan login."
                    );
                    
                    echo json_encode($data);
                } catch(Exception $e) {
                    $data = array(
                        'status' => false,
                        'message' => "Failure to add, " . $e->getMessage()
                    );
                    
                    echo json_encode($data);
                }
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
                'message' => "akun dengan email tersebut sudah terdaftar, silahkan menggunakan email lain."
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