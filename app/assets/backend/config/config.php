<?php



require_once __DIR__ . '/constants.php';

date_default_timezone_set(APP_TIMEZONE);

error_reporting(E_ALL);
ini_set('display_errors', 1);

session_name(APP_SESSION_NAME);
