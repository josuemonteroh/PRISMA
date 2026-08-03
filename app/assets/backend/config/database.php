<?php


class Database
{
    private $connection;

    public function connect()
    {
        $usuario   = getenv('DB_USER')     ?: 'prisma';
        $clave     = getenv('DB_PASSWORD') ?: 'prisma123';
        $host      = getenv('DB_HOST')     ?: 'oracle';
        $puerto    = getenv('DB_PORT')     ?: '1521';
        $servicio  = getenv('DB_SERVICE')  ?: 'FREEPDB1';

        $cadenaConexion = "{$host}:{$puerto}/{$servicio}";

        $this->connection = @oci_connect(
            $usuario,
            $clave,
            $cadenaConexion,
            'AL32UTF8'
        );

        if (!$this->connection) {

            $error = oci_error();

            http_response_code(500);
            header('Content-Type: application/json; charset=utf-8');

            echo json_encode([
                'success' => false,
                'message' => 'Error de conexión con Oracle: ' . ($error['message'] ?? 'desconocido'),
            ]);

            exit;
        }

        $stmtNls = oci_parse($this->connection, "ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD'");
        oci_execute($stmtNls);
        oci_free_statement($stmtNls);

        return $this->connection;
    }

    public function disconnect()
    {
        if ($this->connection) {

            oci_close($this->connection);

        }
    }
}
