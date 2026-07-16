/*
=========================================================
PRISMA
Sistema de Gestión y Consolidación de Información Clínica
SC-504 Lenguajes de Base de Datos

Archivo : 03_triggers.sql
Motor    : Oracle Database 23c Free
=========================================================
*/

---------------------------------------------------------
-- TRIGGER: ROL
---------------------------------------------------------

CREATE OR REPLACE TRIGGER TRG_ROL
BEFORE INSERT ON ROL
FOR EACH ROW
BEGIN
    IF :NEW.ID_ROL IS NULL THEN
        SELECT SEQ_ROL.NEXTVAL
        INTO :NEW.ID_ROL
        FROM DUAL;
    END IF;
END;
/

---------------------------------------------------------
-- TRIGGER: ESPECIALIDAD
---------------------------------------------------------

CREATE OR REPLACE TRIGGER TRG_ESPECIALIDAD
BEFORE INSERT ON ESPECIALIDAD
FOR EACH ROW
BEGIN
    IF :NEW.ID_ESPECIALIDAD IS NULL THEN
        SELECT SEQ_ESPECIALIDAD.NEXTVAL
        INTO :NEW.ID_ESPECIALIDAD
        FROM DUAL;
    END IF;
END;
/

---------------------------------------------------------
-- TRIGGER: CONSULTORIO
---------------------------------------------------------

CREATE OR REPLACE TRIGGER TRG_CONSULTORIO
BEFORE INSERT ON CONSULTORIO
FOR EACH ROW
BEGIN
    IF :NEW.ID_CONSULTORIO IS NULL THEN
        SELECT SEQ_CONSULTORIO.NEXTVAL
        INTO :NEW.ID_CONSULTORIO
        FROM DUAL;
    END IF;
END;
/

---------------------------------------------------------
-- TRIGGER: MEDICAMENTO
---------------------------------------------------------

CREATE OR REPLACE TRIGGER TRG_MEDICAMENTO
BEFORE INSERT ON MEDICAMENTO
FOR EACH ROW
BEGIN
    IF :NEW.ID_MEDICAMENTO IS NULL THEN
        SELECT SEQ_MEDICAMENTO.NEXTVAL
        INTO :NEW.ID_MEDICAMENTO
        FROM DUAL;
    END IF;
END;
/

---------------------------------------------------------
-- TRIGGER: USUARIO
---------------------------------------------------------

CREATE OR REPLACE TRIGGER TRG_USUARIO
BEFORE INSERT ON USUARIO
FOR EACH ROW
BEGIN
    IF :NEW.ID_USUARIO IS NULL THEN
        SELECT SEQ_USUARIO.NEXTVAL
        INTO :NEW.ID_USUARIO
        FROM DUAL;
    END IF;
END;
/

---------------------------------------------------------
-- TRIGGER: DOCTOR
---------------------------------------------------------

CREATE OR REPLACE TRIGGER TRG_DOCTOR
BEFORE INSERT ON DOCTOR
FOR EACH ROW
BEGIN
    IF :NEW.ID_MEDICO IS NULL THEN
        SELECT SEQ_DOCTOR.NEXTVAL
        INTO :NEW.ID_MEDICO
        FROM DUAL;
    END IF;
END;
/

---------------------------------------------------------
-- TRIGGER: PACIENTE
---------------------------------------------------------

CREATE OR REPLACE TRIGGER TRG_PACIENTE
BEFORE INSERT ON PACIENTE
FOR EACH ROW
BEGIN
    IF :NEW.ID_PACIENTE IS NULL THEN
        SELECT SEQ_PACIENTE.NEXTVAL
        INTO :NEW.ID_PACIENTE
        FROM DUAL;
    END IF;
END;
/

---------------------------------------------------------
-- TRIGGER: HISTORIAL_CLINICO
---------------------------------------------------------

CREATE OR REPLACE TRIGGER TRG_HISTORIAL_CLINICO
BEFORE INSERT ON HISTORIAL_CLINICO
FOR EACH ROW
BEGIN
    IF :NEW.ID_HISTORIAL IS NULL THEN
        SELECT SEQ_HISTORIAL_CLINICO.NEXTVAL
        INTO :NEW.ID_HISTORIAL
        FROM DUAL;
    END IF;
END;
/

---------------------------------------------------------
-- TRIGGER: HORARIO_MEDICO
---------------------------------------------------------

CREATE OR REPLACE TRIGGER TRG_HORARIO_MEDICO
BEFORE INSERT ON HORARIO_MEDICO
FOR EACH ROW
BEGIN
    IF :NEW.ID_HORARIO IS NULL THEN
        SELECT SEQ_HORARIO_MEDICO.NEXTVAL
        INTO :NEW.ID_HORARIO
        FROM DUAL;
    END IF;
END;
/

---------------------------------------------------------
-- TRIGGER: CITA
---------------------------------------------------------

CREATE OR REPLACE TRIGGER TRG_CITA
BEFORE INSERT ON CITA
FOR EACH ROW
BEGIN
    IF :NEW.ID_CITA IS NULL THEN
        SELECT SEQ_CITA.NEXTVAL
        INTO :NEW.ID_CITA
        FROM DUAL;
    END IF;
END;
/

---------------------------------------------------------
-- TRIGGER: CONSULTA
---------------------------------------------------------

CREATE OR REPLACE TRIGGER TRG_CONSULTA
BEFORE INSERT ON CONSULTA
FOR EACH ROW
BEGIN
    IF :NEW.ID_CONSULTA IS NULL THEN
        SELECT SEQ_CONSULTA.NEXTVAL
        INTO :NEW.ID_CONSULTA
        FROM DUAL;
    END IF;
