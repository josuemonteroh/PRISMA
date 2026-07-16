<?php

class Database
{
    private $connection;

    public function connect()
    {
        $this->connection = oci_connect(
            "prisma",
            "prisma123",
            "oracle:1521/FREEPDB1",
            "AL32UTF8"
        );

        if (!$this->connection) {

            $error = oci_error();

            die($error["message"]);
        }

        return $this->connection;
    }
}