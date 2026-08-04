/*
PRISMA
Sistema de Gestión y Consolidación de Información Clínica
SC-504 Lenguajes de Base de Datos

Archivo : 09_reportes.sql
Motor    : Oracle Database 23c Free
Contenido: Procedimientos de solo lectura para Dashboard y Reportes
*/

---------------------------------------------------------
-- INDICADORES GENERALES (TARJETAS DE DASHBOARD Y REPORTES)
---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_REPORTE_INDICADORES(

    P_TOTAL_PACIENTES          OUT NUMBER,
    P_TOTAL_MEDICOS             OUT NUMBER,
    P_TOTAL_CITAS_HOY           OUT NUMBER,
    P_TOTAL_CITAS_MES           OUT NUMBER,
    P_TOTAL_CITAS_PENDIENTES    OUT NUMBER,
    P_TOTAL_TRATAMIENTOS_ACTIVOS OUT NUMBER,
    P_TOTAL_TRATAMIENTOS_FIN    OUT NUMBER,
    P_TOTAL_CONSULTAS           OUT NUMBER,
    P_TOTAL_MEDICAMENTOS        OUT NUMBER,
    P_FACTURACION_MES           OUT NUMBER

)
AS
BEGIN

    SELECT COUNT(*) INTO P_TOTAL_PACIENTES FROM PACIENTE;

    SELECT COUNT(*) INTO P_TOTAL_MEDICOS FROM DOCTOR;

    SELECT COUNT(*) INTO P_TOTAL_CITAS_HOY
    FROM CITA
    WHERE TRUNC(FECHA) = TRUNC(SYSDATE);

    SELECT COUNT(*) INTO P_TOTAL_CITAS_MES
    FROM CITA
    WHERE TRUNC(FECHA, 'MM') = TRUNC(SYSDATE, 'MM');

    SELECT COUNT(*) INTO P_TOTAL_CITAS_PENDIENTES
    FROM CITA
    WHERE ESTADO IN ('PROGRAMADA', 'CONFIRMADA');

    SELECT COUNT(*) INTO P_TOTAL_TRATAMIENTOS_ACTIVOS
    FROM TRATAMIENTO
    WHERE FECHA_INICIO + DURACION_DIAS >= TRUNC(SYSDATE);

    SELECT COUNT(*) INTO P_TOTAL_TRATAMIENTOS_FIN
    FROM TRATAMIENTO
    WHERE FECHA_INICIO + DURACION_DIAS < TRUNC(SYSDATE);

    SELECT COUNT(*) INTO P_TOTAL_CONSULTAS FROM CONSULTA;

    SELECT COUNT(*) INTO P_TOTAL_MEDICAMENTOS FROM MEDICAMENTO;

    SELECT NVL(SUM(TOTAL), 0) INTO P_FACTURACION_MES
    FROM FACTURA
    WHERE ESTADO = 'PAGADA'
    AND TRUNC(FECHA, 'MM') = TRUNC(SYSDATE, 'MM');

END;
/

---------------------------------------------------------
-- PACIENTES POR SEXO
---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_REPORTE_PACIENTES_SEXO(

    P_CURSOR OUT SYS_REFCURSOR

)
AS
BEGIN

    OPEN P_CURSOR FOR
        SELECT SEXO, COUNT(*) AS TOTAL
        FROM PACIENTE
        GROUP BY SEXO;

END;
/

---------------------------------------------------------
-- CITAS POR ESTADO
---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_REPORTE_CITAS_ESTADO(

    P_CURSOR OUT SYS_REFCURSOR

)
AS
BEGIN

    OPEN P_CURSOR FOR
        SELECT ESTADO, COUNT(*) AS TOTAL
        FROM CITA
        GROUP BY ESTADO;

END;
/

---------------------------------------------------------
-- CONSULTAS POR MES (ULTIMOS 6 MESES)
---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_REPORTE_CONSULTAS_MES(

    P_CURSOR OUT SYS_REFCURSOR

)
AS
BEGIN

    OPEN P_CURSOR FOR
        SELECT
            TO_CHAR(FECHA, 'YYYY-MM') AS MES,
            COUNT(*) AS TOTAL
        FROM CONSULTA
        WHERE FECHA >= ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -5)
        GROUP BY TO_CHAR(FECHA, 'YYYY-MM')
        ORDER BY MES;

END;
/

---------------------------------------------------------
-- MEDICOS POR ESPECIALIDAD
---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_REPORTE_MEDICOS_ESPECIALIDAD(

    P_CURSOR OUT SYS_REFCURSOR

)
AS
BEGIN

    OPEN P_CURSOR FOR
        SELECT
            E.NOMBRE_ESPECIALIDAD AS ESPECIALIDAD,
            COUNT(D.ID_MEDICO) AS TOTAL
        FROM ESPECIALIDAD E
        LEFT JOIN DOCTOR D ON D.ID_ESPECIALIDAD = E.ID_ESPECIALIDAD
        GROUP BY E.NOMBRE_ESPECIALIDAD
        ORDER BY TOTAL DESC;

END;
/

---------------------------------------------------------
-- TRATAMIENTOS ACTIVOS POR DIA (ULTIMOS 7 DIAS)
---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_REPORTE_TRATAMIENTOS_DIA(

    P_CURSOR OUT SYS_REFCURSOR

)
AS
BEGIN

    OPEN P_CURSOR FOR
        SELECT
            DIAS.DIA AS DIA,
            (
                SELECT COUNT(*)
                FROM TRATAMIENTO T
                WHERE T.FECHA_INICIO <= DIAS.DIA
                AND T.FECHA_INICIO + T.DURACION_DIAS >= DIAS.DIA
            ) AS TOTAL
        FROM (
            SELECT TRUNC(SYSDATE) - LEVEL + 1 AS DIA
            FROM DUAL
            CONNECT BY LEVEL <= 7
        ) DIAS
        ORDER BY DIA;

END;
/

---------------------------------------------------------
-- PACIENTES RECIENTES (ULTIMAS CITAS REGISTRADAS)
---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_REPORTE_CITAS_RECIENTES(

    P_CURSOR OUT SYS_REFCURSOR

)
AS
BEGIN

    OPEN P_CURSOR FOR
        SELECT *
        FROM (
            SELECT
                P.NOMBRE || ' ' || P.APELLIDO AS PACIENTE,
                D.NOMBRE || ' ' || D.APELLIDO AS MEDICO,
                C.FECHA AS FECHA,
                C.ESTADO AS ESTADO
            FROM CITA C
            JOIN PACIENTE P ON P.ID_PACIENTE = C.ID_PACIENTE
            JOIN DOCTOR D ON D.ID_MEDICO = C.ID_MEDICO
            ORDER BY C.FECHA DESC, C.ID_CITA DESC
        )
        WHERE ROWNUM <= 5;

END;
/