END;
/

---------------------------------------------------------
-- TRIGGER: DIAGNOSTICO
---------------------------------------------------------

CREATE OR REPLACE TRIGGER TRG_DIAGNOSTICO
BEFORE INSERT ON DIAGNOSTICO
FOR EACH ROW
BEGIN
    IF :NEW.ID_DIAGNOSTICO IS NULL THEN
        SELECT SEQ_DIAGNOSTICO.NEXTVAL
        INTO :NEW.ID_DIAGNOSTICO
        FROM DUAL;
    END IF;
END;
/

---------------------------------------------------------
-- TRIGGER: RECETA
---------------------------------------------------------

CREATE OR REPLACE TRIGGER TRG_RECETA
BEFORE INSERT ON RECETA
FOR EACH ROW
BEGIN
    IF :NEW.ID_RECETA IS NULL THEN
        SELECT SEQ_RECETA.NEXTVAL
        INTO :NEW.ID_RECETA
        FROM DUAL;
    END IF;
END;
/

---------------------------------------------------------
-- TRIGGER: DETALLE_RECETA
---------------------------------------------------------

CREATE OR REPLACE TRIGGER TRG_DETALLE_RECETA
BEFORE INSERT ON DETALLE_RECETA
FOR EACH ROW
BEGIN
    IF :NEW.ID_DETALLE IS NULL THEN
        SELECT SEQ_DETALLE_RECETA.NEXTVAL
        INTO :NEW.ID_DETALLE
        FROM DUAL;
    END IF;
END;
/

---------------------------------------------------------
-- TRIGGER: TRATAMIENTO
---------------------------------------------------------

CREATE OR REPLACE TRIGGER TRG_TRATAMIENTO
BEFORE INSERT ON TRATAMIENTO
FOR EACH ROW
BEGIN
    IF :NEW.ID_TRATAMIENTO IS NULL THEN
        SELECT SEQ_TRATAMIENTO.NEXTVAL
        INTO :NEW.ID_TRATAMIENTO
        FROM DUAL;
    END IF;
END;
/

---------------------------------------------------------
-- TRIGGER: ALERGIA
---------------------------------------------------------

CREATE OR REPLACE TRIGGER TRG_ALERGIA
BEFORE INSERT ON ALERGIA
FOR EACH ROW
BEGIN
    IF :NEW.ID_ALERGIA IS NULL THEN
        SELECT SEQ_ALERGIA.NEXTVAL
        INTO :NEW.ID_ALERGIA
        FROM DUAL;
    END IF;
END;
/

---------------------------------------------------------
-- TRIGGER: ANTECEDENTE_MEDICO
---------------------------------------------------------

CREATE OR REPLACE TRIGGER TRG_ANTECEDENTE_MEDICO
BEFORE INSERT ON ANTECEDENTE_MEDICO
FOR EACH ROW
BEGIN
    IF :NEW.ID_ANTECEDENTE IS NULL THEN
        SELECT SEQ_ANTECEDENTE_MEDICO.NEXTVAL
        INTO :NEW.ID_ANTECEDENTE
        FROM DUAL;
    END IF;
END;
/

---------------------------------------------------------
-- TRIGGER: INDICADOR_SALUD
---------------------------------------------------------

CREATE OR REPLACE TRIGGER TRG_INDICADOR_SALUD
BEFORE INSERT ON INDICADOR_SALUD
FOR EACH ROW
BEGIN
    IF :NEW.ID_INDICADOR IS NULL THEN
        SELECT SEQ_INDICADOR_SALUD.NEXTVAL
        INTO :NEW.ID_INDICADOR
        FROM DUAL;
    END IF;
END;
/

---------------------------------------------------------
-- TRIGGER: SEGURO_MEDICO
---------------------------------------------------------

CREATE OR REPLACE TRIGGER TRG_SEGURO_MEDICO
BEFORE INSERT ON SEGURO_MEDICO
FOR EACH ROW
BEGIN
    IF :NEW.ID_SEGURO IS NULL THEN
        SELECT SEQ_SEGURO_MEDICO.NEXTVAL
        INTO :NEW.ID_SEGURO
        FROM DUAL;
    END IF;
END;
/

---------------------------------------------------------
-- TRIGGER: FACTURA
---------------------------------------------------------

CREATE OR REPLACE TRIGGER TRG_FACTURA
BEFORE INSERT ON FACTURA
FOR EACH ROW
BEGIN
    IF :NEW.ID_FACTURA IS NULL THEN
        SELECT SEQ_FACTURA.NEXTVAL
        INTO :NEW.ID_FACTURA
        FROM DUAL;
    END IF;
END;
/

---------------------------------------------------------
-- TRIGGER: PAGO
---------------------------------------------------------

CREATE OR REPLACE TRIGGER TRG_PAGO
BEFORE INSERT ON PAGO
FOR EACH ROW
BEGIN
    IF :NEW.ID_PAGO IS NULL THEN
        SELECT SEQ_PAGO.NEXTVAL
        INTO :NEW.ID_PAGO
        FROM DUAL;
    END IF;
END;
/

---------------------------------------------------------
-- TRIGGER: AUDITORIA
---------------------------------------------------------

CREATE OR REPLACE TRIGGER TRG_AUDITORIA
BEFORE INSERT ON AUDITORIA
FOR EACH ROW
BEGIN
    IF :NEW.ID_AUDITORIA IS NULL THEN
        SELECT SEQ_AUDITORIA.NEXTVAL
        INTO :NEW.ID_AUDITORIA
        FROM DUAL;
    END IF;
END;
/

