<?php

require_once __DIR__ . '/../helpers/DatabaseHelper.php';

$db = new DatabaseHelper();

$conn = $db->getConnection();

$sql = "SELECT 'PRISMA conectado correctamente a Oracle' AS MENSAJE FROM DUAL";

$stmt = oci_parse($conn, $sql);

oci_execute($stmt);

$fila = oci_fetch_assoc($stmt);

?>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <title>PRISMA</title>
</head>

<body>

<h1><?= $fila['MENSAJE']; ?></h1>

</body>

</html>