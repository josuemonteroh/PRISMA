/*
PRISMA
Sistema de Gestión y Consolidación de Información Clínica
SC-504 Lenguajes de Base de Datos

Archivo : 08_seed.sql
Motor    : Oracle Database 23c Free
*/

---------------------------------------------------------
-- ROLES
---------------------------------------------------------

INSERT INTO ROL (NOMBRE_ROL, DESCRIPCION)
VALUES ('Administrador','Control total del sistema');

INSERT INTO ROL (NOMBRE_ROL, DESCRIPCION)
VALUES ('Medico','Personal médico');

INSERT INTO ROL (NOMBRE_ROL, DESCRIPCION)
VALUES ('Recepcion','Gestión de citas');

INSERT INTO ROL (NOMBRE_ROL, DESCRIPCION)
VALUES ('Farmacia','Gestión de medicamentos');

---------------------------------------------------------
-- ESPECIALIDADES
---------------------------------------------------------

INSERT INTO ESPECIALIDAD (NOMBRE_ESPECIALIDAD, DESCRIPCION)
VALUES ('Medicina General','Consulta general');

INSERT INTO ESPECIALIDAD (NOMBRE_ESPECIALIDAD, DESCRIPCION)
VALUES ('Cardiología','Especialidad cardíaca');

INSERT INTO ESPECIALIDAD (NOMBRE_ESPECIALIDAD, DESCRIPCION)
VALUES ('Pediatría','Atención infantil');

INSERT INTO ESPECIALIDAD (NOMBRE_ESPECIALIDAD, DESCRIPCION)
VALUES ('Dermatología','Enfermedades de la piel');

---------------------------------------------------------
-- CONSULTORIOS
---------------------------------------------------------

INSERT INTO CONSULTORIO (NOMBRE,UBICACION,PISO)
VALUES ('Consultorio 101','Edificio A',1);

INSERT INTO CONSULTORIO (NOMBRE,UBICACION,PISO)
VALUES ('Consultorio 201','Edificio A',2);

INSERT INTO CONSULTORIO (NOMBRE,UBICACION,PISO)
VALUES ('Consultorio 301','Edificio B',3);

---------------------------------------------------------
-- MEDICAMENTOS
---------------------------------------------------------

INSERT INTO MEDICAMENTO
(
    NOMBRE,
    DESCRIPCION,
    PRESENTACION,
    CONCENTRACION
)
VALUES
(
    'Acetaminofén',
    'Analgésico',
    'Tabletas',
    '500 mg'
);

INSERT INTO MEDICAMENTO
(
    NOMBRE,
    DESCRIPCION,
    PRESENTACION,
    CONCENTRACION
)
VALUES
(
    'Ibuprofeno',
    'Antiinflamatorio',
    'Tabletas',
    '400 mg'
);

INSERT INTO MEDICAMENTO
(
    NOMBRE,
    DESCRIPCION,
    PRESENTACION,
    CONCENTRACION
)
VALUES
(
    'Amoxicilina',
    'Antibiótico',
    'Cápsulas',
    '500 mg'
);

COMMIT;

---------------------------------------------------------
-- USUARIOS
---------------------------------------------------------

INSERT INTO USUARIO
(
    ID_ROL,
    NOMBRE_USUARIO,
    CONTRASENA_HASH,
    CORREO,
    ESTADO
)
VALUES
(
    1,
    'admin',
    'admin123',
    'admin@prisma.com',
    'ACTIVO'
);

INSERT INTO USUARIO
(
    ID_ROL,
    NOMBRE_USUARIO,
    CONTRASENA_HASH,
    CORREO,
    ESTADO
)
VALUES
(
    2,
    'medico1',
    'med123',
    'medico1@prisma.com',
    'ACTIVO'
);

INSERT INTO USUARIO
(
    ID_ROL,
    NOMBRE_USUARIO,
    CONTRASENA_HASH,
    CORREO,
    ESTADO
)
VALUES
(
    3,
    'recepcion',
    'rec123',
    'recepcion@prisma.com',
    'ACTIVO'
);

---------------------------------------------------------
-- DOCTORES
---------------------------------------------------------

INSERT INTO DOCTOR
(
    ID_ESPECIALIDAD,
    NOMBRE,
    APELLIDO,
    TELEFONO,
    CORREO,
    NUMERO_COLEGIATURA
)
VALUES
(
    1,
    'Carlos',
    'Ramírez',
    '88881111',
    'carlos@prisma.com',
    'MED-1001'
);

INSERT INTO DOCTOR
(
    ID_ESPECIALIDAD,
    NOMBRE,
    APELLIDO,
    TELEFONO,
    CORREO,
    NUMERO_COLEGIATURA
)
VALUES
(
    2,
    'Laura',
    'Mora',
    '88882222',
    'laura@prisma.com',
    'MED-1002'
);

