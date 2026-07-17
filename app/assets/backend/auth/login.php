<?php

require_once "../helpers/DatabaseHelper.php";

$db = new DatabaseHelper();

$conn = $db->getConnection();

$usuario = $_POST["username"] ?? "";
$contrasena = $_POST["password"] ?? "";

$sql = "
SELECT
    ID_USUARIO,
    NOMBRE_USUARIO,
    CONTRASENA_HASH
FROM USUARIO
WHERE NOMBRE_USUARIO = :usuario
AND ESTADO = 'ACTIVO'
";

$stmt = oci_parse($conn, $sql);

oci_bind_by_name($stmt, ":usuario", $usuario);

oci_execute($stmt);

$fila = oci_fetch_assoc($stmt);

if (!$fila) {

    header("Location: ../../../login.html?error=1");
    exit;

}

if ($fila["CONTRASENA_HASH"] !== $contrasena) {

    header("Location: ../../../login.html?error=1");
    exit;

}

session_start();

$_SESSION["id_usuario"] = $fila["ID_USUARIO"];

$_SESSION["usuario"] = $fila["NOMBRE_USUARIO"];

header("Location: ../../../pages/dashboard.html");

exit;