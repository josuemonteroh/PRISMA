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
        ID_PACIENTE,
        NOMBRE,
        APELLIDO,
        TO_CHAR(FECHA_NACIMIENTO, 'YYYY-MM-DD') AS FECHA_NACIMIENTO,
        SEXO,
        TELEFONO,
        CORREO,
        DIRECCION,
        CEDULA
    FROM PACIENTE
    ORDER BY ID_PACIENTE DESC
";

$stmt = oci_parse($conn, $sql);
oci_execute($stmt);

$pacientes = [];

while ($fila = oci_fetch_assoc($stmt)) {
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

oci_free_statement($stmt);
$db->disconnect();

responderJSON(true, 'Pacientes obtenidos.', $pacientes);
