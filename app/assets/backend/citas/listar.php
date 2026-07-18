<?php

require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../common/middleware.php';
require_once __DIR__ . '/../common/response.php';
require_once __DIR__ . '/../helpers/DatabaseHelper.php';

requerirSesion();

$db   = new DatabaseHelper();
$conn = $db->getConnection();

$sql = "
    SELECT
        C.ID_CITA,
        C.ID_PACIENTE,
        C.ID_MEDICO,
        C.ID_CONSULTORIO,
        TO_CHAR(C.FECHA, 'YYYY-MM-DD') AS FECHA,
        C.HORA,
        C.ESTADO,
        C.MOTIVO,
        P.NOMBRE || ' ' || P.APELLIDO AS PACIENTE,
        D.NOMBRE || ' ' || D.APELLIDO AS MEDICO,
        CO.NOMBRE AS CONSULTORIO
    FROM CITA C
    JOIN PACIENTE P    ON P.ID_PACIENTE = C.ID_PACIENTE
    JOIN DOCTOR D      ON D.ID_MEDICO = C.ID_MEDICO
    JOIN CONSULTORIO CO ON CO.ID_CONSULTORIO = C.ID_CONSULTORIO
    ORDER BY C.ID_CITA DESC
";

$stmt = oci_parse($conn, $sql);
oci_execute($stmt);

$citas = [];

while ($fila = oci_fetch_assoc($stmt)) {
    $citas[] = [
        'id'              => (int) $fila['ID_CITA'],
        'id_paciente'     => (int) $fila['ID_PACIENTE'],
        'id_medico'       => (int) $fila['ID_MEDICO'],
        'id_consultorio'  => (int) $fila['ID_CONSULTORIO'],
        'fecha'           => $fila['FECHA'],
        'hora'            => $fila['HORA'],
        'estado'          => $fila['ESTADO'],
        'motivo'          => $fila['MOTIVO'],
        'paciente'        => $fila['PACIENTE'],
        'medico'          => $fila['MEDICO'],
        'consultorio'     => $fila['CONSULTORIO'],
    ];
}

oci_free_statement($stmt);
$db->disconnect();

responderJSON(true, 'Citas obtenidas.', $citas);
