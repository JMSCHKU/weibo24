<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="google-translate-customization" content="480bf7299525afb9-61a084acf0f5feba-gb62cc5f74d03e861-24"></meta>

<!-- Load in Google fonts -->
        <link href='http://fonts.googleapis.com/css?family=Open+Sans' rel='stylesheet' type='text/css'>
<!-- Our own style sheet to adjust fonts -->
    <link rel="stylesheet" href="/style.css" />

</head>
<body>

        <form>
                Image URL: <input type="text" name="url"><br />
                Language:
                <select name="language">
                        <option value="chi_sim">Chinese (Simplified)</option>
                        <option value="chi_tra">Chinese (Traditional)</option>
                        <option value="eng">English</option>
                </select><br />
                <input type="submit" value="Submit">
        </form>


<?php

require_once 'google-api-php-client/src/Google_Client.php';
require_once 'google-api-php-client/src/contrib/Google_TranslateService.php';

$client = new Google_Client();
$client->setApplicationName('Google Translate PHP Starter Application');
$client->setDeveloperKey('AIzaSyAuUC3yOwInxjMD1UaqPkbJCvl_umc8LOI');
$service = new Google_TranslateService($client);

$url = $_GET["url"];
$language = $_GET["language"];
$thisurl = 'http'.(empty($_SERVER['HTTPS'])?'':'s').'://'.$_SERVER['SERVER_NAME'].$_SERVER['REQUEST_URI'];

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

	if(isset($language)) {
		$ocr = $hash.'/'.$language;
	} else {
		$ocr = $hash.'/text';
	}

	# If the file already exists (we've already downloaded it), let's move on)
	if (!is_file($filename)) {
		file_put_contents($urlfile, $url);
		file_put_contents($filename, file_get_contents($url));	
	}

	# Now let's try and extract the text
	if (!is_file($ocr.'.txt')) {
		if(isset($language)) {	
			$output = shell_exec('tesseract -l '.$language.' '.$filename.' '.$ocr);
		} else {
			$output = shell_exec('tesseract -l chi_sim '.$filename.' '.$ocr);
		}
	}

	print "<h1>Original image: </h1><a href=\"".$url."\"><img src=\"".$filename."\"></a><p />";
	$text = file_get_contents($ocr.'.txt');
	print "<h1>Original Text</h1><p>$text</p>";
        $translations = $service->translations->listTranslations($text, 'en');
        $translatedText = $translations['translations'][0]['translatedText'];
	print "<h1>English Translations</h1><p>$translatedText</p>";




}
?>
</body>
</html>
