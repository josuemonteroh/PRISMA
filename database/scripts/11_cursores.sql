/*
PRISMA
Sistema de Gestión y Consolidación de Información Clínica
SC-504 Lenguajes de Base de Datos

Archivo : 11_cursores.sql
Motor    : Oracle Database 23c Free
Contenido: Procedimientos con CURSORES EXPLÍCITOS PL/SQL
           (no SYS_REFCURSOR). 
*/

SET SERVEROUTPUT ON;

---------------------------------------------------------
-- 1. DÍAS RESTANTES DE TRATAMIENTOS ACTIVOS
-- Recorre los tratamientos vigentes y calcula cuántos días
-- le quedan a cada paciente, mostrando el resultado.
---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_CUR_DIAS_RESTANTES_TRATAMIENTOS
AS
    CURSOR C_TRATAMIENTOS IS
        SELECT
            T.ID_TRATAMIENTO,
            P.NOMBRE || ' ' || P.APELLIDO AS PACIENTE,
            T.FECHA_INICIO,
            T.DURACION_DIAS,
            (T.FECHA_INICIO + T.DURACION_DIAS) - TRUNC(SYSDATE) AS DIAS_RESTANTES
        FROM TRATAMIENTO T
        INNER JOIN CONSULTA C   ON T.ID_CONSULTA = C.ID_CONSULTA
        INNER JOIN HISTORIAL_CLINICO H ON C.ID_HISTORIAL = H.ID_HISTORIAL
        INNER JOIN PACIENTE P   ON H.ID_PACIENTE = P.ID_PACIENTE
        WHERE (T.FECHA_INICIO + T.DURACION_DIAS) >= TRUNC(SYSDATE);

    V_FILA C_TRATAMIENTOS%ROWTYPE;

BEGIN

    OPEN C_TRATAMIENTOS;

    LOOP
        FETCH C_TRATAMIENTOS INTO V_FILA;
        EXIT WHEN C_TRATAMIENTOS%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            'Tratamiento #' || V_FILA.ID_TRATAMIENTO ||
            ' - Paciente: ' || V_FILA.PACIENTE ||
            ' - Días restantes: ' || V_FILA.DIAS_RESTANTES
        );
    END LOOP;

    CLOSE C_TRATAMIENTOS;

END;
/

---------------------------------------------------------
-- 2. VENCER FACTURAS PENDIENTES CON MÁS DE 30 DÍAS
-- Recorre facturas pendientes de pago vencidas y las anula
-- automáticamente. Demuestra cursor con actualización real.
---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_CUR_ANULAR_FACTURAS_VENCIDAS
AS
    CURSOR C_FACTURAS IS
        SELECT ID_FACTURA
        FROM FACTURA
        WHERE ESTADO = 'PENDIENTE'
          AND FECHA < TRUNC(SYSDATE) - 30
        FOR UPDATE OF ESTADO;

    V_TOTAL_ANULADAS NUMBER := 0;

BEGIN

    FOR V_FACTURA IN C_FACTURAS LOOP

        UPDATE FACTURA
           SET ESTADO = 'ANULADA'
         WHERE CURRENT OF C_FACTURAS;

        V_TOTAL_ANULADAS := V_TOTAL_ANULADAS + 1;

    END LOOP;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Facturas anuladas por vencimiento: ' || V_TOTAL_ANULADAS);

END;
/

---------------------------------------------------------
-- 3. PACIENTES SIN HISTORIAL CLÍNICO
-- Recorre pacientes que aún no tienen historial y les crea
-- uno vacío automáticamente (regla de negocio real).
---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_CUR_CREAR_HISTORIALES_FALTANTES
AS
    CURSOR C_SIN_HISTORIAL IS
        SELECT P.ID_PACIENTE
        FROM PACIENTE P
        WHERE NOT EXISTS (
            SELECT 1
            FROM HISTORIAL_CLINICO H
            WHERE H.ID_PACIENTE = P.ID_PACIENTE
        );

    V_CREADOS NUMBER := 0;

BEGIN

    FOR V_PACIENTE IN C_SIN_HISTORIAL LOOP

        INSERT INTO HISTORIAL_CLINICO (
            ID_HISTORIAL,
            ID_PACIENTE,
            FECHA_CREACION,
            OBSERVACIONES_GENERALES
        )
        VALUES (
            NULL,
            V_PACIENTE.ID_PACIENTE,
            TRUNC(SYSDATE),
            'Historial generado automáticamente.'
        );

        V_CREADOS := V_CREADOS + 1;

    END LOOP;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Historiales clínicos creados: ' || V_CREADOS);

END;
/

---------------------------------------------------------
-- 4. REPORTE DE ALERGIAS GRAVES POR PACIENTE
-- Recorre alergias severas y las imprime agrupadas por
-- paciente, usando un cursor con parámetro.
---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_CUR_ALERGIAS_GRAVES(
    P_SEVERIDAD IN VARCHAR2 DEFAULT 'GRAVE'
)
AS
    CURSOR C_ALERGIAS(P_SEV VARCHAR2) IS
        SELECT
            P.NOMBRE || ' ' || P.APELLIDO AS PACIENTE,
            A.NOMBRE_ALERGIA,
            A.TIPO
        FROM ALERGIA A
        INNER JOIN PACIENTE P ON A.ID_PACIENTE = P.ID_PACIENTE
        WHERE A.SEVERIDAD = P_SEV
        ORDER BY PACIENTE;

