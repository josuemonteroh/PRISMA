<?php

class Database
{
    private $connection;

    public function connect()
    {
        $username = "prisma";
        $password = "prisma123";
        $connectionString = "oracle:1521/FREEPDB1";

        $this->connection = oci_connect(
            $username,
            $password,
            $connectionString,
            "AL32UTF8"
        );

        if (!$this->connection) {

            $error = oci_error();

            die(
                "Error de conexión Oracle: "
                . $error["message"]
            );
        }

        return $this->connection;
    }

    public function disconnect()
    {
        if ($this->connection) {

            oci_close($this->connection);

        }
    }
}