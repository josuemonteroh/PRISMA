<?php
require_once __DIR__ . '/../common/auth.php';

header('Content-Type: application/json; charset=utf-8');

if (!haySesionActiva()) {
    http_response_code(401);
    echo json_encode(['success' => false]);
    exit;
}

echo json_encode([
    'success' => true,
    'usuario' => obtenerUsuarioSesion(),
]);
