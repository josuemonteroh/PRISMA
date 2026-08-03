<?php

require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../common/middleware.php';
require_once __DIR__ . '/../common/response.php';
require_once __DIR__ . '/../helpers/DatabaseHelper.php';

requerirSesion();

$db   = new DatabaseHelper();
$conn = $db->getConnection();

$stmt   = oci_parse($conn, "BEGIN SP_LISTAR_MEDICAMENTO(:cursor); END;");
$cursor = oci_new_cursor($conn);
oci_bind_by_name($stmt, ':cursor', $cursor, -1, OCI_B_CURSOR);
oci_execute($stmt);
oci_execute($cursor);

$medicamentos = [];

while ($fila = oci_fetch_assoc($cursor)) {
    $medicamentos[] = [
        'id'            => (int) $fila['ID_MEDICAMENTO'],
        'nombre'        => $fila['NOMBRE'],
        'descripcion'   => $fila['DESCRIPCION'],
        'presentacion'  => $fila['PRESENTACION'],
        'concentracion' => $fila['CONCENTRACION'],
    ];
}

oci_free_statement($cursor);
oci_free_statement($stmt);
$db->disconnect();

responderJSON(true, 'Medicamentos obtenidos.', $medicamentos);
