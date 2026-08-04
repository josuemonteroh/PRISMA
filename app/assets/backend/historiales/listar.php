<?php

require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../common/middleware.php';
require_once __DIR__ . '/../common/response.php';
require_once __DIR__ . '/../helpers/DatabaseHelper.php';

requerirSesion();

$db   = new DatabaseHelper();
$conn = $db->getConnection();

$stmt   = oci_parse($conn, "BEGIN SP_LISTAR_HISTORIAL(:cursor); END;");
$cursor = oci_new_cursor($conn);

oci_bind_by_name($stmt, ':cursor', $cursor, -1, OCI_B_CURSOR);

oci_execute($stmt);
oci_execute($cursor);

$historiales = [];

while ($fila = oci_fetch_assoc($cursor)) {
    $historiales[] = [
        'id'          => (int) $fila['ID_HISTORIAL'],
        'id_paciente' => (int) $fila['ID_PACIENTE'],
    ];
}

oci_free_statement($cursor);
oci_free_statement($stmt);

$db->disconnect();

responderJSON(true, 'Historiales obtenidos.', $historiales);