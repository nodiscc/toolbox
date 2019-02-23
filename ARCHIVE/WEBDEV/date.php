<!-- Output current server date and timezone
https://stackoverflow.com/questions/470617/get-current-date-and-time-in-php
-->
<?php
$timezone = date_default_timezone_get();
echo "The current server timezone is: " . $timezone . "<br/>";
$date = date('m/d/Y h:i:s a', time());
echo "Current server date is " . $date
?>
