<?php

require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../common/middleware.php';
require_once __DIR__ . '/../common/response.php';
require_once __DIR__ . '/../helpers/DatabaseHelper.php';

requerirSesion();

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    responderJSON(false, 'Método no permitido.', null, 405);
}

$entrada = leerEntradaJSON();

$nombre        = trim($entrada['nombre']        ?? '');
$descripcion   = trim($entrada['descripcion']   ?? '');
$presentacion  = trim($entrada['presentacion']  ?? '');
$concentracion = trim($entrada['concentracion'] ?? '');

if ($nombre === '') {
    responderJSON(false, 'El nombre del medicamento es obligatorio.', null, 400);
}

$db   = new DatabaseHelper();
$conn = $db->getConnection();

$sql = "
    INSERT INTO MEDICAMENTO
        (NOMBRE, DESCRIPCION, PRESENTACION, CONCENTRACION)
    VALUES
        (:nombre, :descripcion, :presentacion, :concentracion)
    RETURNING ID_MEDICAMENTO INTO :id_medicamento
";

$stmt = oci_parse($conn, $sql);
oci_bind_by_name($stmt, ':nombre', $nombre);
oci_bind_by_name($stmt, ':descripcion', $descripcion);
oci_bind_by_name($stmt, ':presentacion', $presentacion);
oci_bind_by_name($stmt, ':concentracion', $concentracion);
oci_bind_by_name($stmt, ':id_medicamento', $idNuevo, -1, SQLT_INT);

$exito = @oci_execute($stmt);

if (!$exito) {
    $error = oci_error($stmt);
    oci_free_statement($stmt);
    $db->disconnect();

    if (($error['code'] ?? null) == 1) {
        responderJSON(false, 'Ya existe un medicamento con ese nombre.', null, 409);
    }

    responderJSON(false, 'Error al guardar el medicamento: ' . $error['message'], null, 500);
}

oci_free_statement($stmt);
$db->disconnect();

responderJSON(true, 'Medicamento registrado correctamente.', ['id' => (int) $idNuevo]);
