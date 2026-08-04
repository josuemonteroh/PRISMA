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

$id            = (int) ($entrada['id'] ?? 0);
$idHistorial   = (int) ($entrada['id_historial'] ?? 0);
$idMedico      = (int) ($entrada['id_medico'] ?? 0);
$idCita        = (int) ($entrada['id_cita'] ?? 0);
$fecha         = trim($entrada['fecha'] ?? '');
$observaciones = trim($entrada['observaciones'] ?? '');

if (
    $id <= 0 ||
    $idHistorial <= 0 ||
    $idMedico <= 0 ||
    $idCita <= 0 ||
    $fecha === ''
) {
    responderJSON(
        false,
        'Datos incompletos para actualizar la consulta.',
        null,
        400
    );
}

$db   = new DatabaseHelper();
$conn = $db->getConnection();

$stmt = oci_parse($conn, "
    BEGIN
        SP_ACTUALIZAR_CONSULTA(
            :id,
            :id_historial,
            :id_medico,
            :id_cita,
            TO_DATE(:fecha, 'YYYY-MM-DD'),
            :observaciones
        );
    END;
");

oci_bind_by_name($stmt, ':id', $id);
oci_bind_by_name($stmt, ':id_historial', $idHistorial);
oci_bind_by_name($stmt, ':id_medico', $idMedico);
oci_bind_by_name($stmt, ':id_cita', $idCita);
oci_bind_by_name($stmt, ':fecha', $fecha);
oci_bind_by_name($stmt, ':observaciones', $observaciones);

$exito = @oci_execute($stmt);

if (!$exito) {
    $error = oci_error($stmt);

    oci_free_statement($stmt);
    $db->disconnect();

    if (($error['code'] ?? null) == 1) {
        responderJSON(
            false,
            'La cita seleccionada ya está asociada a otra consulta.',
            null,
            409
        );
    }

    responderJSON(
        false,
        'Error al actualizar la consulta: ' . $error['message'],
        null,
        500
    );
}

oci_free_statement($stmt);
$db->disconnect();

responderJSON(true, 'Consulta actualizada correctamente.');