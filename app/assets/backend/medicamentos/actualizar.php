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

$id            = (int) ($entrada['id'] ?? 0);
$nombre        = trim($entrada['nombre']        ?? '');
$descripcion   = trim($entrada['descripcion']   ?? '');
$presentacion  = trim($entrada['presentacion']  ?? '');
$concentracion = trim($entrada['concentracion'] ?? '');

if ($id <= 0 || $nombre === '') {
    responderJSON(false, 'Datos incompletos para actualizar el medicamento.', null, 400);
}

$db   = new DatabaseHelper();
$conn = $db->getConnection();

$stmt = oci_parse($conn, "
    BEGIN
        SP_ACTUALIZAR_MEDICAMENTO(:id, :nombre, :descripcion, :presentacion, :concentracion);
    END;
");
oci_bind_by_name($stmt, ':id', $id);
oci_bind_by_name($stmt, ':nombre', $nombre);
oci_bind_by_name($stmt, ':descripcion', $descripcion);
oci_bind_by_name($stmt, ':presentacion', $presentacion);
oci_bind_by_name($stmt, ':concentracion', $concentracion);

$exito = @oci_execute($stmt);

if (!$exito) {
    $error = oci_error($stmt);
    oci_free_statement($stmt);
    $db->disconnect();

    if (($error['code'] ?? null) == 1) {
        responderJSON(false, 'Ya existe un medicamento con ese nombre.', null, 409);
    }

    responderJSON(false, 'Error al actualizar el medicamento: ' . $error['message'], null, 500);
}

oci_free_statement($stmt);
$db->disconnect();

responderJSON(true, 'Medicamento actualizado correctamente.');
