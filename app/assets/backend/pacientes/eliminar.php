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
$id      = (int) ($entrada['id'] ?? 0);

if ($id <= 0) {
    responderJSON(false, 'Debe indicar el paciente a eliminar.', null, 400);
}

$db   = new DatabaseHelper();
$conn = $db->getConnection();

$sql  = "DELETE FROM PACIENTE WHERE ID_PACIENTE = :id";
$stmt = oci_parse($conn, $sql);
oci_bind_by_name($stmt, ':id', $id);

$exito = @oci_execute($stmt);

if (!$exito) {
    $error = oci_error($stmt);
    oci_free_statement($stmt);
    $db->disconnect();

    if (($error['code'] ?? null) == 2292) {
        responderJSON(false, 'No se puede eliminar: el paciente tiene registros relacionados (historial, citas, etc.).', null, 409);
    }

    responderJSON(false, 'Error al eliminar el paciente: ' . $error['message'], null, 500);
}

$filasAfectadas = oci_num_rows($stmt);

oci_free_statement($stmt);
$db->disconnect();

if ($filasAfectadas === 0) {
    responderJSON(false, 'No se encontró el paciente indicado.', null, 404);
}

responderJSON(true, 'Paciente eliminado correctamente.');
