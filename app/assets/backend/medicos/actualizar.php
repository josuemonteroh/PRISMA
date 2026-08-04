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

$id             = (int) ($entrada['id'] ?? 0);
$idEspecialidad = (int) ($entrada['id_especialidad'] ?? 0);
$nombre         = trim($entrada['nombre']   ?? '');
$apellido       = trim($entrada['apellido'] ?? '');
$telefono       = trim($entrada['telefono'] ?? '');
$correo         = trim($entrada['correo']   ?? '');
$colegiatura    = trim($entrada['numero_colegiatura'] ?? '');

if ($id <= 0 || $idEspecialidad <= 0 || $nombre === '' || $apellido === '' || $colegiatura === '') {
    responderJSON(false, 'Datos incompletos para actualizar el médico.', null, 400);
}

$db   = new DatabaseHelper();
$conn = $db->getConnection();

$stmt = oci_parse($conn, "
    BEGIN
        SP_ACTUALIZAR_DOCTOR(:id, :id_especialidad, :nombre, :apellido, :telefono, :correo, :colegiatura);
    END;
");
oci_bind_by_name($stmt, ':id', $id);
oci_bind_by_name($stmt, ':id_especialidad', $idEspecialidad);
oci_bind_by_name($stmt, ':nombre', $nombre);
oci_bind_by_name($stmt, ':apellido', $apellido);
oci_bind_by_name($stmt, ':telefono', $telefono);
oci_bind_by_name($stmt, ':correo', $correo);
oci_bind_by_name($stmt, ':colegiatura', $colegiatura);

$exito = @oci_execute($stmt);

if (!$exito) {
    $error = oci_error($stmt);
    oci_free_statement($stmt);
    $db->disconnect();

    if (($error['code'] ?? null) == 1) {
        responderJSON(false, 'Ya existe un médico con ese correo o número de colegiatura.', null, 409);
    }
    if (($error['code'] ?? null) == 2291) {
        responderJSON(false, 'La especialidad seleccionada no es válida.', null, 400);
    }

    responderJSON(false, 'Error al actualizar el médico: ' . $error['message'], null, 500);
}

oci_free_statement($stmt);
$db->disconnect();

responderJSON(true, 'Médico actualizado correctamente.');
