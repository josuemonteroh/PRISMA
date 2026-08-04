<?php

require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../common/middleware.php';
require_once __DIR__ . '/../common/response.php';
require_once __DIR__ . '/../helpers/DatabaseHelper.php';

requerirSesion();

$db   = new DatabaseHelper();
$conn = $db->getConnection();

$stmt   = oci_parse($conn, "BEGIN SP_LISTAR_CONSULTA(:cursor); END;");
$cursor = oci_new_cursor($conn);

oci_bind_by_name($stmt, ':cursor', $cursor, -1, OCI_B_CURSOR);

oci_execute($stmt);
oci_execute($cursor);

$consultas = [];

while ($fila = oci_fetch_assoc($cursor)) {
    $consultas[] = [
        'id'            => (int) $fila['ID_CONSULTA'],

        // IDs necesarios para editar
        'id_historial'  => (int) $fila['ID_HISTORIAL'],
        'id_medico'     => (int) $fila['ID_MEDICO'],
        'id_cita'       => (int) $fila['ID_CITA'],

        // Datos visibles
        'paciente'      => $fila['PACIENTE'],
        'medico'        => $fila['MEDICO'],
        'cita'          => $fila['CITA'],

        'fecha'         => $fila['FECHA'],
        'observaciones' => $fila['OBSERVACIONES'],
    ];
}

oci_free_statement($cursor);
oci_free_statement($stmt);

$db->disconnect();

responderJSON(true, 'Consultas obtenidas.', $consultas);