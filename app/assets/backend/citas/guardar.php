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

$idPaciente    = (int) ($entrada['id_paciente']    ?? 0);
$idMedico      = (int) ($entrada['id_medico']      ?? 0);
$idConsultorio = (int) ($entrada['id_consultorio'] ?? 0);
$fecha         = trim($entrada['fecha'] ?? '');
$hora          = trim($entrada['hora']  ?? '');
$estado        = trim($entrada['estado'] ?? 'PROGRAMADA');
$motivo        = trim($entrada['motivo'] ?? '');

if ($idPaciente <= 0 || $idMedico <= 0 || $idConsultorio <= 0 || $fecha === '' || $hora === '') {
    responderJSON(false, 'Paciente, médico, consultorio, fecha y hora son obligatorios.', null, 400);
}

$db   = new DatabaseHelper();
$conn = $db->getConnection();

$sql = "
    INSERT INTO CITA
        (ID_PACIENTE, ID_MEDICO, ID_CONSULTORIO, FECHA, HORA, ESTADO, MOTIVO)
    VALUES
        (:id_paciente, :id_medico, :id_consultorio, TO_DATE(:fecha, 'YYYY-MM-DD'), :hora, :estado, :motivo)
    RETURNING ID_CITA INTO :id_cita
";

$stmt = oci_parse($conn, $sql);
oci_bind_by_name($stmt, ':id_paciente', $idPaciente);
oci_bind_by_name($stmt, ':id_medico', $idMedico);
oci_bind_by_name($stmt, ':id_consultorio', $idConsultorio);
oci_bind_by_name($stmt, ':fecha', $fecha);
oci_bind_by_name($stmt, ':hora', $hora);
oci_bind_by_name($stmt, ':estado', $estado);
oci_bind_by_name($stmt, ':motivo', $motivo);
oci_bind_by_name($stmt, ':id_cita', $idNuevo, -1, SQLT_INT);

$exito = @oci_execute($stmt);

if (!$exito) {
    $error = oci_error($stmt);
    oci_free_statement($stmt);
    $db->disconnect();

    if (($error['code'] ?? null) == 2291) {
        responderJSON(false, 'Paciente, médico o consultorio no válidos.', null, 400);
    }
    if (($error['code'] ?? null) == 2290) {
        responderJSON(false, 'El estado indicado no es válido.', null, 400);
    }

    responderJSON(false, 'Error al guardar la cita: ' . $error['message'], null, 500);
}

oci_free_statement($stmt);
$db->disconnect();

responderJSON(true, 'Cita registrada correctamente.', ['id' => (int) $idNuevo]);
