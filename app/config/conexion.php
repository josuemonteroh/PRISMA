<?php

const DB_USUARIO = "prisma_user";
const DB_CLAVE    = "SuClaveSegura123";
const DB_CADENA   = "lenguajesbd_high"; 

putenv("TNS_ADMIN=C:\\xampp\\htdocs\\prisma\\wallet");


function obtenerConexion() {
    $conexion = @oci_connect(DB_USUARIO, DB_CLAVE, DB_CADENA, "AL32UTF8");

    if (!$conexion) {
        $error = oci_error();
        responderError(500, "Error de conexion a la base de datos.", $error['message'] ?? null);
    }

    iniciarSesionOracle($conexion);

    return $conexion;
}

function iniciarSesionOracle($conexion): void {
    if (session_status() === PHP_SESSION_NONE) {
        session_start();
    }

    if (empty($_SESSION['id_usuario'])) {
        return;
    }

    $sentencia = oci_parse($conexion, "BEGIN pkg_sesion.sp_set_usuario(:id_usuario); END;");
    oci_bind_by_name($sentencia, ":id_usuario", $_SESSION['id_usuario']);
    oci_execute($sentencia);
    oci_free_statement($sentencia);
}

function responderError(int $codigoHttp, string $mensaje, ?string $detalle = null): void {
    http_response_code($codigoHttp);
    header("Content-Type: application/json; charset=UTF-8");
    echo json_encode([
        "exito"   => false,
        "mensaje" => $mensaje,
        "detalle" => $detalle,
    ]);
    exit;
}

function responderExito($datos = null, string $mensaje = "OK"): void {
    header("Content-Type: application/json; charset=UTF-8");
    echo json_encode([
        "exito"   => true,
        "mensaje" => $mensaje,
        "datos"   => $datos,
    ]);
    exit;
}