INSERT INTO DOCTOR
(
    ID_ESPECIALIDAD,
    NOMBRE,
    APELLIDO,
    TELEFONO,
    CORREO,
    NUMERO_COLEGIATURA
)
VALUES
(
    3,
    'José',
    'Vargas',
    '88883333',
    'jose@prisma.com',
    'MED-1003'
);

---------------------------------------------------------
-- PACIENTES
---------------------------------------------------------

INSERT INTO PACIENTE
(
    NOMBRE,
    APELLIDO,
    FECHA_NACIMIENTO,
    SEXO,
    TELEFONO,
    CORREO,
    DIRECCION,
    CEDULA
)
VALUES
(
    'Ana',
    'Rodríguez',
    DATE '1998-05-12',
    'F',
    '70001111',
    'ana@email.com',
    'San José',
    '101110111'
);

INSERT INTO PACIENTE
(
    NOMBRE,
    APELLIDO,
    FECHA_NACIMIENTO,
    SEXO,
    TELEFONO,
    CORREO,
    DIRECCION,
    CEDULA
)
VALUES
(
    'Luis',
    'Fernández',
    DATE '1985-11-20',
    'M',
    '70002222',
    'luis@email.com',
    'Cartago',
    '202220222'
);

INSERT INTO PACIENTE
(
    NOMBRE,
    APELLIDO,
    FECHA_NACIMIENTO,
    SEXO,
    TELEFONO,
    CORREO,
    DIRECCION,
    CEDULA
)
VALUES
(
    'María',
    'Soto',
    DATE '1992-03-15',
    'F',
    '70003333',
    'maria@email.com',
    'Heredia',
    '303330333'
);

---------------------------------------------------------
-- HISTORIALES CLINICOS
---------------------------------------------------------

INSERT INTO HISTORIAL_CLINICO
(
    ID_PACIENTE,
    FECHA_CREACION,
    OBSERVACIONES_GENERALES
)
VALUES
(
    1,
    SYSDATE,
    'Historial inicial.'
);

INSERT INTO HISTORIAL_CLINICO
(
    ID_PACIENTE,
    FECHA_CREACION,
    OBSERVACIONES_GENERALES
)
VALUES
(
    2,
    SYSDATE,
    'Sin antecedentes relevantes.'
);

INSERT INTO HISTORIAL_CLINICO
(
    ID_PACIENTE,
    FECHA_CREACION,
    OBSERVACIONES_GENERALES
)
VALUES
(
    3,
    SYSDATE,
    'Paciente de control.'
);

COMMIT;

---------------------------------------------------------
-- HORARIOS DE MEDICOS
---------------------------------------------------------

INSERT INTO HORARIO_MEDICO
(
    ID_MEDICO,
    DIA_SEMANA,
    HORA_INICIO,
    HORA_FIN
)
VALUES
(
    1,
    'Lunes',
    '08:00',
    '16:00'
);

INSERT INTO HORARIO_MEDICO
(
    ID_MEDICO,
    DIA_SEMANA,
    HORA_INICIO,
    HORA_FIN
)
VALUES
(
    2,
    'Martes',
    '08:00',
    '16:00'
);

INSERT INTO HORARIO_MEDICO
(
    ID_MEDICO,
    DIA_SEMANA,
    HORA_INICIO,
    HORA_FIN
)
VALUES
(
    3,
    'Miércoles',
    '08:00',
    '16:00'
);

---------------------------------------------------------
-- CITAS
---------------------------------------------------------

INSERT INTO CITA
(
    ID_PACIENTE,
    ID_MEDICO,
    ID_CONSULTORIO,
    FECHA,
    HORA,
    ESTADO,
    MOTIVO
)
VALUES
(
    1,
    1,
    1,
    DATE '2026-07-20',
    '08:30',
    'PROGRAMADA',
    'Control General'
);

INSERT INTO CITA
(
    ID_PACIENTE,
    ID_MEDICO,
    ID_CONSULTORIO,
    FECHA,
    HORA,
    ESTADO,
    MOTIVO
)
VALUES
(
    2,
    2,
    2,
    DATE '2026-07-21',
    '09:00',
    'PROGRAMADA',
    'Dolor torácico'
);

INSERT INTO CITA
(
    ID_PACIENTE,
    ID_MEDICO,
    ID_CONSULTORIO,
    FECHA,
    HORA,
    ESTADO,
    MOTIVO
)
VALUES
(
    3,
    3,
    3,
    DATE '2026-07-22',
    '10:00',
    'PROGRAMADA',
    'Control pediátrico'
);

