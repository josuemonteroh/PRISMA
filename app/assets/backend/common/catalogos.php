<?php

require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/middleware.php';
require_once __DIR__ . '/response.php';
require_once __DIR__ . '/../helpers/DatabaseHelper.php';

requerirSesion();

$tipo = $_GET['tipo'] ?? '';

$procedimientos = [
    'especialidades' => 'SP_LISTAR_ESPECIALIDAD',
    'roles'          => 'SP_LISTAR_ROL',
    'consultorios'   => 'SP_LISTAR_CONSULTORIO',
    'pacientes'      => 'SP_LISTAR_PACIENTE',
    'medicos'        => 'SP_LISTAR_DOCTOR',
];

if (!isset($procedimientos[$tipo])) {
    responderJSON(false, 'Catálogo no válido.', null, 400);
}

$db   = new DatabaseHelper();
$conn = $db->getConnection();

$stmt   = oci_parse($conn, "BEGIN {$procedimientos[$tipo]}(:cursor); END;");
$cursor = oci_new_cursor($conn);
oci_bind_by_name($stmt, ':cursor', $cursor, -1, OCI_B_CURSOR);
oci_execute($stmt);
oci_execute($cursor);

$columnasId = [
    'especialidades' => 'ID_ESPECIALIDAD',
    'roles'          => 'ID_ROL',
    'consultorios'   => 'ID_CONSULTORIO',
    'pacientes'      => 'ID_PACIENTE',
    'medicos'        => 'ID_MEDICO',
];

$idColumna = $columnasId[$tipo];

$filas = [];
while ($fila = oci_fetch_assoc($cursor)) {
    switch ($tipo) {
        case 'especialidades':
            $nombre = $fila['NOMBRE_ESPECIALIDAD'];
            break;
        case 'roles':
            $nombre = $fila['NOMBRE_ROL'];
            break;
        case 'pacientes':
            $nombre = $fila['NOMBRE'] . ' ' . $fila['APELLIDO'];
            break;
        case 'medicos':
            $nombre = 'Dr(a). ' . $fila['NOMBRE'] . ' ' . $fila['APELLIDO'];
            break;
        default:
            $nombre = $fila['NOMBRE'];
    }

    $filas[] = [
        'id'     => (int) $fila[$idColumna],
        'nombre' => $nombre,
    ];
}

usort($filas, fn ($a, $b) => strcmp($a['nombre'], $b['nombre']));

oci_free_statement($cursor);
oci_free_statement($stmt);
$db->disconnect();

responderJSON(true, 'Catálogo obtenido.', $filas);
