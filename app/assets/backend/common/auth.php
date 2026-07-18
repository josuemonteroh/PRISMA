<?php

require_once __DIR__ . '/../config/config.php';


function iniciarSesionUsuario(int $idUsuario, string $nombreUsuario, int $idRol): void
{
    if (session_status() !== PHP_SESSION_ACTIVE) {
        session_start();
    }

   
    session_regenerate_id(true);

    $_SESSION['id_usuario']      = $idUsuario;
    $_SESSION['nombre_usuario']  = $nombreUsuario;
    $_SESSION['id_rol']          = $idRol;
}

function haySesionActiva(): bool
{
    if (session_status() !== PHP_SESSION_ACTIVE) {
        session_start();
    }

    return isset($_SESSION['id_usuario']);
}

function obtenerUsuarioSesion(): ?array
{
    if (!haySesionActiva()) {
        return null;
    }

    return [
        'id_usuario'     => $_SESSION['id_usuario'],
        'nombre_usuario' => $_SESSION['nombre_usuario'],
        'id_rol'         => $_SESSION['id_rol'],
    ];
}

function cerrarSesionUsuario(): void
{
    if (session_status() !== PHP_SESSION_ACTIVE) {
        session_start();
    }

    $_SESSION = [];

    if (ini_get('session.use_cookies')) {
        $params = session_get_cookie_params();
        setcookie(
            session_name(),
            '',
            time() - 42000,
            $params['path'],
            $params['domain'],
            $params['secure'],
            $params['httponly']
        );
    }

    session_destroy();
}
