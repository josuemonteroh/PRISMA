<?php

require_once __DIR__ . '/../config/database.php';

class DatabaseHelper
{
    private $connection;

    public function __construct()
    {
        $database = new Database();

        $this->connection = $database->connect();
    }

    public function getConnection()
    {
        return $this->connection;
    }
}