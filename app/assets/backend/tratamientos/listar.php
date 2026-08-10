<?php

require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../common/middleware.php';
require_once __DIR__ . '/../common/response.php';
require_once __DIR__ . '/../helpers/DatabaseHelper.php';

requerirSesion();

$db   = new DatabaseHelper();
$conn = $db->getConnection();

$stmt   = oci_parse($conn, "BEGIN SP_LISTAR_TRATAMIENTO(:cursor); END;");
$cursor = oci_new_cursor($conn);

oci_bind_by_name($stmt, ':cursor', $cursor, -1, OCI_B_CURSOR);

oci_execute($stmt);
oci_execute($cursor);

$tratamientos = [];

while ($fila = oci_fetch_assoc($cursor)) {

    $tratamientos[] = [
        'id'             => (int) $fila['ID_TRATAMIENTO'],
        'id_consulta'    => (int) $fila['ID_CONSULTA'],
        'id_medicamento' => (int) $fila['ID_MEDICAMENTO'],

        'consulta'       => $fila['CONSULTA'],
        'medicamento'    => $fila['MEDICAMENTO'],

        'dosis'          => $fila['DOSIS'],
        'frecuencia'     => $fila['FRECUENCIA'],
        'duracion_dias'  => (int) $fila['DURACION_DIAS'],
        'fecha_inicio'   => $fila['FECHA_INICIO'],
    ];
}

oci_free_statement($cursor);
oci_free_statement($stmt);

$db->disconnect();

responderJSON(
    true,
    'Tratamientos obtenidos.',
    $tratamientos
);