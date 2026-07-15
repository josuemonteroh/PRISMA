<?php


require_once __DIR__ . "/../config/conexion.php";

$metodo = $_SERVER['REQUEST_METHOD'];

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

if ($metodo === 'DELETE') {
    session_destroy();
    responderExito(null, "Sesion finalizada.");
}

if ($metodo !== 'POST') {
    responderError(405, "Metodo no permitido.");
}

$body = json_decode(file_get_contents("php://input"), true);
$nombreUsuario = $body['usuario'] ?? null;
$clave = $body['password'] ?? null;

if (!$nombreUsuario || !$clave) {
    responderError(400, "Debe indicar usuario y contrasena.");
}

$conexion = oci_connect(DB_USUARIO, DB_CLAVE, DB_CADENA, "AL32UTF8");
if (!$conexion) {
    responderError(500, "Error de conexion a la base de datos.", oci_error()['message'] ?? null);
}

$sentencia = oci_parse($conexion, "BEGIN pkg_usuarios.sp_obtener_usuario_login(:u, :cur); END;");
$cursor = oci_new_cursor($conexion);
oci_bind_by_name($sentencia, ":u", $nombreUsuario);
oci_bind_by_name($sentencia, ":cur", $cursor, -1, OCI_B_CURSOR);
oci_execute($sentencia);
oci_execute($cursor);

$fila = oci_fetch_assoc($cursor);

oci_free_statement($cursor);
oci_free_statement($sentencia);
oci_close($conexion);

if (!$fila) {
    responderError(401, "Usuario o contrasena incorrectos.");
}

if ($fila['ESTADO'] !== 'ACTIVO') {
    responderError(403, "El usuario esta inactivo. Contacte al administrador.");
}

if (!password_verify($clave, $fila['CONTRASENA_HASH'])) {
    responderError(401, "Usuario o contrasena incorrectos.");
}

// Login correcto: se guarda la sesion PHP
$_SESSION['id_usuario']     = $fila['ID_USUARIO'];
$_SESSION['nombre_usuario'] = $fila['NOMBRE_USUARIO'];
$_SESSION['rol']            = $fila['NOMBRE_ROL'];

responderExito([
    "nombre_usuario" => $fila['NOMBRE_USUARIO'],
    "rol"            => $fila['NOMBRE_ROL'],
], "Inicio de sesion exitoso.");
