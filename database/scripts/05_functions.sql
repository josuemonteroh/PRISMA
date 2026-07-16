/*
PRISMA
Sistema de Gestión y Consolidación de Información Clínica
SC-504 Lenguajes de Base de Datos

Archivo : 05_functions.sql
Motor    : Oracle Database 23c Free
*/

---------------------------------------------------------
-- EDAD DEL PACIENTE
---------------------------------------------------------

CREATE OR REPLACE FUNCTION FN_EDAD_PACIENTE(

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
/

---------------------------------------------------------
-- TOTAL DE CONSULTAS DEL PACIENTE
---------------------------------------------------------

CREATE OR REPLACE FUNCTION FN_TOTAL_CONSULTAS(

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
/

---------------------------------------------------------
-- TOTAL DE CITAS DEL MÉDICO
---------------------------------------------------------

CREATE OR REPLACE FUNCTION FN_TOTAL_CITAS_MEDICO(

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
/

---------------------------------------------------------
-- TOTAL FACTURADO
---------------------------------------------------------

CREATE OR REPLACE FUNCTION FN_TOTAL_FACTURA(

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
/

---------------------------------------------------------
-- TOTAL DE ALERGIAS
---------------------------------------------------------

CREATE OR REPLACE FUNCTION FN_TOTAL_ALERGIAS(

    P_ID_PACIENTE IN NUMBER

)

RETURN NUMBER

AS

    V_TOTAL NUMBER;

BEGIN

    SELECT COUNT(*)

    INTO V_TOTAL

    FROM ALERGIA

    WHERE ID_PACIENTE = P_ID_PACIENTE;

    RETURN V_TOTAL;

END;
/

---------------------------------------------------------
-- TOTAL DE TRATAMIENTOS DE UNA CONSULTA
---------------------------------------------------------

CREATE OR REPLACE FUNCTION FN_TOTAL_TRATAMIENTOS(

    P_ID_CONSULTA IN NUMBER

)

RETURN NUMBER

AS

    V_TOTAL NUMBER;

BEGIN

    SELECT COUNT(*)

    INTO V_TOTAL

    FROM TRATAMIENTO

    WHERE ID_CONSULTA = P_ID_CONSULTA;

    RETURN V_TOTAL;

END;
/

---------------------------------------------------------
-- TOTAL DE PAGOS DE UNA FACTURA
---------------------------------------------------------

CREATE OR REPLACE FUNCTION FN_TOTAL_PAGOS_FACTURA(

    P_ID_FACTURA IN NUMBER

)

RETURN NUMBER

AS

    V_TOTAL NUMBER;

BEGIN

    SELECT COUNT(*)

    INTO V_TOTAL

    FROM PAGO

    WHERE ID_FACTURA = P_ID_FACTURA;

    RETURN V_TOTAL;

END;
/

---------------------------------------------------------
-- TOTAL DE MEDICAMENTOS DE UNA RECETA
---------------------------------------------------------

CREATE OR REPLACE FUNCTION FN_TOTAL_MEDICAMENTOS_RECETA(

    P_ID_RECETA IN NUMBER

)

RETURN NUMBER

AS

    V_TOTAL NUMBER;

BEGIN

    SELECT COUNT(*)

    INTO V_TOTAL

    FROM DETALLE_RECETA

    WHERE ID_RECETA = P_ID_RECETA;

    RETURN V_TOTAL;

END;
/

---------------------------------------------------------
-- TOTAL DE MÉDICOS POR ESPECIALIDAD
---------------------------------------------------------

CREATE OR REPLACE FUNCTION FN_TOTAL_MEDICOS_ESPECIALIDAD(

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
/

---------------------------------------------------------
-- TOTAL DE PACIENTES
---------------------------------------------------------

CREATE OR REPLACE FUNCTION FN_TOTAL_PACIENTES

RETURN NUMBER

AS

    V_TOTAL NUMBER;

BEGIN

    SELECT COUNT(*)

    INTO V_TOTAL

    FROM PACIENTE;

    RETURN V_TOTAL;

END;
/

---------------------------------------------------------
-- TOTAL DE USUARIOS
---------------------------------------------------------

CREATE OR REPLACE FUNCTION FN_TOTAL_USUARIOS

RETURN NUMBER

AS

    V_TOTAL NUMBER;

BEGIN

    SELECT COUNT(*)

    INTO V_TOTAL

    FROM USUARIO;

    RETURN V_TOTAL;

END;
/

---------------------------------------------------------
-- TOTAL DE CONSULTAS
---------------------------------------------------------

CREATE OR REPLACE FUNCTION FN_TOTAL_CONSULTAS_GENERAL

RETURN NUMBER

AS

    V_TOTAL NUMBER;

BEGIN

    SELECT COUNT(*)

    INTO V_TOTAL

    FROM CONSULTA;

    RETURN V_TOTAL;

END;
/

---------------------------------------------------------
-- TOTAL DE CITAS
---------------------------------------------------------

CREATE OR REPLACE FUNCTION FN_TOTAL_CITAS

RETURN NUMBER

AS

    V_TOTAL NUMBER;

BEGIN

    SELECT COUNT(*)

    INTO V_TOTAL

    FROM CITA;

    RETURN V_TOTAL;

END;
/

---------------------------------------------------------
-- TOTAL DE FACTURAS
---------------------------------------------------------

CREATE OR REPLACE FUNCTION FN_TOTAL_FACTURAS

RETURN NUMBER

AS

    V_TOTAL NUMBER;

BEGIN

    SELECT COUNT(*)

    INTO V_TOTAL

    FROM FACTURA;

    RETURN V_TOTAL;

END;
/

---------------------------------------------------------
-- TOTAL DE MEDICAMENTOS
---------------------------------------------------------

CREATE OR REPLACE FUNCTION FN_TOTAL_MEDICAMENTOS

RETURN NUMBER

AS

    V_TOTAL NUMBER;

BEGIN

    SELECT COUNT(*)

    INTO V_TOTAL

    FROM MEDICAMENTO;

    RETURN V_TOTAL;

END;
/

---------------------------------------------------------
-- TOTAL DE ESPECIALIDADES
---------------------------------------------------------

CREATE OR REPLACE FUNCTION FN_TOTAL_ESPECIALIDADES

RETURN NUMBER

AS

    V_TOTAL NUMBER;

BEGIN

    SELECT COUNT(*)

    INTO V_TOTAL

    FROM ESPECIALIDAD;

    RETURN V_TOTAL;

END;
/

---------------------------------------------------------
-- TOTAL DE CONSULTORIOS
---------------------------------------------------------

CREATE OR REPLACE FUNCTION FN_TOTAL_CONSULTORIOS

RETURN NUMBER

AS

    V_TOTAL NUMBER;

BEGIN

    SELECT COUNT(*)

    INTO V_TOTAL

    FROM CONSULTORIO;

    RETURN V_TOTAL;

END;
/

---------------------------------------------------------
-- TOTAL DE HISTORIALES CLÍNICOS
---------------------------------------------------------

CREATE OR REPLACE FUNCTION FN_TOTAL_HISTORIALES

RETURN NUMBER

AS

    V_TOTAL NUMBER;

BEGIN

    SELECT COUNT(*)

    INTO V_TOTAL

    FROM HISTORIAL_CLINICO;

    RETURN V_TOTAL;

END;
/

