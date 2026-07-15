<?php

require_once __DIR__ . "/../config/conexion.php";

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

if (empty($_SESSION['id_usuario'])) {
    responderError(401, "Debe iniciar sesion.");
}

$metodo = $_SERVER['REQUEST_METHOD'];
$conexion = obtenerConexion();

switch ($metodo) {
    case 'GET':
        if (!empty($_GET['termino'])) {
            buscarPacientes($conexion, $_GET['termino']);
        } else {
            listarPacientes($conexion);
        }
        break;

    case 'POST':
        crearPaciente($conexion, leerCuerpoJson());
        break;

    case 'PUT':
        actualizarPaciente($conexion, leerCuerpoJson());
        break;

    case 'DELETE':
        eliminarPaciente($conexion, $_GET['id'] ?? null);
        break;

    default:
        responderError(405, "Metodo no permitido.");
}

oci_close($conexion);

// -------------------------------------------------------------------

function leerCuerpoJson(): array {
    $datos = json_decode(file_get_contents("php://input"), true);
    return is_array($datos) ? $datos : [];
}

function listarPacientes($conexion): void {
    $sentencia = oci_parse($conexion, "BEGIN pkg_pacientes.sp_listar_pacientes(:cur); END;");
    $cursor = oci_new_cursor($conexion);
    oci_bind_by_name($sentencia, ":cur", $cursor, -1, OCI_B_CURSOR);

    oci_execute($sentencia);
    oci_execute($cursor);

    $pacientes = [];
    while ($fila = oci_fetch_assoc($cursor)) {
        $pacientes[] = $fila;
    }

    oci_free_statement($cursor);
    oci_free_statement($sentencia);

    responderExito($pacientes);
}

function buscarPacientes($conexion, string $termino): void {
    $sentencia = oci_parse($conexion, "BEGIN pkg_pacientes.sp_buscar_pacientes(:t, :cur); END;");
    $cursor = oci_new_cursor($conexion);
    oci_bind_by_name($sentencia, ":t", $termino);
    oci_bind_by_name($sentencia, ":cur", $cursor, -1, OCI_B_CURSOR);

    oci_execute($sentencia);
    oci_execute($cursor);

    $pacientes = [];
    while ($fila = oci_fetch_assoc($cursor)) {
        $pacientes[] = $fila;
    }

    oci_free_statement($cursor);
    oci_free_statement($sentencia);

    responderExito($pacientes);
}

function crearPaciente($conexion, array $d): void {
    $camposFaltantes = validarCamposObligatorios($d);
    if ($camposFaltantes) {
        responderError(400, "Faltan campos obligatorios: " . implode(", ", $camposFaltantes));
    }

    $sentencia = oci_parse($conexion, "BEGIN pkg_pacientes.sp_insertar_paciente(
        :nombre, :apellido, :cedula, :telefono, :correo,
        :fecha_nacimiento, :sexo, :direccion, :estado, :id_medico
    ); END;");

    enlazarCamposPaciente($sentencia, $d);

    if (oci_execute($sentencia)) {
        responderExito(null, "Paciente registrado correctamente.");
    } else {
        $e = oci_error($sentencia);
        responderError(400, traducirErrorOracle($e), $e['message']);
    }
}

function actualizarPaciente($conexion, array $d): void {
    if (empty($d['id'])) {
        responderError(400, "Debe indicar el ID del paciente a actualizar.");
    }

    $camposFaltantes = validarCamposObligatorios($d);
    if ($camposFaltantes) {
        responderError(400, "Faltan campos obligatorios: " . implode(", ", $camposFaltantes));
    }

    $sentencia = oci_parse($conexion, "BEGIN pkg_pacientes.sp_actualizar_paciente(
        :id, :nombre, :apellido, :cedula, :telefono, :correo,
        :fecha_nacimiento, :sexo, :direccion, :estado, :id_medico
    ); END;");

    oci_bind_by_name($sentencia, ":id", $d['id']);
    enlazarCamposPaciente($sentencia, $d);

    if (oci_execute($sentencia)) {
        responderExito(null, "Paciente actualizado correctamente.");
    } else {
        $e = oci_error($sentencia);
        responderError(400, traducirErrorOracle($e), $e['message']);
    }
}

function eliminarPaciente($conexion, $id): void {
    if (!$id) {
        responderError(400, "Debe indicar el ID del paciente a eliminar.");
    }

    $sentencia = oci_parse($conexion, "BEGIN pkg_pacientes.sp_eliminar_paciente(:id); END;");
    oci_bind_by_name($sentencia, ":id", $id);

    if (oci_execute($sentencia)) {
        responderExito(null, "Paciente eliminado correctamente.");
    } else {
        $e = oci_error($sentencia);
        responderError(400, traducirErrorOracle($e), $e['message']);
    }
}

function enlazarCamposPaciente($sentencia, array $d): void {
    // OCI8 necesita variables reales (no literales) para bind_by_name.
    $nombre   = $d['nombre'] ?? null;
    $apellido = $d['apellido'] ?? null;
    $cedula   = $d['cedula'] ?? null;
    $telefono = $d['telefono'] ?? null;
    $correo   = $d['correo'] ?? null;
    $fecha    = $d['fechaNacimiento'] ?? null;
    $sexo     = normalizarSexo($d['sexo'] ?? null);
    $direccion = $d['direccion'] ?? null;
    $estado   = strtoupper($d['estado'] ?? 'ACTIVO');
    $idMedico = $d['idMedico'] ?? null;

    oci_bind_by_name($sentencia, ":nombre", $nombre);
    oci_bind_by_name($sentencia, ":apellido", $apellido);
    oci_bind_by_name($sentencia, ":cedula", $cedula);
    oci_bind_by_name($sentencia, ":telefono", $telefono);
    oci_bind_by_name($sentencia, ":correo", $correo);
    oci_bind_by_name($sentencia, ":fecha_nacimiento", $fecha);
    oci_bind_by_name($sentencia, ":sexo", $sexo);
    oci_bind_by_name($sentencia, ":direccion", $direccion);
    oci_bind_by_name($sentencia, ":estado", $estado);
    oci_bind_by_name($sentencia, ":id_medico", $idMedico);
}

function normalizarSexo(?string $valor): ?string {
    if (!$valor) return null;
    $valor = mb_strtolower($valor);
    if (str_starts_with($valor, 'm')) return 'M';
    if (str_starts_with($valor, 'f')) return 'F';
    return null;
}

function validarCamposObligatorios(array $d): array {
    $obligatorios = ['nombre', 'apellido', 'cedula'];
    $faltantes = [];
    foreach ($obligatorios as $campo) {
        if (empty($d[$campo])) {
            $faltantes[] = $campo;
        }
    }
    return $faltantes;
}

function traducirErrorOracle(array $e): string {
    $mensaje = $e['message'] ?? '';
    if (str_contains($mensaje, 'ORA-20101')) return "Ya existe un paciente con esa cedula.";
    if (str_contains($mensaje, 'ORA-20102')) return "No existe un paciente con ese ID.";
    if (str_contains($mensaje, 'ORA-20103')) return "No existe un paciente con ese ID.";
    return "Ocurrio un error al procesar la solicitud.";
}
