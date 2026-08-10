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

$idConsulta    = (int) ($entrada['id_consulta'] ?? 0);
$idMedicamento = (int) ($entrada['id_medicamento'] ?? 0);
$dosis         = trim($entrada['dosis'] ?? '');
$frecuencia    = trim($entrada['frecuencia'] ?? '');
$duracionDias  = (int) ($entrada['duracion_dias'] ?? 0);
$fechaInicio   = trim($entrada['fecha_inicio'] ?? '');

if (
    $idConsulta <= 0 ||
    $idMedicamento <= 0 ||
    $dosis === '' ||
    $frecuencia === '' ||
    $duracionDias <= 0 ||
    $fechaInicio === ''
) {
    responderJSON(
        false,
        'Consulta, medicamento, dosis, frecuencia, duración y fecha de inicio son obligatorios.',
        null,
        400
    );
}

$db   = new DatabaseHelper();
$conn = $db->getConnection();

$stmt = oci_parse($conn, "
    BEGIN
        SP_INSERTAR_TRATAMIENTO(
            :id_consulta,
            :id_medicamento,
            :dosis,
            :frecuencia,
            :duracion_dias,
            TO_DATE(:fecha_inicio, 'YYYY-MM-DD')
        );
    END;
");

oci_bind_by_name($stmt, ':id_consulta', $idConsulta);
oci_bind_by_name($stmt, ':id_medicamento', $idMedicamento);
oci_bind_by_name($stmt, ':dosis', $dosis);
oci_bind_by_name($stmt, ':frecuencia', $frecuencia);
oci_bind_by_name($stmt, ':duracion_dias', $duracionDias);
oci_bind_by_name($stmt, ':fecha_inicio', $fechaInicio);

$exito = @oci_execute($stmt);

if (!$exito) {
    $error = oci_error($stmt);

    oci_free_statement($stmt);
    $db->disconnect();

    responderJSON(
        false,
        'Error al guardar el tratamiento: ' . $error['message'],
        null,
        500
    );
}

oci_free_statement($stmt);
$db->disconnect();

responderJSON(true, 'Tratamiento registrado correctamente.');