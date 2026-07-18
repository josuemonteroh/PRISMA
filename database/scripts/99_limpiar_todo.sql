-- Este script borra TODO lo que exista del esquema PRISMA
-- (tablas, secuencias, vistas, procedimientos, funciones, paquetes)
-- para poder volver a cargar los scripts 01-08 desde cero, sin
-- choques con objetos que hayan quedado a medias.

SET SQLBLANKLINES ON
SET DEFINE OFF
SET SERVEROUTPUT ON

BEGIN
    FOR obj IN (SELECT object_name, object_type
                FROM user_objects
                WHERE object_type IN ('TABLE','VIEW','SEQUENCE','PROCEDURE','FUNCTION','PACKAGE','PACKAGE BODY','TRIGGER'))
    LOOP
        BEGIN
            IF obj.object_type = 'TABLE' THEN
                EXECUTE IMMEDIATE 'DROP TABLE "' || obj.object_name || '" CASCADE CONSTRAINTS PURGE';
            ELSE
                EXECUTE IMMEDIATE 'DROP ' || obj.object_type || ' "' || obj.object_name || '"';
            END IF;
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('No se pudo borrar ' || obj.object_type || ' ' || obj.object_name || ': ' || SQLERRM);
        END;
    END LOOP;
END;
/

EXIT;
