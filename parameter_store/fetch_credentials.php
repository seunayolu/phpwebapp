<?php
require 'vendor/autoload.php';

use Aws\Ssm\SsmClient;

function getParameter($name) {
    $client = new SsmClient([
        'version' => 'latest',
        'region'  => 'eu-west-1' // e.g., 'us-west-2'
    ]);

    $result = $client->getParameter([
        'Name' => $name,
        'WithDecryption' => true
    ]);

    return $result['Parameter']['Value'];
}

$db_host = getParameter('/contactform/db-host');
$db_username = getParameter('/contactform/db-username');
$db_password = getParameter('/contactform/db-password');
$db_name = getParameter('/contactform/db-name');
?>
