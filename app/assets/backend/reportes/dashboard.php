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

oci_bind_by_name($stmtIndicadores, ':pacientes', $pacientes, 50);
oci_bind_by_name($stmtIndicadores, ':medicos', $medicos, 50);
oci_bind_by_name($stmtIndicadores, ':citas_hoy', $citasHoy, 50);
oci_bind_by_name($stmtIndicadores, ':citas_mes', $citasMes, 50);
oci_bind_by_name($stmtIndicadores, ':citas_pendientes', $citasPendientes, 50);
oci_bind_by_name($stmtIndicadores, ':tratamientos_activos', $tratamientosActivos, 50);
oci_bind_by_name($stmtIndicadores, ':tratamientos_fin', $tratamientosFin, 50);
oci_bind_by_name($stmtIndicadores, ':consultas', $consultas, 50);
oci_bind_by_name($stmtIndicadores, ':medicamentos', $medicamentos, 50);
oci_bind_by_name($stmtIndicadores, ':facturacion_mes', $facturacionMes, 50);

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

$pacientesPorSexo = [];
foreach (ejecutarCursor($conn, 'SP_REPORTE_PACIENTES_SEXO') as $fila) {
    $pacientesPorSexo[] = [
        'sexo'  => $fila['SEXO'],
        'total' => (int) $fila['TOTAL'],
    ];
}

$citasPorEstado = [];
foreach (ejecutarCursor($conn, 'SP_REPORTE_CITAS_ESTADO') as $fila) {
    $citasPorEstado[] = [
        'estado' => $fila['ESTADO'],
        'total'  => (int) $fila['TOTAL'],
    ];
}

$citasRecientes = [];
foreach (ejecutarCursor($conn, 'SP_REPORTE_CITAS_RECIENTES') as $fila) {
    $citasRecientes[] = [
        'paciente' => $fila['PACIENTE'],
        'medico'   => $fila['MEDICO'],
        'fecha'    => $fila['FECHA'],
        'estado'   => $fila['ESTADO'],
    ];
}

$db->disconnect();

responderJSON(true, 'Datos del dashboard obtenidos.', [
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
    'pacientes_por_sexo' => $pacientesPorSexo,
    'citas_por_estado'   => $citasPorEstado,
    'citas_recientes'    => $citasRecientes,
]);
