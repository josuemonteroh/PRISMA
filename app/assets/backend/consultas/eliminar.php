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

$id = (int) ($entrada['id'] ?? 0);

if ($id <= 0) {
    responderJSON(false, 'El ID de la consulta es obligatorio.', null, 400);
}

$db   = new DatabaseHelper();
$conn = $db->getConnection();

$stmt = oci_parse($conn, "
    BEGIN
        SP_ELIMINAR_CONSULTA(:id);
    END;
");

oci_bind_by_name($stmt, ':id', $id);

$exito = @oci_execute($stmt);

if (!$exito) {
    $error = oci_error($stmt);

    oci_free_statement($stmt);
    $db->disconnect();

    responderJSON(
        false,
        'Error al eliminar la consulta: ' . $error['message'],
        null,
        500
    );
}

oci_free_statement($stmt);
$db->disconnect();

responderJSON(true, 'Consulta eliminada correctamente.');