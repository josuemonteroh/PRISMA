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

$id         = (int) ($entrada['id'] ?? 0);
$usuario    = trim($entrada['usuario']    ?? '');
$correo     = trim($entrada['correo']     ?? '');
$contrasena =        $entrada['contrasena'] ?? '';
$idRol      = (int) ($entrada['id_rol']   ?? 0);
$estado     = trim($entrada['estado']     ?? 'ACTIVO');

if ($id <= 0 || $usuario === '' || $correo === '' || $idRol <= 0) {
    responderJSON(false, 'Datos incompletos para actualizar el usuario.', null, 400);
}

$db   = new DatabaseHelper();
$conn = $db->getConnection();

if ($contrasena !== '') {
    $hash = password_hash($contrasena, PASSWORD_DEFAULT);
    $sql = "
        UPDATE USUARIO
        SET ID_ROL = :id_rol, NOMBRE_USUARIO = :usuario, CORREO = :correo, ESTADO = :estado, CONTRASENA_HASH = :hash
        WHERE ID_USUARIO = :id
    ";
} else {
    $sql = "
        UPDATE USUARIO
        SET ID_ROL = :id_rol, NOMBRE_USUARIO = :usuario, CORREO = :correo, ESTADO = :estado
        WHERE ID_USUARIO = :id
    ";
}

$stmt = oci_parse($conn, $sql);
oci_bind_by_name($stmt, ':id_rol', $idRol);
oci_bind_by_name($stmt, ':usuario', $usuario);
oci_bind_by_name($stmt, ':correo', $correo);
oci_bind_by_name($stmt, ':estado', $estado);
if ($contrasena !== '') {
    oci_bind_by_name($stmt, ':hash', $hash);
}
oci_bind_by_name($stmt, ':id', $id);

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

    responderJSON(false, 'Error al actualizar el usuario: ' . $error['message'], null, 500);
}

$filasAfectadas = oci_num_rows($stmt);

oci_free_statement($stmt);
$db->disconnect();

if ($filasAfectadas === 0) {
    responderJSON(false, 'No se encontró el usuario indicado.', null, 404);
}

responderJSON(true, 'Usuario actualizado correctamente.');
