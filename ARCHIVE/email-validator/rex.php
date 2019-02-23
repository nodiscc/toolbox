<?php

// Tells if a token is ok. Using this function will destroy the token.
// true=token is ok.

/*
function check_token($token) {
	if (isset($_SESSION['tokens'][$token])) {
		//unset($_SESSION['tokens'][$token]); // Token is used: destroy it.
		return TRUE; // Token is ok.
	}
	return FALSE; // Wrong token, or already used.
}


if (!isset($_POST['token']) or check_token($_POST['token']) === FALSE) die('Wrong token. Please enable cookies to uses this page.');
*/

include('is_email.php');

if (isset($_POST['m'])) {
	$email = $_POST['m'];
} else {
	echo 'Aucune email ';
}



if (is_email($email) === TRUE) {
	echo 'TRUE';
} else {
	echo 'FALSE';
}
