<?php 
// gzip compression
function initOutputFilter() {
  ob_start('ob_gzhandler');
  register_shutdown_function('ob_end_flush');
}
initOutputFilter();

session_start();

/*
// Code from Shaarli. Generate an unique sess_id, usable only once.
function new_token() {
	$rnd = sha1(uniqid('',true).mt_rand());  // We generate a random string.
	$_SESSION['tokens'][$rnd]=1;  // Store it on the server side.
	return $rnd;
}
*/

?>

<!DOCTYPE html>
<html lang="fr-fr">
<head>
	<meta charset="UTF-8" />
	<meta name="author" content="Timo van Neerden" />

	<meta name="keywords" content="binaire, hexadécimal, bases, octal, décimal, conversion" />
	<meta name="description" content="Un validateur d’Email en ligne, qui tient compte des RFC correspondants" />

	<title>Vérifier la validité d’une adresse email - le hollandais volant</title>

	<style type="text/css">

body {
	background-color: white;
	color: #222;
	text-align: center;
	font-size: 16px;
	font-family: 'trebuchet ms', arial, sans-serif;
}

a { text-decoration: none; color: inherit; }
a:hover { text-decoration: underline; }

#header {
	margin: 30px auto 70px;
}

#header .titre {
	font-size: 220%;
	text-shadow: 3px 3px 5px silver;
}

#main-form {
	border: 1px solid silver;
	border-radius: 20px;
	min-width: 600px;
	width: 70%;
	max-width: 1000px;
	margin: 0 auto 50px;
	padding: 70px 70px 20px;
}

#main-form .text {
	padding: 3px 4px;
	width: 400px;
	border: 1px solid silver;
	border-radius: 5px;
	text-align: left;
	margin-left: 5px;
	margin-right: 5px;
}

#main-form .centrer {
	display: block;
	text-align: center;
	vertical-align: middle;
	margin: auto auto;
}



#main-form .submit-centrer {
	margin: 30px auto;
	height: 2em;
	line-height: 2em;
	width: 10em;
	font-size: 120%;
	vertical-align: middle;
	text-shadow: 0 1px 1px rgba(0,0,0,.3);
	border-radius: 7px;
	box-shadow: rgba(0, 0, 0, 0.506) 0px 1px 2px 0px;
	color: #fff;
	border: solid 1px red;
	background: #EB0003;
	background: -webkit-linear-gradient(bottom, rgba(255, 255, 255, .6), rgba(255, 255, 255, 0)), #EB0003;
	background: -moz-linear-gradient(bottom, rgba(255, 255, 255, .6), rgba(255, 255, 255, 0)), #EB0003;
	background: -ms-linear-gradient(bottom, rgba(255, 255, 255, .6), rgba(255, 255, 255, 0)), #EB0003;
	background: -o-linear-gradient(bottom, rgba(255, 255, 255, .6), rgba(255, 255, 255, 0)), #EB0003;
	background: linear-gradient(bottom, rgba(255, 255, 255, .6), rgba(255, 255, 255, 0)), #EB0003;
}

#main-form .submit-centrer:active {
	position: relative;
	top: 1px;
	color: #ffdddd;
	background: #EB0003;
	background: -webkit-linear-gradient(bottom, rgba(255, 255, 255, .6), rgba(255, 255, 255, 0)), #EB0003;
	background: -moz-linear-gradient(bottom, rgba(255, 255, 255, .6), rgba(255, 255, 255, 0)), #EB0003;
	background: -ms-linear-gradient(bottom, rgba(255, 255, 255, .6), rgba(255, 255, 255, 0)), #EB0003;
	background: -o-linear-gradient(bottom, rgba(255, 255, 255, .4), rgba(255, 255, 255, .1)), #EB0003;
	background: linear-gradient(bottom, rgba(255, 255, 255, .6), rgba(255, 255, 255, 0)), #EB0003;
}


.notes {
	margin-top: 50px;
	color:gray;
	text-align: left;
}

#footer {
	font-size: 90%;
	color: black;
}

b.green {
	color: green;
}
b.red {
	color: red;
}

#response {
	font-size: 110%;
}
	</style>
</head>
<body>


<header id="header">
	<h1 class="titre">Vérifier la validité d’une adresse email</h1>
</header>

<form id="main-form" onsubmit="return test();">
	<label for="mail">Email à tester&nbsp;:</label> 
	<input type="text" id="mail" value="mail@example.com" name="mail" placeholder="mail@example.com" class="text" />

	<input type="submit" onclick="return test();" id="d" value="Vérifier" class="centrer submit-centrer"/>

	<p id="response">Veuillez entrer une adresse email.</p>

	<div class="notes">
		<ul>
			<li>La validation est faite avec la bibliothèque <a href="http://code.google.com/p/isemail/">Isemail</a>, sous license BSD.</li>
			<li>Isemail respecte les normes décrites dans les RFC <a href="http://tools.ietf.org/html/rfc5321">5321</a>, <a href="http://tools.ietf.org/html/rfc3696">3696</a>, <a href="http://tools.ietf.org/html/rfc2822">2822</a>.</li>
			<li>La règle où le nom de domaine doit être résolvable n’est pas testée, seul le format de l’adresse l’est.</li>
		</ul>

	</div>

</form>


<div id="download">
	<p><a href="index.7z"><img src="download.png" alt="download" title="Télécharger"/></a></p>
</div>


<footer id="footer"><a href="/">Timo Van Neerden</a> - <a href="../">autres outils</a></footer>



<script type="text/javascript">
/* <![CDATA[ */



// create and send form
function test() {
	var xhr = new XMLHttpRequest();
	xhr.open('POST', 'rex.php');
	xhr.onload = function() {

		if (this.responseText == 'TRUE') {
			document.getElementById('response').innerHTML = 'L’adresse email est <b class="green">valide</b>.';
		} else {
			document.getElementById('response').innerHTML = 'L’adresse email est <b class="red">invalide</b>.';
		}
	};

	// prepare and send FormData
	var formData = new FormData();  
	formData.append( 'm', document.getElementById('mail').value );
	xhr.send(formData);

	return false;
}
/* ]]> */
</script>



<!--

# adresse de la page : http://lehollandaisvolant.net/dossier/page.html
#      page créée le : 25 février 2013
#     mise à jour le : 25 février 2013

-->
</body>
</html>