---------------------------------------------------------
-- CONSULTAS
---------------------------------------------------------

INSERT INTO CONSULTA
(
    ID_HISTORIAL,
    ID_MEDICO,
    ID_CITA,
    FECHA,
    OBSERVACIONES
)
VALUES
(
    1,
    1,
    1,
    DATE '2026-07-20',
    'Paciente estable.'
);

INSERT INTO CONSULTA
(
    ID_HISTORIAL,
    ID_MEDICO,
    ID_CITA,
    FECHA,
    OBSERVACIONES
)
VALUES
(
    2,
    2,
    2,
    DATE '2026-07-21',
    'Requiere exámenes.'
);

INSERT INTO CONSULTA
(
    ID_HISTORIAL,
    ID_MEDICO,
    ID_CITA,
    FECHA,
    OBSERVACIONES
)
VALUES
(
    3,
    3,
    3,
    DATE '2026-07-22',
    'Paciente sin complicaciones.'
);

---------------------------------------------------------
-- DIAGNOSTICOS
---------------------------------------------------------

INSERT INTO DIAGNOSTICO
(
    ID_CONSULTA,
    CODIGO_CIE10,
    DESCRIPCION,
    FECHA
)
VALUES
(
    1,
    'Z000',
    'Examen médico general',
    DATE '2026-07-20'
);

INSERT INTO DIAGNOSTICO
(
    ID_CONSULTA,
    CODIGO_CIE10,
    DESCRIPCION,
    FECHA
)
VALUES
(
    2,
    'I200',
    'Angina de pecho',
    DATE '2026-07-21'
);

INSERT INTO DIAGNOSTICO
(
    ID_CONSULTA,
    CODIGO_CIE10,
    DESCRIPCION,
    FECHA
)
VALUES
(
    3,
    'Z001',
    'Control pediátrico',
    DATE '2026-07-22'
);

---------------------------------------------------------
-- RECETAS
---------------------------------------------------------

INSERT INTO RECETA
(
    ID_CONSULTA,
    FECHA,
    OBSERVACIONES
)
VALUES
(
    1,
    DATE '2026-07-20',
    'Tomar medicamento después de comidas.'
);

INSERT INTO RECETA
(
    ID_CONSULTA,
    FECHA,
    OBSERVACIONES
)
VALUES
(
    2,
    DATE '2026-07-21',
    'Reposo por siete días.'
);

INSERT INTO RECETA
(
    ID_CONSULTA,
    FECHA,
    OBSERVACIONES
)
VALUES
(
    3,
    DATE '2026-07-22',
    'Continuar tratamiento.'
);

---------------------------------------------------------
-- DETALLE DE RECETAS
---------------------------------------------------------

INSERT INTO DETALLE_RECETA
(
    ID_RECETA,
    ID_MEDICAMENTO,
    CANTIDAD,
    DOSIS,
    INDICACIONES
)
VALUES
(
    1,
    1,
    20,
    '1 tableta',
    'Cada 8 horas'
);

INSERT INTO DETALLE_RECETA
(
    ID_RECETA,
    ID_MEDICAMENTO,
    CANTIDAD,
    DOSIS,
    INDICACIONES
)
VALUES
(
    2,
    2,
    15,
    '1 tableta',
    'Cada 12 horas'
);

INSERT INTO DETALLE_RECETA
(
    ID_RECETA,
    ID_MEDICAMENTO,
    CANTIDAD,
    DOSIS,
    INDICACIONES
)
VALUES
(
    3,
    3,
    30,
    '1 cápsula',
    'Cada 8 horas'
);

COMMIT;

---------------------------------------------------------
-- TRATAMIENTOS
---------------------------------------------------------

INSERT INTO TRATAMIENTO
(
    ID_CONSULTA,
    ID_MEDICAMENTO,
    DOSIS,
    FRECUENCIA,
    DURACION_DIAS,
    FECHA_INICIO
)
VALUES
(
    1,
    1,
    '1 tableta',
    'Cada 8 horas',
    5,
    DATE '2026-07-20'
);

INSERT INTO TRATAMIENTO
(
    ID_CONSULTA,
    ID_MEDICAMENTO,
    DOSIS,
    FRECUENCIA,
    DURACION_DIAS,
    FECHA_INICIO
)
VALUES
(
    2,
    2,
    '1 tableta',
    'Cada 12 horas',
    7,
    DATE '2026-07-21'
);

INSERT INTO TRATAMIENTO
(
    ID_CONSULTA,
    ID_MEDICAMENTO,
    DOSIS,
    FRECUENCIA,
    DURACION_DIAS,
    FECHA_INICIO
)
VALUES
(
    3,
    3,
    '1 cápsula',
    'Cada 8 horas',
    10,
    DATE '2026-07-22'
);

