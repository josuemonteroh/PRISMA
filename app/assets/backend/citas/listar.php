<?php

require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../common/middleware.php';
require_once __DIR__ . '/../common/response.php';
require_once __DIR__ . '/../helpers/DatabaseHelper.php';

requerirSesion();

$db   = new DatabaseHelper();
$conn = $db->getConnection();

$stmt   = oci_parse($conn, "BEGIN SP_LISTAR_CITA(:cursor); END;");
$cursor = oci_new_cursor($conn);
oci_bind_by_name($stmt, ':cursor', $cursor, -1, OCI_B_CURSOR);
oci_execute($stmt);
oci_execute($cursor);

$citas = [];

while ($fila = oci_fetch_assoc($cursor)) {
    $citas[] = [
        'id'              => (int) $fila['ID_CITA'],
        'id_paciente'     => (int) $fila['ID_PACIENTE'],
        'id_medico'       => (int) $fila['ID_MEDICO'],
        'id_consultorio'  => (int) $fila['ID_CONSULTORIO'],
        'fecha'           => $fila['FECHA'],
        'hora'            => $fila['HORA'],
        'estado'          => $fila['ESTADO'],
        'motivo'          => $fila['MOTIVO'],
    ];
}

oci_free_statement($cursor);
oci_free_statement($stmt);
$db->disconnect();

responderJSON(true, 'Citas obtenidas.', $citas);
