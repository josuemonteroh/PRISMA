<?php

require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../common/middleware.php';
require_once __DIR__ . '/../common/response.php';
require_once __DIR__ . '/../helpers/DatabaseHelper.php';

requerirSesion();

$db   = new DatabaseHelper();
$conn = $db->getConnection();

$stmt   = oci_parse($conn, "BEGIN SP_LISTAR_DOCTOR(:cursor); END;");
$cursor = oci_new_cursor($conn);
oci_bind_by_name($stmt, ':cursor', $cursor, -1, OCI_B_CURSOR);
oci_execute($stmt);
oci_execute($cursor);

$medicos = [];

while ($fila = oci_fetch_assoc($cursor)) {
    $medicos[] = [
        'id'                  => (int) $fila['ID_MEDICO'],
        'nombre'              => $fila['NOMBRE'],
        'apellido'            => $fila['APELLIDO'],
        'telefono'            => $fila['TELEFONO'],
        'correo'              => $fila['CORREO'],
        'numero_colegiatura'  => $fila['NUMERO_COLEGIATURA'],
        'id_especialidad'     => (int) $fila['ID_ESPECIALIDAD'],
    ];
}

oci_free_statement($cursor);
oci_free_statement($stmt);
$db->disconnect();

responderJSON(true, 'Médicos obtenidos.', $medicos);
