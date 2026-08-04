/*
PRISMA
Sistema de Gestión y Consolidación de Información Clínica
SC-504 Lenguajes de Base de Datos

Archivo : 07_packages.sql
Motor    : Oracle Database 23c Free
*/

---------------------------------------------------------
-- PACKAGE DE PACIENTES
---------------------------------------------------------

CREATE OR REPLACE PACKAGE PKG_PACIENTES
AS

    FUNCTION FN_TOTAL_PACIENTES
    RETURN NUMBER;

    FUNCTION FN_EDAD_PACIENTE(

        P_ID_PACIENTE IN NUMBER

    )

    RETURN NUMBER;

END PKG_PACIENTES;
/

---------------------------------------------------------

CREATE OR REPLACE PACKAGE BODY PKG_PACIENTES
AS

    FUNCTION FN_TOTAL_PACIENTES

    RETURN NUMBER

    AS

        V_TOTAL NUMBER;

    BEGIN

        SELECT COUNT(*)

        INTO V_TOTAL

        FROM PACIENTE;

        RETURN V_TOTAL;

    END;

    -----------------------------------------------------

    FUNCTION FN_EDAD_PACIENTE(

        P_ID_PACIENTE IN NUMBER

    )

    RETURN NUMBER

    AS

        V_EDAD NUMBER;

    BEGIN

        SELECT FLOOR(MONTHS_BETWEEN(SYSDATE, FECHA_NACIMIENTO)/12)

        INTO V_EDAD

        FROM PACIENTE

        WHERE ID_PACIENTE = P_ID_PACIENTE;

        RETURN V_EDAD;

    END;

END PKG_PACIENTES;
/

---------------------------------------------------------
-- PACKAGE DE CITAS
---------------------------------------------------------

CREATE OR REPLACE PACKAGE PKG_CITAS
AS

    FUNCTION FN_TOTAL_CITAS

    RETURN NUMBER;

    FUNCTION FN_TOTAL_CITAS_MEDICO(

        P_ID_MEDICO IN NUMBER

    )

    RETURN NUMBER;

END PKG_CITAS;
/

---------------------------------------------------------

CREATE OR REPLACE PACKAGE BODY PKG_CITAS
AS

    FUNCTION FN_TOTAL_CITAS

    RETURN NUMBER

    AS

        V_TOTAL NUMBER;

    BEGIN

        SELECT COUNT(*)

        INTO V_TOTAL

        FROM CITA;

        RETURN V_TOTAL;

    END;

    -----------------------------------------------------

    FUNCTION FN_TOTAL_CITAS_MEDICO(

        P_ID_MEDICO IN NUMBER

    )

    RETURN NUMBER

    AS

        V_TOTAL NUMBER;

    BEGIN

        SELECT COUNT(*)

        INTO V_TOTAL

        FROM CITA

        WHERE ID_MEDICO = P_ID_MEDICO;

        RETURN V_TOTAL;

    END;

END PKG_CITAS;
/

---------------------------------------------------------
-- PACKAGE DE CONSULTAS
---------------------------------------------------------

CREATE OR REPLACE PACKAGE PKG_CONSULTAS
AS

    FUNCTION FN_TOTAL_CONSULTAS_GENERAL
    RETURN NUMBER;

    FUNCTION FN_TOTAL_CONSULTAS(

        P_ID_PACIENTE IN NUMBER

    )

    RETURN NUMBER;

END PKG_CONSULTAS;
/

---------------------------------------------------------

CREATE OR REPLACE PACKAGE BODY PKG_CONSULTAS
AS

    FUNCTION FN_TOTAL_CONSULTAS_GENERAL

    RETURN NUMBER

    AS

        V_TOTAL NUMBER;

    BEGIN

        SELECT COUNT(*)

        INTO V_TOTAL

        FROM CONSULTA;

        RETURN V_TOTAL;

    END;

    -----------------------------------------------------

    FUNCTION FN_TOTAL_CONSULTAS(

        P_ID_PACIENTE IN NUMBER

    )

    RETURN NUMBER

    AS

        V_TOTAL NUMBER;

    BEGIN

        SELECT COUNT(*)

        INTO V_TOTAL

        FROM CONSULTA C

        INNER JOIN HISTORIAL_CLINICO H

        ON C.ID_HISTORIAL = H.ID_HISTORIAL

        WHERE H.ID_PACIENTE = P_ID_PACIENTE;

        RETURN V_TOTAL;

    END;

END PKG_CONSULTAS;
/

---------------------------------------------------------
-- PACKAGE DE FACTURACION
---------------------------------------------------------

CREATE OR REPLACE PACKAGE PKG_FACTURACION
AS

    FUNCTION FN_TOTAL_FACTURAS
    RETURN NUMBER;

    FUNCTION FN_TOTAL_FACTURA(

        P_ID_FACTURA IN NUMBER

    )

    RETURN NUMBER;

END PKG_FACTURACION;
/

---------------------------------------------------------

CREATE OR REPLACE PACKAGE BODY PKG_FACTURACION
AS

    FUNCTION FN_TOTAL_FACTURAS

    RETURN NUMBER

    AS

        V_TOTAL NUMBER;

    BEGIN

        SELECT COUNT(*)

        INTO V_TOTAL

        FROM FACTURA;

        RETURN V_TOTAL;

    END;

    -----------------------------------------------------

    FUNCTION FN_TOTAL_FACTURA(

        P_ID_FACTURA IN NUMBER

    )

    RETURN NUMBER

    AS

        V_TOTAL NUMBER;

    BEGIN

        SELECT TOTAL

        INTO V_TOTAL

        FROM FACTURA

        WHERE ID_FACTURA = P_ID_FACTURA;

        RETURN V_TOTAL;

    END;

END PKG_FACTURACION;
/

---------------------------------------------------------
-- PACKAGE DE ESTADISTICAS
---------------------------------------------------------

CREATE OR REPLACE PACKAGE PKG_ESTADISTICAS
AS

    FUNCTION FN_TOTAL_USUARIOS
    RETURN NUMBER;

    FUNCTION FN_TOTAL_MEDICOS_ESPECIALIDAD(

        P_ID_ESPECIALIDAD IN NUMBER

    )

    RETURN NUMBER;

    FUNCTION FN_TOTAL_MEDICAMENTOS
    RETURN NUMBER;

END PKG_ESTADISTICAS;
/

---------------------------------------------------------

CREATE OR REPLACE PACKAGE BODY PKG_ESTADISTICAS
AS

    FUNCTION FN_TOTAL_USUARIOS

    RETURN NUMBER

    AS

        V_TOTAL NUMBER;

    BEGIN

        SELECT COUNT(*)

        INTO V_TOTAL

        FROM USUARIO;

        RETURN V_TOTAL;

    END;

    -----------------------------------------------------

    FUNCTION FN_TOTAL_MEDICOS_ESPECIALIDAD(

        P_ID_ESPECIALIDAD IN NUMBER

    )

    RETURN NUMBER

    AS

        V_TOTAL NUMBER;

    BEGIN

        SELECT COUNT(*)

        INTO V_TOTAL

        FROM DOCTOR

        WHERE ID_ESPECIALIDAD = P_ID_ESPECIALIDAD;

        RETURN V_TOTAL;

    END;

    -----------------------------------------------------

    FUNCTION FN_TOTAL_MEDICAMENTOS

    RETURN NUMBER

    AS

        V_TOTAL NUMBER;

    BEGIN

        SELECT COUNT(*)

        INTO V_TOTAL

        FROM MEDICAMENTO;

        RETURN V_TOTAL;

    END;

END PKG_ESTADISTICAS;
/