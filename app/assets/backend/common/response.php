<?php

function responderJSON(bool $success, string $message, $data = null, int $httpCode = 200): void
{
    http_response_code($httpCode);
    header('Content-Type: application/json; charset=utf-8');

    echo json_encode([
        'success' => $success,
        'message' => $message,
        'data'    => $data,
    ], JSON_UNESCAPED_UNICODE);

    exit;
}

function leerEntradaJSON(): array
{
    return json_decode(file_get_contents('php://input'), true) ?? [];
}
