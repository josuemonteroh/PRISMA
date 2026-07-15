<?php

require_once __DIR__ . "/config/conexion.php";

$nombreUsuario = "admin";
$claveTextoPlano = "Grupo2#2026"; // cambienla despues de crear el usuario
$correo = "admin@prisma.com";
$idRolAdministrador = 1; // segun el orden de insercion en 01_ajustes_esquema.sql

$hash = password_hash($claveTextoPlano, PASSWORD_BCRYPT);

$conexion = oci_connect(DB_USUARIO, DB_CLAVE, DB_CADENA, "AL32UTF8");
if (!$conexion) {
    die("No se pudo conectar a Oracle: " . (oci_error()['message'] ?? "error desconocido") . PHP_EOL);
}

$sentencia = oci_parse($conexion, "BEGIN pkg_usuarios.sp_insertar_usuario(:u, :h, :c, :r); END;");
oci_bind_by_name($sentencia, ":u", $nombreUsuario);
oci_bind_by_name($sentencia, ":h", $hash);
oci_bind_by_name($sentencia, ":c", $correo);
oci_bind_by_name($sentencia, ":r", $idRolAdministrador);

if (oci_execute($sentencia)) {
    echo "Usuario administrador creado correctamente." . PHP_EOL;
    echo "Usuario: {$nombreUsuario}" . PHP_EOL;
    echo "Clave:   {$claveTextoPlano}" . PHP_EOL;
} else {
    $e = oci_error($sentencia);
    echo "Error al crear el usuario: " . $e['message'] . PHP_EOL;
}

oci_free_statement($sentencia);
oci_close($conexion);
