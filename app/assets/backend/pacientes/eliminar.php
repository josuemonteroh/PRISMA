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

$stmt = oci_parse($conn, "BEGIN SP_ELIMINAR_PACIENTE(:id); END;");
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

oci_free_statement($stmt);
$db->disconnect();

responderJSON(true, 'Paciente eliminado correctamente.');
