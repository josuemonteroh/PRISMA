/*
PRISMA
Sistema de Gestión y Consolidación de Información Clínica
SC-504 Lenguajes de Base de Datos

Archivo : 06_views.sql
Motor    : Oracle Database 23c Free
*/

---------------------------------------------------------
-- PACIENTES E HISTORIALES
---------------------------------------------------------

CREATE OR REPLACE VIEW VW_PACIENTES_HISTORIALES
AS

SELECT

    P.ID_PACIENTE,
    P.NOMBRE,
    P.APELLIDO,
    P.CEDULA,
    H.ID_HISTORIAL,
    H.FECHA_CREACION

FROM PACIENTE P

INNER JOIN HISTORIAL_CLINICO H

ON P.ID_PACIENTE = H.ID_PACIENTE;

---------------------------------------------------------
-- CITAS PROGRAMADAS
---------------------------------------------------------

CREATE OR REPLACE VIEW VW_CITAS
AS

SELECT

    C.ID_CITA,
    P.NOMBRE || ' ' || P.APELLIDO AS PACIENTE,
    D.NOMBRE || ' ' || D.APELLIDO AS MEDICO,
    CO.NOMBRE AS CONSULTORIO,
    C.FECHA,
    C.HORA,
    C.ESTADO

FROM CITA C

INNER JOIN PACIENTE P

ON C.ID_PACIENTE = P.ID_PACIENTE

INNER JOIN DOCTOR D

ON C.ID_MEDICO = D.ID_MEDICO

INNER JOIN CONSULTORIO CO

ON C.ID_CONSULTORIO = CO.ID_CONSULTORIO;

---------------------------------------------------------
-- DOCTORES Y ESPECIALIDADES
---------------------------------------------------------

CREATE OR REPLACE VIEW VW_DOCTORES
AS

SELECT

    D.ID_MEDICO,
    D.NOMBRE,
    D.APELLIDO,
    E.NOMBRE_ESPECIALIDAD,
    D.TELEFONO,
    D.CORREO

FROM DOCTOR D

INNER JOIN ESPECIALIDAD E

ON D.ID_ESPECIALIDAD = E.ID_ESPECIALIDAD;

---------------------------------------------------------
-- CONSULTAS MÉDICAS
---------------------------------------------------------

CREATE OR REPLACE VIEW VW_CONSULTAS
AS

SELECT

    C.ID_CONSULTA,
    P.NOMBRE || ' ' || P.APELLIDO AS PACIENTE,
    D.NOMBRE || ' ' || D.APELLIDO AS MEDICO,
    C.FECHA,
    C.OBSERVACIONES

FROM CONSULTA C

INNER JOIN HISTORIAL_CLINICO H

ON C.ID_HISTORIAL = H.ID_HISTORIAL

INNER JOIN PACIENTE P

ON H.ID_PACIENTE = P.ID_PACIENTE

INNER JOIN DOCTOR D

ON C.ID_MEDICO = D.ID_MEDICO;

---------------------------------------------------------
-- FACTURAS
---------------------------------------------------------

CREATE OR REPLACE VIEW VW_FACTURAS
AS

SELECT

    F.ID_FACTURA,
    P.NOMBRE || ' ' || P.APELLIDO AS PACIENTE,
    F.FECHA,
    F.SUBTOTAL,
    F.IMPUESTO,
    F.TOTAL,
    F.ESTADO

FROM FACTURA F

INNER JOIN CONSULTA C

ON F.ID_CONSULTA = C.ID_CONSULTA

INNER JOIN HISTORIAL_CLINICO H

ON C.ID_HISTORIAL = H.ID_HISTORIAL

INNER JOIN PACIENTE P

ON H.ID_PACIENTE = P.ID_PACIENTE;

---------------------------------------------------------
-- RECETAS
---------------------------------------------------------

CREATE OR REPLACE VIEW VW_RECETAS
AS

SELECT

    R.ID_RECETA,
    P.NOMBRE || ' ' || P.APELLIDO AS PACIENTE,
    D.NOMBRE || ' ' || D.APELLIDO AS MEDICO,
    R.FECHA,
    R.OBSERVACIONES

FROM RECETA R

INNER JOIN CONSULTA C

ON R.ID_CONSULTA = C.ID_CONSULTA

INNER JOIN HISTORIAL_CLINICO H

ON C.ID_HISTORIAL = H.ID_HISTORIAL

INNER JOIN PACIENTE P

ON H.ID_PACIENTE = P.ID_PACIENTE

INNER JOIN DOCTOR D

ON C.ID_MEDICO = D.ID_MEDICO;

---------------------------------------------------------
-- TRATAMIENTOS
---------------------------------------------------------

CREATE OR REPLACE VIEW VW_TRATAMIENTOS
AS

SELECT

    T.ID_TRATAMIENTO,
    M.NOMBRE AS MEDICAMENTO,
    T.DOSIS,
    T.FRECUENCIA,
    T.DURACION_DIAS,
    T.FECHA_INICIO

FROM TRATAMIENTO T

INNER JOIN MEDICAMENTO M

ON T.ID_MEDICAMENTO = M.ID_MEDICAMENTO;

---------------------------------------------------------
-- PAGOS
---------------------------------------------------------

CREATE OR REPLACE VIEW VW_PAGOS
AS

SELECT

    P.ID_PAGO,
    F.ID_FACTURA,
    P.FECHA,
    P.MONTO,
    P.METODO_PAGO,
    P.REFERENCIA

FROM PAGO P

INNER JOIN FACTURA F

ON P.ID_FACTURA = F.ID_FACTURA;

---------------------------------------------------------
-- ALERGIAS
---------------------------------------------------------

CREATE OR REPLACE VIEW VW_ALERGIAS
AS

SELECT

    A.ID_ALERGIA,
    P.NOMBRE || ' ' || P.APELLIDO AS PACIENTE,
    A.NOMBRE_ALERGIA,
    A.TIPO,
    A.SEVERIDAD

FROM ALERGIA A

INNER JOIN PACIENTE P

ON A.ID_PACIENTE = P.ID_PACIENTE;

---------------------------------------------------------
-- INDICADORES DE SALUD
---------------------------------------------------------

CREATE OR REPLACE VIEW VW_INDICADORES
AS

SELECT

    I.ID_INDICADOR,
    P.NOMBRE || ' ' || P.APELLIDO AS PACIENTE,
    I.TIPO_INDICADOR,
    I.VALOR,
    I.UNIDAD_MEDIDA,
    I.FECHA_REGISTRO

FROM INDICADOR_SALUD I

INNER JOIN PACIENTE P

ON I.ID_PACIENTE = P.ID_PACIENTE;

---------------------------------------------------------
-- AUDITORIA
---------------------------------------------------------

CREATE OR REPLACE VIEW VW_AUDITORIA
AS

SELECT

    A.ID_AUDITORIA,
    U.NOMBRE_USUARIO,
    A.TABLA_AFECTADA,
    A.ACCION,
    A.FECHA

FROM AUDITORIA A

INNER JOIN USUARIO U

ON A.ID_USUARIO = U.ID_USUARIO;

