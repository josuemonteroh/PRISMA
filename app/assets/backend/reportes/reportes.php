<?php

require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../common/middleware.php';
require_once __DIR__ . '/../common/response.php';
require_once __DIR__ . '/../helpers/DatabaseHelper.php';

requerirSesion();

$db   = new DatabaseHelper();
$conn = $db->getConnection();

$stmtIndicadores = oci_parse($conn, "
    BEGIN
        SP_REPORTE_INDICADORES(
            :pacientes, :medicos, :citas_hoy, :citas_mes, :citas_pendientes,
            :tratamientos_activos, :tratamientos_fin, :consultas, :medicamentos, :facturacion_mes
        );
    END;
");

$pacientes           = 0;
$medicos             = 0;
$citasHoy            = 0;
$citasMes            = 0;
$citasPendientes     = 0;
$tratamientosActivos = 0;
$tratamientosFin     = 0;
$consultas           = 0;
$medicamentos        = 0;
$facturacionMes      = 0;

oci_bind_by_name($stmtIndicadores, ':pacientes', $pacientes);
oci_bind_by_name($stmtIndicadores, ':medicos', $medicos);
oci_bind_by_name($stmtIndicadores, ':citas_hoy', $citasHoy);
oci_bind_by_name($stmtIndicadores, ':citas_mes', $citasMes);
oci_bind_by_name($stmtIndicadores, ':citas_pendientes', $citasPendientes);
oci_bind_by_name($stmtIndicadores, ':tratamientos_activos', $tratamientosActivos);
oci_bind_by_name($stmtIndicadores, ':tratamientos_fin', $tratamientosFin);
oci_bind_by_name($stmtIndicadores, ':consultas', $consultas);
oci_bind_by_name($stmtIndicadores, ':medicamentos', $medicamentos);
oci_bind_by_name($stmtIndicadores, ':facturacion_mes', $facturacionMes);

oci_execute($stmtIndicadores);
oci_free_statement($stmtIndicadores);

function ejecutarCursor($conn, string $procedimiento): array
{
    $stmt   = oci_parse($conn, "BEGIN $procedimiento(:cursor); END;");
    $cursor = oci_new_cursor($conn);
    oci_bind_by_name($stmt, ':cursor', $cursor, -1, OCI_B_CURSOR);
    oci_execute($stmt);
    oci_execute($cursor);

    $filas = [];
    while ($fila = oci_fetch_assoc($cursor)) {
        $filas[] = $fila;
    }

    oci_free_statement($cursor);
    oci_free_statement($stmt);

    return $filas;
}

$consultasPorMes = [];
foreach (ejecutarCursor($conn, 'SP_REPORTE_CONSULTAS_MES') as $fila) {
    $consultasPorMes[] = [
        'mes'   => $fila['MES'],
        'total' => (int) $fila['TOTAL'],
    ];
}

$medicosPorEspecialidad = [];
foreach (ejecutarCursor($conn, 'SP_REPORTE_MEDICOS_ESPECIALIDAD') as $fila) {
    $medicosPorEspecialidad[] = [
        'especialidad' => $fila['ESPECIALIDAD'],
        'total'        => (int) $fila['TOTAL'],
    ];
}

$tratamientosPorDia = [];
foreach (ejecutarCursor($conn, 'SP_REPORTE_TRATAMIENTOS_DIA') as $fila) {
    $tratamientosPorDia[] = [
        'dia'   => $fila['DIA'],
        'total' => (int) $fila['TOTAL'],
    ];
}

$db->disconnect();

responderJSON(true, 'Datos de reportes obtenidos.', [
    'indicadores' => [
        'pacientes'            => (int) $pacientes,
        'medicos'              => (int) $medicos,
        'citas_hoy'            => (int) $citasHoy,
        'citas_mes'            => (int) $citasMes,
        'citas_pendientes'     => (int) $citasPendientes,
        'tratamientos_activos' => (int) $tratamientosActivos,
        'tratamientos_fin'     => (int) $tratamientosFin,
        'consultas'            => (int) $consultas,
        'medicamentos'         => (int) $medicamentos,
        'facturacion_mes'      => (float) $facturacionMes,
    ],
    'consultas_por_mes'        => $consultasPorMes,
    'medicos_por_especialidad' => $medicosPorEspecialidad,
    'tratamientos_por_dia'     => $tratamientosPorDia,
]);
