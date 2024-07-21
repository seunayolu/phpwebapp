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

$db_host = getParameter('/phpwebapp/db_host');
$db_username = getParameter('/phpwebapp/db_username');
$db_password = getParameter('/phpwebapp/db_password');
$db_name = getParameter('/phpwebapp/db_name');
?>
