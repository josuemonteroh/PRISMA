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
        D.ID_MEDICO,
        D.NOMBRE,
        D.APELLIDO,
        D.TELEFONO,
        D.CORREO,
        D.NUMERO_COLEGIATURA,
        D.ID_ESPECIALIDAD,
        E.NOMBRE_ESPECIALIDAD
    FROM DOCTOR D
    JOIN ESPECIALIDAD E ON E.ID_ESPECIALIDAD = D.ID_ESPECIALIDAD
    ORDER BY D.ID_MEDICO DESC
";

$stmt = oci_parse($conn, $sql);
oci_execute($stmt);

$medicos = [];

while ($fila = oci_fetch_assoc($stmt)) {
    $medicos[] = [
        'id'                  => (int) $fila['ID_MEDICO'],
        'nombre'              => $fila['NOMBRE'],
        'apellido'            => $fila['APELLIDO'],
        'telefono'            => $fila['TELEFONO'],
        'correo'              => $fila['CORREO'],
        'numero_colegiatura'  => $fila['NUMERO_COLEGIATURA'],
        'id_especialidad'     => (int) $fila['ID_ESPECIALIDAD'],
        'especialidad'        => $fila['NOMBRE_ESPECIALIDAD'],
    ];
}

oci_free_statement($stmt);
$db->disconnect();

responderJSON(true, 'Médicos obtenidos.', $medicos);
