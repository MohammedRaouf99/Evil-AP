<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Document</title>
    </head>
    <style>
        div {
            
		background-color: white;
		color : red ;
        width: auto;
		height: 80px;
		border: 3px solid red;
		border-radius: 5px;
		padding-top: 20px;
		align-content: center;
		text-align: center;
		font-size: 17px;
		font-family: Verdana, Geneva, Tahoma, sans-serif;
	}
    
    
</style>
<body>
	<div>
		<b>sorry the password is incorrect !</b>
		<br>
		<br>
		<b>please try again</b>
	</div>
</body>
</html>
<?php
header("Refresh: 2 ; url= index.html")
?>