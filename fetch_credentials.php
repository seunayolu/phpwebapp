<?php
require 'vendor/autoload.php';

use Aws\Ssm\SsmClient;

function getParameter($name) {
    $client = new SsmClient([
        'version' => 'latest',
        'region'  => getenv('AWS_REGION') // Use environment variable for region
    ]);

    $result = $client->getParameter([
        'Name' => $name,
        'WithDecryption' => true
    ]);

    return $result['Parameter']['Value'];
}

$db_host = getParameter('/webapp/DB_URL');
$db_username = getParameter('/webapp/DB_USERNAME');
$db_password = getParameter('/webapp/DB_PASSWORD');
$db_name = getParameter('/webapp/DB_NAME');
?>