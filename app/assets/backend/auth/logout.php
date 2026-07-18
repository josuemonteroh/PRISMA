<?php

require_once __DIR__ . '/../common/auth.php';

header('Content-Type: application/json; charset=utf-8');

cerrarSesionUsuario();

echo json_encode([
    'success' => true,
    'message' => 'Sesión finalizada.',
]);
