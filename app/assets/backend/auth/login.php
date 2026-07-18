<?php

require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../common/auth.php';
require_once __DIR__ . '/../helpers/DatabaseHelper.php';

header('Content-Type: application/json; charset=utf-8');


function responderJSON(bool $success, string $message, ?array $data = null): void
{
    echo json_encode([
        'success' => $success,
        'message' => $message,
        'data'    => $data,
    ]);
    exit;
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    responderJSON(false, 'Método no permitido.');
}


$entrada = json_decode(file_get_contents('php://input'), true) ?? [];

$usuario    = trim($entrada['usuario']    ?? $_POST['usuario']    ?? '');
$contrasena =        $entrada['contrasena'] ?? $_POST['contrasena'] ?? '';

if ($usuario === '' || $contrasena === '') {
    http_response_code(400);
    responderJSON(false, 'Debe indicar usuario y contraseña.');
}

$db   = new DatabaseHelper();
$conn = $db->getConnection();

$sql = "
    SELECT
        ID_USUARIO,
        ID_ROL,
        NOMBRE_USUARIO,
        CONTRASENA_HASH
    FROM USUARIO
    WHERE UPPER(NOMBRE_USUARIO) = UPPER(:usuario)
    AND ESTADO = 'ACTIVO'
";

$stmt = oci_parse($conn, $sql);
oci_bind_by_name($stmt, ':usuario', $usuario);
oci_execute($stmt);

$fila = oci_fetch_assoc($stmt);


if (!$fila || !password_verify($contrasena, $fila['CONTRASENA_HASH'])) {

    oci_free_statement($stmt);
    $db->disconnect();

    http_response_code(401);
    responderJSON(false, 'Usuario o contraseña incorrectos.');
}

iniciarSesionUsuario(
    (int) $fila['ID_USUARIO'],
    $fila['NOMBRE_USUARIO'],
    (int) $fila['ID_ROL']
);

oci_free_statement($stmt);
$db->disconnect();

responderJSON(true, 'Inicio de sesión exitoso.', [
    'id_usuario'     => (int) $fila['ID_USUARIO'],
    'nombre_usuario' => $fila['NOMBRE_USUARIO'],
    'id_rol'         => (int) $fila['ID_ROL'],
]);
