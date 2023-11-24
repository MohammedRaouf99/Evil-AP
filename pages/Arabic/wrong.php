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
    
    
</style>
<body>
	<div>
		<b>كلمة المرور غير صحيحة</b>
		<br>
		<br>
		<b>الرجاء المحاولة مره اخرى</b>
	</div>
</body>
</html>
<?php
header("Refresh: 2 ; url= index.html")
?>