---------------------------------------------------------
-- ALERGIAS
---------------------------------------------------------

INSERT INTO ALERGIA
(
    ID_PACIENTE,
    NOMBRE_ALERGIA,
    TIPO,
    SEVERIDAD
)
VALUES
(
    1,
    'Penicilina',
    'Medicamento',
    'Alta'
);

INSERT INTO ALERGIA
(
    ID_PACIENTE,
    NOMBRE_ALERGIA,
    TIPO,
    SEVERIDAD
)
VALUES
(
    2,
    'Polen',
    'Ambiental',
    'Media'
);

---------------------------------------------------------
-- ANTECEDENTES MEDICOS
---------------------------------------------------------

INSERT INTO ANTECEDENTE_MEDICO
(
    ID_PACIENTE,
    TIPO,
    DESCRIPCION,
    FECHA_REGISTRO
)
VALUES
(
    1,
    'Crónico',
    'Hipertensión',
    DATE '2025-01-10'
);

INSERT INTO ANTECEDENTE_MEDICO
(
    ID_PACIENTE,
    TIPO,
    DESCRIPCION,
    FECHA_REGISTRO
)
VALUES
(
    2,
    'Quirúrgico',
    'Apendicectomía',
    DATE '2023-06-15'
);

---------------------------------------------------------
-- INDICADORES DE SALUD
---------------------------------------------------------

INSERT INTO INDICADOR_SALUD
(
    ID_PACIENTE,
    TIPO_INDICADOR,
    VALOR,
    UNIDAD_MEDIDA,
    FECHA_REGISTRO
)
VALUES
(
    1,
    'Presión Arterial',
    120,
    'mmHg',
    SYSDATE
);

INSERT INTO INDICADOR_SALUD
(
    ID_PACIENTE,
    TIPO_INDICADOR,
    VALOR,
    UNIDAD_MEDIDA,
    FECHA_REGISTRO
)
VALUES
(
    2,
    'Peso',
    78,
    'kg',
    SYSDATE
);

INSERT INTO INDICADOR_SALUD
(
    ID_PACIENTE,
    TIPO_INDICADOR,
    VALOR,
    UNIDAD_MEDIDA,
    FECHA_REGISTRO
)
VALUES
(
    3,
    'Frecuencia Cardíaca',
    72,
    'lpm',
    SYSDATE
);

---------------------------------------------------------
-- SEGUROS MEDICOS
---------------------------------------------------------

INSERT INTO SEGURO_MEDICO
(
    ID_PACIENTE,
    ASEGURADORA,
    NUMERO_POLIZA,
    FECHA_VENCIMIENTO
)
VALUES
(
    1,
    'INS',
    'POL-1001',
    DATE '2027-12-31'
);

INSERT INTO SEGURO_MEDICO
(
    ID_PACIENTE,
    ASEGURADORA,
    NUMERO_POLIZA,
    FECHA_VENCIMIENTO
)
VALUES
(
    2,
    'ASSA',
    'POL-1002',
    DATE '2028-05-31'
);

---------------------------------------------------------
-- FACTURAS
---------------------------------------------------------

INSERT INTO FACTURA
(
    ID_CONSULTA,
    FECHA,
    SUBTOTAL,
    IMPUESTO,
    TOTAL,
    ESTADO
)
VALUES
(
    1,
    DATE '2026-07-20',
    50000,
    6500,
    56500,
    'PAGADA'
);

INSERT INTO FACTURA
(
    ID_CONSULTA,
    FECHA,
    SUBTOTAL,
    IMPUESTO,
    TOTAL,
    ESTADO
)
VALUES
(
    2,
    DATE '2026-07-21',
    65000,
    8450,
    73450,
    'PENDIENTE'
);

---------------------------------------------------------
-- PAGOS
---------------------------------------------------------

INSERT INTO PAGO
(
    ID_FACTURA,
    FECHA,
    MONTO,
    METODO_PAGO,
    REFERENCIA,
    OBSERVACIONES
)
VALUES
(
    1,
    DATE '2026-07-20',
    56500,
    'Tarjeta',
    'TRX1001',
    'Pago completo'
);

---------------------------------------------------------
-- AUDITORIA
---------------------------------------------------------

INSERT INTO AUDITORIA
(
    ID_USUARIO,
    TABLA_AFECTADA,
    ACCION,
    FECHA
)
VALUES
(
    1,
    'PACIENTE',
    'INSERT',
    SYSDATE
);

INSERT INTO AUDITORIA
(
    ID_USUARIO,
    TABLA_AFECTADA,
    ACCION,
    FECHA
)
VALUES
(
    2,
    'CONSULTA',
    'UPDATE',
    SYSDATE
);

COMMIT;