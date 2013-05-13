<html>
<head>

<!-- Load in Google fonts -->
        <link href='http://fonts.googleapis.com/css?family=Open+Sans' rel='stylesheet' type='text/css'>
<!-- Our own style sheet to adjust fonts -->
    <link rel="stylesheet" href="/style.css" />
</head>
<body>
<?php

$url = $_GET["url"];

if(isset($url)) {
	$hash = md5($url);
	# Download the URL (check the headers first), download file in to folder created by the hash, and run multi
	# in_array("Content-Type: image/gif",get_headers($url));
	
	# If this is the first time we've encountered this URL, let's hash it	
	if (!is_dir($hash)) {
		mkdir($hash);
	}

	# Let's construct the filename from the URL	
	$filename = $hash.'/'.basename($url);
	$urlfile = $hash.'/url.txt';

	# If the file already exists (we've already downloaded it), let's move on)
	if (!is_file($filename)) {
		file_put_contents($urlfile, $url);
		file_put_contents($filename, file_get_contents($url));	
	}

	# Now let's try and split the file
	$output = shell_exec('./multicrop '.$filename.' '.$hash.'/'.$hash.'.png');
	
	echo "Original image: <a href=\"".$url."\">".$url."</a><p />";

        $files = glob($hash."/".$hash."*");

        foreach ($files as &$value) {
                echo "<img src=\"".$value."\"><p />";
        }
} else {
?>
	<form>
		<input type="text" name="url"><br />
		<input type="submit" value="Submit">
	</form>
<?php
}
?>
</body>
</html>
