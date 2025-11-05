<?php

$date = (new DateTime())->setTimeZone(new DateTimeZone('UTC'))->format('Y-m-d H:i:s');
$file = "/var/tmp/dsu-output-log.txt";
       $f=fopen($file, 'a');
fwrite($f, "\n****************************************************************\n");
fwrite($f, 'received on '. $date . ' from ' . $_SERVER['REMOTE_ADDR']."\n");
      fclose($f);

file_put_contents("/var/tmp/dsu-output-log.txt", file_get_contents("php://input"), FILE_APPEND);

?>
# takes in data as POST request (no auth) and appends it to writeable file
