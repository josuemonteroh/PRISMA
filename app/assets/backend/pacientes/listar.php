<?php

require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../common/middleware.php';
require_once __DIR__ . '/../common/response.php';
require_once __DIR__ . '/../helpers/DatabaseHelper.php';

requerirSesion();

$db   = new DatabaseHelper();
$conn = $db->getConnection();

$stmt   = oci_parse($conn, "BEGIN SP_LISTAR_PACIENTE(:cursor); END;");
$cursor = oci_new_cursor($conn);
oci_bind_by_name($stmt, ':cursor', $cursor, -1, OCI_B_CURSOR);
oci_execute($stmt);
oci_execute($cursor);

$pacientes = [];

while ($fila = oci_fetch_assoc($cursor)) {
    $pacientes[] = [
        'id'               => (int) $fila['ID_PACIENTE'],
        'nombre'           => $fila['NOMBRE'],
        'apellido'         => $fila['APELLIDO'],
        'fecha_nacimiento' => $fila['FECHA_NACIMIENTO'],
        'sexo'             => $fila['SEXO'],
        'telefono'         => $fila['TELEFONO'],
        'correo'           => $fila['CORREO'],
        'direccion'        => $fila['DIRECCION'],
        'cedula'           => $fila['CEDULA'],
    ];
}

oci_free_statement($cursor);
oci_free_statement($stmt);
$db->disconnect();

responderJSON(true, 'Pacientes obtenidos.', $pacientes);
