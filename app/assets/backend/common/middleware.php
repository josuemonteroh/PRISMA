<?php

require_once __DIR__ . '/auth.php';


function requerirSesion(): array
{
    if (!haySesionActiva()) {

        http_response_code(401);
        header('Content-Type: application/json; charset=utf-8');

        echo json_encode([
            'success' => false,
            'message' => 'Sesión no válida. Inicie sesión nuevamente.',
        ]);

        exit;
    }

    return obtenerUsuarioSesion();
}
