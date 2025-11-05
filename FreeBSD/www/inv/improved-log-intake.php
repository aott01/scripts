<?php

$date = (new DateTime())->setTimeZone(new DateTimeZone('UTC'))->format('Y-m-d H:i:s');
$file = "/var/tmp/dsu-output-log.txt";

function sanitize($value) {
    if (is_array($value)) {
        return array_map('sanitize', $value);
    }
    $value = strip_tags($value);
    $value = htmlspecialchars($value, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');
    $value = substr(trim($value), 0, 16384); // max length per field
    return $value;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $sanitized = array();
    foreach ($_POST as $key => $value) {
        $sanitized[$key] = sanitize($value);
    }

    if (empty($sanitized)) {
        $raw = file_get_contents("php://input");
        $decoded = json_decode($raw, true);
        if (is_array($decoded)) {
            $sanitized = array_map('sanitize', $decoded);
        } else {
            $raw = substr($raw, 0, 4096); // Limit to 4k
            $sanitized = ["raw_body" => base64_encode($raw)];
        }
    }

    $log  = "\n****************************************************************\n";
    $log .= 'received on ' . $date . ' from ' . $_SERVER['REMOTE_ADDR'] . "\n";
    $log .= "POST data:\n";
    foreach ($sanitized as $k => $v) {
        if (is_array($v)) {
            $v = json_encode($v);
        }
        $log .= "  $k: $v\n";
    }
    file_put_contents($file, $log, FILE_APPEND);

} else {
    // Not a POST, respond with 405 Method Not Allowed
    http_response_code(405);
    echo "Error 405: method not allowed.";
    // Optional: still log the attempt
    file_put_contents($file, "\nAttempted non-POST on $date from ".$_SERVER['REMOTE_ADDR']."\n", FILE_APPEND);
    exit;
}

?>

#What did AI do?
#
#Sanitized each value with strip_tags, htmlspecialchars, and limited size.
#If JSON or raw, base64 encode to make log safe.
#Logged key/value pairs, so structure is clearer.
#Prevent log poisoning and reduce risk of script execution if logs are parsed elsewhere.
#Sends a 405 HTTP status code if the method is not POST.
#Outputs an error message for the client.
#Logs any non-POST attempt into the file.
