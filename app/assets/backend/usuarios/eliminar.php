<?php

require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../common/middleware.php';
require_once __DIR__ . '/../common/response.php';
require_once __DIR__ . '/../helpers/DatabaseHelper.php';

$sesion = requerirSesion();

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    responderJSON(false, 'Método no permitido.', null, 405);
}

$entrada = leerEntradaJSON();
$id      = (int) ($entrada['id'] ?? 0);

if ($id <= 0) {
    responderJSON(false, 'Debe indicar el usuario a eliminar.', null, 400);
}

if ($id === (int) $sesion['id_usuario']) {
    responderJSON(false, 'No puede eliminar su propio usuario mientras está en sesión.', null, 400);
}

$db   = new DatabaseHelper();
$conn = $db->getConnection();

$sql  = "DELETE FROM USUARIO WHERE ID_USUARIO = :id";
$stmt = oci_parse($conn, $sql);
oci_bind_by_name($stmt, ':id', $id);

$exito = @oci_execute($stmt);

if (!$exito) {
    $error = oci_error($stmt);
    oci_free_statement($stmt);
    $db->disconnect();

    if (($error['code'] ?? null) == 2292) {
        responderJSON(false, 'No se puede eliminar: el usuario tiene registros de auditoría asociados.', null, 409);
    }

    responderJSON(false, 'Error al eliminar el usuario: ' . $error['message'], null, 500);
}

$filasAfectadas = oci_num_rows($stmt);

oci_free_statement($stmt);
$db->disconnect();

if ($filasAfectadas === 0) {
    responderJSON(false, 'No se encontró el usuario indicado.', null, 404);
}

responderJSON(true, 'Usuario eliminado correctamente.');
