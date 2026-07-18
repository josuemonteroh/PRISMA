<?php

require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../common/middleware.php';
require_once __DIR__ . '/../common/response.php';
require_once __DIR__ . '/../helpers/DatabaseHelper.php';

requerirSesion();

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    responderJSON(false, 'Método no permitido.', null, 405);
}

$entrada = leerEntradaJSON();

$usuario    = trim($entrada['usuario']    ?? '');
$correo     = trim($entrada['correo']     ?? '');
$contrasena =        $entrada['contrasena'] ?? '';
$idRol      = (int) ($entrada['id_rol']   ?? 0);
$estado     = trim($entrada['estado']     ?? 'ACTIVO');

if ($usuario === '' || $correo === '' || $contrasena === '' || $idRol <= 0) {
    responderJSON(false, 'Usuario, correo, contraseña y rol son obligatorios.', null, 400);
}

$hash = password_hash($contrasena, PASSWORD_DEFAULT);

$db   = new DatabaseHelper();
$conn = $db->getConnection();

$sql = "
    INSERT INTO USUARIO
        (ID_ROL, NOMBRE_USUARIO, CONTRASENA_HASH, CORREO, ESTADO)
    VALUES
        (:id_rol, :usuario, :hash, :correo, :estado)
    RETURNING ID_USUARIO INTO :id_usuario
";

$stmt = oci_parse($conn, $sql);
oci_bind_by_name($stmt, ':id_rol', $idRol);
oci_bind_by_name($stmt, ':usuario', $usuario);
oci_bind_by_name($stmt, ':hash', $hash);
oci_bind_by_name($stmt, ':correo', $correo);
oci_bind_by_name($stmt, ':estado', $estado);
oci_bind_by_name($stmt, ':id_usuario', $idNuevo, -1, SQLT_INT);

$exito = @oci_execute($stmt);

if (!$exito) {
    $error = oci_error($stmt);
    oci_free_statement($stmt);
    $db->disconnect();

    if (($error['code'] ?? null) == 1) {
        responderJSON(false, 'Ya existe un usuario con ese nombre o correo.', null, 409);
    }
    if (($error['code'] ?? null) == 2291) {
        responderJSON(false, 'El rol seleccionado no es válido.', null, 400);
    }

    responderJSON(false, 'Error al guardar el usuario: ' . $error['message'], null, 500);
}

oci_free_statement($stmt);
$db->disconnect();

responderJSON(true, 'Usuario registrado correctamente.', ['id' => (int) $idNuevo]);
