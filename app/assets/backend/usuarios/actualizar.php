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
} else {
    $stmtBuscar = oci_parse($conn, "BEGIN SP_LISTAR_USUARIO(:cursor); END;");
    $cursorBuscar = oci_new_cursor($conn);
    oci_bind_by_name($stmtBuscar, ':cursor', $cursorBuscar, -1, OCI_B_CURSOR);
    oci_execute($stmtBuscar);
    oci_execute($cursorBuscar);

    $hash = null;
    while ($fila = oci_fetch_assoc($cursorBuscar)) {
        if ((int) $fila['ID_USUARIO'] === $id) {
            $hash = $fila['CONTRASENA_HASH'];
            break;
        }
    }

    oci_free_statement($cursorBuscar);
    oci_free_statement($stmtBuscar);

    if ($hash === null) {
        $db->disconnect();
        responderJSON(false, 'No se encontró el usuario indicado.', null, 404);
    }
}

$stmt = oci_parse($conn, "
    BEGIN
        SP_ACTUALIZAR_USUARIO(:id, :id_rol, :usuario, :hash, :correo, :estado);
    END;
");
oci_bind_by_name($stmt, ':id', $id);
oci_bind_by_name($stmt, ':id_rol', $idRol);
oci_bind_by_name($stmt, ':usuario', $usuario);
oci_bind_by_name($stmt, ':hash', $hash);
oci_bind_by_name($stmt, ':correo', $correo);
oci_bind_by_name($stmt, ':estado', $estado);

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

oci_free_statement($stmt);
$db->disconnect();

responderJSON(true, 'Usuario actualizado correctamente.');