BEGIN

    FOR V_FILA IN C_ALERGIAS(P_SEVERIDAD) LOOP

        DBMS_OUTPUT.PUT_LINE(
            V_FILA.PACIENTE || ' -> ' ||
            V_FILA.NOMBRE_ALERGIA || ' (' || V_FILA.TIPO || ')'
        );

    END LOOP;

END;
/

---------------------------------------------------------
-- 5. MÉDICOS SIN HORARIO ASIGNADO
-- Recorre médicos que no tienen ningún horario configurado,
-- para alertar de una inconsistencia operativa.
---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_CUR_MEDICOS_SIN_HORARIO
AS
    CURSOR C_MEDICOS IS
        SELECT D.ID_MEDICO, D.NOMBRE, D.APELLIDO
        FROM DOCTOR D
        WHERE NOT EXISTS (
            SELECT 1
            FROM HORARIO_MEDICO HM
            WHERE HM.ID_MEDICO = D.ID_MEDICO
        );

    V_TOTAL NUMBER := 0;

BEGIN

    FOR V_MEDICO IN C_MEDICOS LOOP

        DBMS_OUTPUT.PUT_LINE(
            'Sin horario: Dr(a). ' || V_MEDICO.NOMBRE || ' ' || V_MEDICO.APELLIDO
        );

        V_TOTAL := V_TOTAL + 1;

    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Total de médicos sin horario: ' || V_TOTAL);

END;
/

---------------------------------------------------------
-- 6. DESACTIVAR USUARIOS INACTIVOS Y REGISTRAR AUDITORÍA
-- Recorre usuarios en estado INACTIVO y deja constancia en
-- AUDITORIA de la revisión (cursor + INSERT dentro del loop).
---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_CUR_AUDITAR_USUARIOS_INACTIVOS
AS
    CURSOR C_USUARIOS IS
        SELECT ID_USUARIO
        FROM USUARIO
        WHERE ESTADO = 'INACTIVO';

    V_TOTAL NUMBER := 0;

BEGIN

    FOR V_USUARIO IN C_USUARIOS LOOP

        INSERT INTO AUDITORIA (
            ID_AUDITORIA,
            ID_USUARIO,
            TABLA_AFECTADA,
            ACCION,
            FECHA
        )
        VALUES (
            NULL,
            V_USUARIO.ID_USUARIO,
            'USUARIO',
            'LOGIN',
            CURRENT_TIMESTAMP
        );

        V_TOTAL := V_TOTAL + 1;

    END LOOP;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Usuarios inactivos auditados: ' || V_TOTAL);

END;
/

---------------------------------------------------------
-- 7. INDICADORES DE SALUD FUERA DE RANGO NORMAL
-- Recorre indicadores de tipo 'Presion Arterial' fuera de
-- rango normal (90-120) y los reporta por paciente.
---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_CUR_INDICADORES_FUERA_RANGO
AS
    CURSOR C_INDICADORES IS
        SELECT
            P.NOMBRE || ' ' || P.APELLIDO AS PACIENTE,
            I.TIPO_INDICADOR,
            I.VALOR,
            I.UNIDAD_MEDIDA,
            I.FECHA_REGISTRO
        FROM INDICADOR_SALUD I
        INNER JOIN PACIENTE P ON I.ID_PACIENTE = P.ID_PACIENTE
        WHERE UPPER(I.TIPO_INDICADOR) LIKE '%PRESION%'
          AND (I.VALOR < 90 OR I.VALOR > 120);

    V_TOTAL NUMBER := 0;

BEGIN

    FOR V_FILA IN C_INDICADORES LOOP

        DBMS_OUTPUT.PUT_LINE(
            V_FILA.PACIENTE || ' - ' || V_FILA.TIPO_INDICADOR ||
            ': ' || V_FILA.VALOR || ' ' || V_FILA.UNIDAD_MEDIDA ||
            ' (FUERA DE RANGO)'
        );

        V_TOTAL := V_TOTAL + 1;

    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Indicadores fuera de rango encontrados: ' || V_TOTAL);

END;
/

---------------------------------------------------------
-- 8. SALDO PENDIENTE POR FACTURA
-- Recorre facturas y, para cada una, suma los pagos ya
-- realizados (cursor anidado) para calcular el saldo.
---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_CUR_SALDO_PENDIENTE_FACTURAS
AS
    CURSOR C_FACTURAS IS
        SELECT ID_FACTURA, TOTAL
        FROM FACTURA
        WHERE ESTADO != 'ANULADA';

    CURSOR C_PAGOS(P_ID_FACTURA NUMBER) IS
        SELECT MONTO
        FROM PAGO
        WHERE ID_FACTURA = P_ID_FACTURA;

    V_PAGADO NUMBER;
    V_SALDO  NUMBER;

BEGIN

    FOR V_FACTURA IN C_FACTURAS LOOP

        V_PAGADO := 0;

        FOR V_PAGO IN C_PAGOS(V_FACTURA.ID_FACTURA) LOOP
            V_PAGADO := V_PAGADO + V_PAGO.MONTO;
        END LOOP;

        V_SALDO := V_FACTURA.TOTAL - V_PAGADO;

        IF V_SALDO > 0 THEN
            DBMS_OUTPUT.PUT_LINE(
                'Factura #' || V_FACTURA.ID_FACTURA ||
                ' - Saldo pendiente: ' || V_SALDO
            );
        END IF;

    END LOOP;

END;
/