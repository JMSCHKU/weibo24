<?php

$hash = $_GET["hash"];

if(isset($hash)) {
	# If this hash doesn't exist, redirect back to the index	
	if (!is_dir($hash)) {
		header("Location: .");
		exit;
	}

	$url = file_get_contents($hash."/url.txt");

	echo "Original image: <a href=\"".$url."\">".$url."</a><p />";

	$files = glob($hash."/".$hash."*");

	foreach ($files as &$value) {
		echo "<img src=\"".$value."\"><p />";
	}
} else {
	header("Location: .");
}
