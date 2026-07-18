<?php

require_once __DIR__ . '/../config/database.php';

class DatabaseHelper
{
    private $connection;
    private $database;

    public function __construct()
    {
        $this->database   = new Database();
        $this->connection = $this->database->connect();
    }

    public function getConnection()
    {
        return $this->connection;
    }

    public function disconnect(): void
    {
        $this->database->disconnect();
    }
}