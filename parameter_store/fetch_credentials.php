<?php
require 'vendor/autoload.php';

use Aws\Ssm\SsmClient;

function getParameter($name) {
    $client = new SsmClient([
        'version' => 'latest',
        'region'  => 'eu-west-2' // e.g., 'us-west-2'
    ]);

    $result = $client->getParameter([
        'Name' => $name,
        'WithDecryption' => true
    ]);

    return $result['Parameter']['Value'];
}

$db_host = getParameter('/phpwebapp/DB_HOST');
$db_username = getParameter('/phpwebapp/DB_USERNAME');
$db_password = getParameter('/phpwebapp/DB_PASSWORD');
$db_name = getParameter('/phpwebapp/DB_NAME');
?>
