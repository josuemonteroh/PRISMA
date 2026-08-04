<?php

require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../common/middleware.php';
require_once __DIR__ . '/../common/response.php';
require_once __DIR__ . '/../helpers/DatabaseHelper.php';

$sesion = requerirSesion();
$id     = (int) $sesion['id_usuario'];

$db   = new DatabaseHelper();
$conn = $db->getConnection();

function buscarUsuarioActual($conn, int $id): ?array
{
    $stmt   = oci_parse($conn, "BEGIN SP_LISTAR_USUARIO(:cursor); END;");
    $cursor = oci_new_cursor($conn);
    oci_bind_by_name($stmt, ':cursor', $cursor, -1, OCI_B_CURSOR);
    oci_execute($stmt);
    oci_execute($cursor);

    $encontrado = null;
    while ($fila = oci_fetch_assoc($cursor)) {
        if ((int) $fila['ID_USUARIO'] === $id) {
            $encontrado = $fila;
            break;
        }
    }

    oci_free_statement($cursor);
    oci_free_statement($stmt);

    return $encontrado;
}

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $fila = buscarUsuarioActual($conn, $id);
    $db->disconnect();

    if (!$fila) {
        responderJSON(false, 'No se encontró el usuario de la sesión.', null, 404);
    }

    responderJSON(true, 'Perfil obtenido.', [
        'id'      => (int) $fila['ID_USUARIO'],
        'usuario' => $fila['NOMBRE_USUARIO'],
        'correo'  => $fila['CORREO'],
        'id_rol'  => (int) $fila['ID_ROL'],
        'estado'  => $fila['ESTADO'],
    ]);
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    responderJSON(false, 'Método no permitido.', null, 405);
}

$entrada = leerEntradaJSON();

$usuario    = trim($entrada['usuario']    ?? '');
$correo     = trim($entrada['correo']     ?? '');
$contrasena =        $entrada['contrasena'] ?? '';

if ($usuario === '' || $correo === '') {
    responderJSON(false, 'Usuario y correo son obligatorios.', null, 400);
}

$actual = buscarUsuarioActual($conn, $id);

if (!$actual) {
    $db->disconnect();
    responderJSON(false, 'No se encontró el usuario de la sesión.', null, 404);
}

$hash = $contrasena !== '' ? password_hash($contrasena, PASSWORD_DEFAULT) : $actual['CONTRASENA_HASH'];

$stmt = oci_parse($conn, "
    BEGIN
        SP_ACTUALIZAR_USUARIO(:id, :id_rol, :usuario, :hash, :correo, :estado);
    END;
");
oci_bind_by_name($stmt, ':id', $id);
oci_bind_by_name($stmt, ':id_rol', $actual['ID_ROL']);
oci_bind_by_name($stmt, ':usuario', $usuario);
oci_bind_by_name($stmt, ':hash', $hash);
oci_bind_by_name($stmt, ':correo', $correo);
oci_bind_by_name($stmt, ':estado', $actual['ESTADO']);

$exito = @oci_execute($stmt);

if (!$exito) {
    $error = oci_error($stmt);
    oci_free_statement($stmt);
    $db->disconnect();

    if (($error['code'] ?? null) == 1) {
        responderJSON(false, 'Ya existe un usuario con ese nombre o correo.', null, 409);
    }

    responderJSON(false, 'Error al actualizar el perfil: ' . $error['message'], null, 500);
}

oci_free_statement($stmt);
$db->disconnect();

responderJSON(true, 'Perfil actualizado correctamente.');
