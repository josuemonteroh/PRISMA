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

$id        = (int) ($entrada['id'] ?? 0);
$nombre    = trim($entrada['nombre']   ?? '');
$apellido  = trim($entrada['apellido'] ?? '');
$cedula    = trim($entrada['cedula']   ?? '');
$telefono  = trim($entrada['telefono'] ?? '');
$correo    = trim($entrada['correo']   ?? '');
$fecha     = trim($entrada['fecha_nacimiento'] ?? '');
$sexo      = trim($entrada['sexo']     ?? '');
$direccion = trim($entrada['direccion'] ?? '');

if ($id <= 0 || $nombre === '' || $apellido === '' || $cedula === '' || $fecha === '' || $sexo === '') {
    responderJSON(false, 'Datos incompletos para actualizar el paciente.', null, 400);
}

$db   = new DatabaseHelper();
$conn = $db->getConnection();

$sql = "
    UPDATE PACIENTE
    SET
        NOMBRE           = :nombre,
        APELLIDO         = :apellido,
        FECHA_NACIMIENTO = TO_DATE(:fecha, 'YYYY-MM-DD'),
        SEXO             = :sexo,
        TELEFONO         = :telefono,
        CORREO           = :correo,
        DIRECCION        = :direccion,
        CEDULA           = :cedula
    WHERE ID_PACIENTE = :id
";

$stmt = oci_parse($conn, $sql);
oci_bind_by_name($stmt, ':nombre', $nombre);
oci_bind_by_name($stmt, ':apellido', $apellido);
oci_bind_by_name($stmt, ':fecha', $fecha);
oci_bind_by_name($stmt, ':sexo', $sexo);
oci_bind_by_name($stmt, ':telefono', $telefono);
oci_bind_by_name($stmt, ':correo', $correo);
oci_bind_by_name($stmt, ':direccion', $direccion);
oci_bind_by_name($stmt, ':cedula', $cedula);
oci_bind_by_name($stmt, ':id', $id);

$exito = @oci_execute($stmt);

if (!$exito) {
    $error = oci_error($stmt);
    oci_free_statement($stmt);
    $db->disconnect();

    if (($error['code'] ?? null) == 1) {
        responderJSON(false, 'Ya existe un paciente con esa cédula o correo.', null, 409);
    }

    responderJSON(false, 'Error al actualizar el paciente: ' . $error['message'], null, 500);
}

$filasAfectadas = oci_num_rows($stmt);

oci_free_statement($stmt);
$db->disconnect();

if ($filasAfectadas === 0) {
    responderJSON(false, 'No se encontró el paciente indicado.', null, 404);
}

responderJSON(true, 'Paciente actualizado correctamente.');
