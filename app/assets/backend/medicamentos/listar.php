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
        ID_MEDICAMENTO,
        NOMBRE,
        DESCRIPCION,
        PRESENTACION,
        CONCENTRACION
    FROM MEDICAMENTO
    ORDER BY ID_MEDICAMENTO DESC
";

$stmt = oci_parse($conn, $sql);
oci_execute($stmt);

$medicamentos = [];

while ($fila = oci_fetch_assoc($stmt)) {
    $medicamentos[] = [
        'id'            => (int) $fila['ID_MEDICAMENTO'],
        'nombre'        => $fila['NOMBRE'],
        'descripcion'   => $fila['DESCRIPCION'],
        'presentacion'  => $fila['PRESENTACION'],
        'concentracion' => $fila['CONCENTRACION'],
    ];
}

oci_free_statement($stmt);
$db->disconnect();

responderJSON(true, 'Medicamentos obtenidos.', $medicamentos);
