<?php

require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../common/middleware.php';
require_once __DIR__ . '/../common/response.php';
require_once __DIR__ . '/../helpers/DatabaseHelper.php';

requerirSesion();

$db   = new DatabaseHelper();
$conn = $db->getConnection();

$sql = "
    SELECT
        U.ID_USUARIO,
        U.NOMBRE_USUARIO,
        U.CORREO,
        U.ESTADO,
        U.ID_ROL,
        R.NOMBRE_ROL
    FROM USUARIO U
    JOIN ROL R ON R.ID_ROL = U.ID_ROL
    ORDER BY U.ID_USUARIO DESC
";

$stmt = oci_parse($conn, $sql);
oci_execute($stmt);

$usuarios = [];

while ($fila = oci_fetch_assoc($stmt)) {
    $usuarios[] = [
        'id'             => (int) $fila['ID_USUARIO'],
        'usuario'        => $fila['NOMBRE_USUARIO'],
        'correo'         => $fila['CORREO'],
        'estado'         => $fila['ESTADO'],
        'id_rol'         => (int) $fila['ID_ROL'],
        'rol'            => $fila['NOMBRE_ROL'],
    ];
}

oci_free_statement($stmt);
$db->disconnect();

responderJSON(true, 'Usuarios obtenidos.', $usuarios);
