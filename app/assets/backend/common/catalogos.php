<?php

require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/middleware.php';
require_once __DIR__ . '/response.php';
require_once __DIR__ . '/../helpers/DatabaseHelper.php';

requerirSesion();

$tipo = $_GET['tipo'] ?? '';

$consultas = [
    'especialidades' => 'SELECT ID_ESPECIALIDAD AS ID, NOMBRE_ESPECIALIDAD AS NOMBRE FROM ESPECIALIDAD ORDER BY NOMBRE_ESPECIALIDAD',
    'roles'          => 'SELECT ID_ROL AS ID, NOMBRE_ROL AS NOMBRE FROM ROL ORDER BY NOMBRE_ROL',
    'consultorios'   => 'SELECT ID_CONSULTORIO AS ID, NOMBRE AS NOMBRE FROM CONSULTORIO ORDER BY NOMBRE',
    'pacientes'      => "SELECT ID_PACIENTE AS ID, NOMBRE || ' ' || APELLIDO AS NOMBRE FROM PACIENTE ORDER BY NOMBRE",
    'medicos'        => "SELECT ID_MEDICO AS ID, 'Dr(a). ' || NOMBRE || ' ' || APELLIDO AS NOMBRE FROM DOCTOR ORDER BY NOMBRE",
];

if (!isset($consultas[$tipo])) {
    responderJSON(false, 'Catálogo no válido.', null, 400);
}

$db   = new DatabaseHelper();
$conn = $db->getConnection();

$stmt = oci_parse($conn, $consultas[$tipo]);
oci_execute($stmt);

$filas = [];
while ($fila = oci_fetch_assoc($stmt)) {
    $filas[] = [
        'id'     => (int) $fila['ID'],
        'nombre' => $fila['NOMBRE'],
    ];
}

oci_free_statement($stmt);
$db->disconnect();

responderJSON(true, 'Catálogo obtenido.', $filas);
