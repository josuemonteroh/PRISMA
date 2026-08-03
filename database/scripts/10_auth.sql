/*
PRISMA
Sistema de Gestión y Consolidación de Información Clínica
SC-504 Lenguajes de Base de Datos

Archivo : 10_auth.sql
Motor    : Oracle Database 23c Free
Contenido: Procedimiento de autenticación (evita SQL directo en login.php)
*/

---------------------------------------------------------
-- BUSCAR USUARIO ACTIVO POR NOMBRE DE USUARIO (LOGIN)
---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_LOGIN_USUARIO(

    P_NOMBRE_USUARIO IN VARCHAR2,
    P_CURSOR OUT SYS_REFCURSOR

)
AS
BEGIN

    OPEN P_CURSOR FOR
        SELECT
            ID_USUARIO,
            ID_ROL,
            NOMBRE_USUARIO,
            CONTRASENA_HASH
        FROM USUARIO
        WHERE UPPER(NOMBRE_USUARIO) = UPPER(P_NOMBRE_USUARIO)
        AND ESTADO = 'ACTIVO';

END;
/
