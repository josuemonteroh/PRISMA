/*
PRISMA
Sistema de Gestión y Consolidación de Información Clínica
SC-504 Lenguajes de Base de Datos

Archivo : 04_procedures.sql
Motor    : Oracle Database 23c Free
*/

---------------------------------------------------------
-- ROL
---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_INSERTAR_ROL(

    P_NOMBRE_ROL      IN VARCHAR2,
    P_DESCRIPCION     IN VARCHAR2

)
AS
BEGIN

    INSERT INTO ROL(

        ID_ROL,
        NOMBRE_ROL,
        DESCRIPCION

    )

    VALUES(

        NULL,
        P_NOMBRE_ROL,
        P_DESCRIPCION

    );

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_ACTUALIZAR_ROL(

    P_ID_ROL          IN NUMBER,
    P_NOMBRE_ROL      IN VARCHAR2,
    P_DESCRIPCION     IN VARCHAR2

)
AS
BEGIN

    UPDATE ROL

    SET

        NOMBRE_ROL = P_NOMBRE_ROL,
        DESCRIPCION = P_DESCRIPCION

    WHERE ID_ROL = P_ID_ROL;

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_ELIMINAR_ROL(

    P_ID_ROL IN NUMBER

)
AS
BEGIN

    DELETE FROM ROL

    WHERE ID_ROL = P_ID_ROL;

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_LISTAR_ROL(

    P_CURSOR OUT SYS_REFCURSOR

)
AS
BEGIN

    OPEN P_CURSOR FOR

        SELECT *

        FROM ROL

        ORDER BY ID_ROL;

END;
/

---------------------------------------------------------
-- ESPECIALIDAD
---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_INSERTAR_ESPECIALIDAD(

    P_NOMBRE          IN VARCHAR2,
    P_DESCRIPCION     IN VARCHAR2

)
AS
BEGIN

    INSERT INTO ESPECIALIDAD(

        ID_ESPECIALIDAD,
        NOMBRE_ESPECIALIDAD,
        DESCRIPCION

    )

    VALUES(

        NULL,
        P_NOMBRE,
        P_DESCRIPCION

    );

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_ACTUALIZAR_ESPECIALIDAD(

    P_ID              IN NUMBER,
    P_NOMBRE          IN VARCHAR2,
    P_DESCRIPCION     IN VARCHAR2

)
AS
BEGIN

    UPDATE ESPECIALIDAD

       SET NOMBRE_ESPECIALIDAD = P_NOMBRE,
           DESCRIPCION = P_DESCRIPCION

     WHERE ID_ESPECIALIDAD = P_ID;

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_ELIMINAR_ESPECIALIDAD(

    P_ID IN NUMBER

)
AS
BEGIN

    DELETE FROM ESPECIALIDAD

    WHERE ID_ESPECIALIDAD = P_ID;

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_LISTAR_ESPECIALIDAD(

    P_CURSOR OUT SYS_REFCURSOR

)
AS
BEGIN

    OPEN P_CURSOR FOR

        SELECT *

        FROM ESPECIALIDAD

        ORDER BY ID_ESPECIALIDAD;

END;
/

---------------------------------------------------------
-- CONSULTORIO
---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_INSERTAR_CONSULTORIO(

    P_NOMBRE        IN VARCHAR2,
    P_UBICACION     IN VARCHAR2,
    P_PISO          IN NUMBER

)
AS
BEGIN

    INSERT INTO CONSULTORIO(

        ID_CONSULTORIO,
        NOMBRE,
        UBICACION,
        PISO

    )

    VALUES(

        NULL,
        P_NOMBRE,
        P_UBICACION,
        P_PISO

    );

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_ACTUALIZAR_CONSULTORIO(

    P_ID            IN NUMBER,
    P_NOMBRE        IN VARCHAR2,
    P_UBICACION     IN VARCHAR2,
    P_PISO          IN NUMBER

)
AS
BEGIN

    UPDATE CONSULTORIO

    SET

        NOMBRE = P_NOMBRE,
        UBICACION = P_UBICACION,
        PISO = P_PISO

    WHERE ID_CONSULTORIO = P_ID;

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_ELIMINAR_CONSULTORIO(

    P_ID IN NUMBER

)
AS
BEGIN

    DELETE FROM CONSULTORIO

    WHERE ID_CONSULTORIO = P_ID;

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_LISTAR_CONSULTORIO(

    P_CURSOR OUT SYS_REFCURSOR

)
AS
BEGIN

    OPEN P_CURSOR FOR

        SELECT *

        FROM CONSULTORIO

        ORDER BY ID_CONSULTORIO;

END;
/

---------------------------------------------------------
-- MEDICAMENTO
---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_INSERTAR_MEDICAMENTO(

    P_NOMBRE            IN VARCHAR2,
    P_DESCRIPCION       IN VARCHAR2,
    P_PRESENTACION      IN VARCHAR2,
    P_CONCENTRACION     IN VARCHAR2

)
AS
BEGIN

    INSERT INTO MEDICAMENTO(

        ID_MEDICAMENTO,
        NOMBRE,
        DESCRIPCION,
        PRESENTACION,
        CONCENTRACION

    )

    VALUES(

        NULL,
        P_NOMBRE,
        P_DESCRIPCION,
        P_PRESENTACION,
        P_CONCENTRACION

    );

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_ACTUALIZAR_MEDICAMENTO(

    P_ID                IN NUMBER,
    P_NOMBRE            IN VARCHAR2,
    P_DESCRIPCION       IN VARCHAR2,
    P_PRESENTACION      IN VARCHAR2,
    P_CONCENTRACION     IN VARCHAR2

)
AS
BEGIN

    UPDATE MEDICAMENTO

    SET

        NOMBRE = P_NOMBRE,
        DESCRIPCION = P_DESCRIPCION,
        PRESENTACION = P_PRESENTACION,
        CONCENTRACION = P_CONCENTRACION

    WHERE ID_MEDICAMENTO = P_ID;

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_ELIMINAR_MEDICAMENTO(

    P_ID IN NUMBER

)
AS
BEGIN

    DELETE FROM MEDICAMENTO

    WHERE ID_MEDICAMENTO = P_ID;

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_LISTAR_MEDICAMENTO(

    P_CURSOR OUT SYS_REFCURSOR

)
AS
BEGIN

    OPEN P_CURSOR FOR

        SELECT *

        FROM MEDICAMENTO

        ORDER BY ID_MEDICAMENTO;

END;
/

---------------------------------------------------------
-- USUARIO
---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_INSERTAR_USUARIO(

    P_ID_ROL            IN NUMBER,
    P_NOMBRE_USUARIO    IN VARCHAR2,
    P_CONTRASENA_HASH   IN VARCHAR2,
    P_CORREO            IN VARCHAR2,
    P_ESTADO            IN VARCHAR2

)
AS
BEGIN

    INSERT INTO USUARIO(
        ID_USUARIO,
        ID_ROL,
        NOMBRE_USUARIO,
        CONTRASENA_HASH,
        CORREO,
        ESTADO
    )
    VALUES(
        NULL,
        P_ID_ROL,
        P_NOMBRE_USUARIO,
        P_CONTRASENA_HASH,
        P_CORREO,
        P_ESTADO
    );

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_ACTUALIZAR_USUARIO(

    P_ID_USUARIO        IN NUMBER,
    P_ID_ROL            IN NUMBER,
    P_NOMBRE_USUARIO    IN VARCHAR2,
    P_CONTRASENA_HASH   IN VARCHAR2,
    P_CORREO            IN VARCHAR2,
    P_ESTADO            IN VARCHAR2

)
AS
BEGIN

    UPDATE USUARIO
       SET ID_ROL = P_ID_ROL,
           NOMBRE_USUARIO = P_NOMBRE_USUARIO,
           CONTRASENA_HASH = P_CONTRASENA_HASH,
           CORREO = P_CORREO,
           ESTADO = P_ESTADO
     WHERE ID_USUARIO = P_ID_USUARIO;

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_ELIMINAR_USUARIO(

    P_ID_USUARIO IN NUMBER

)
AS
BEGIN

    DELETE FROM USUARIO
    WHERE ID_USUARIO = P_ID_USUARIO;

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_LISTAR_USUARIO(

    P_CURSOR OUT SYS_REFCURSOR

)
AS
BEGIN

    OPEN P_CURSOR FOR
        SELECT *
        FROM USUARIO
        ORDER BY ID_USUARIO;

END;
/

---------------------------------------------------------
-- DOCTOR
---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_INSERTAR_DOCTOR(

    P_ID_ESPECIALIDAD       IN NUMBER,
    P_NOMBRE                IN VARCHAR2,
    P_APELLIDO              IN VARCHAR2,
    P_TELEFONO              IN VARCHAR2,
    P_CORREO                IN VARCHAR2,
    P_NUMERO_COLEGIATURA    IN VARCHAR2

)
AS
BEGIN

    INSERT INTO DOCTOR(
        ID_MEDICO,
        ID_ESPECIALIDAD,
        NOMBRE,
        APELLIDO,
        TELEFONO,
        CORREO,
        NUMERO_COLEGIATURA
    )
    VALUES(
        NULL,
        P_ID_ESPECIALIDAD,
        P_NOMBRE,
        P_APELLIDO,
        P_TELEFONO,
        P_CORREO,
        P_NUMERO_COLEGIATURA
    );

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_ACTUALIZAR_DOCTOR(

    P_ID_MEDICO            IN NUMBER,
    P_ID_ESPECIALIDAD      IN NUMBER,
    P_NOMBRE               IN VARCHAR2,
    P_APELLIDO             IN VARCHAR2,
    P_TELEFONO             IN VARCHAR2,
    P_CORREO               IN VARCHAR2,
    P_NUMERO_COLEGIATURA   IN VARCHAR2

)
AS
BEGIN

    UPDATE DOCTOR
       SET ID_ESPECIALIDAD = P_ID_ESPECIALIDAD,
           NOMBRE = P_NOMBRE,
           APELLIDO = P_APELLIDO,
           TELEFONO = P_TELEFONO,
           CORREO = P_CORREO,
           NUMERO_COLEGIATURA = P_NUMERO_COLEGIATURA
     WHERE ID_MEDICO = P_ID_MEDICO;

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_ELIMINAR_DOCTOR(

    P_ID_MEDICO IN NUMBER

)
AS
BEGIN

    DELETE FROM DOCTOR
    WHERE ID_MEDICO = P_ID_MEDICO;

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_LISTAR_DOCTOR(

    P_CURSOR OUT SYS_REFCURSOR

)
AS
BEGIN

    OPEN P_CURSOR FOR
        SELECT *
        FROM DOCTOR
        ORDER BY ID_MEDICO;

END;
/

---------------------------------------------------------
-- PACIENTE
---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_INSERTAR_PACIENTE(

    P_NOMBRE               IN VARCHAR2,
    P_APELLIDO             IN VARCHAR2,
    P_FECHA_NACIMIENTO     IN DATE,
    P_SEXO                 IN CHAR,
    P_TELEFONO             IN VARCHAR2,
    P_CORREO               IN VARCHAR2,
    P_DIRECCION            IN VARCHAR2,
    P_CEDULA               IN VARCHAR2

)
AS
BEGIN

    INSERT INTO PACIENTE(
        ID_PACIENTE,
        NOMBRE,
        APELLIDO,
        FECHA_NACIMIENTO,
        SEXO,
        TELEFONO,
        CORREO,
        DIRECCION,
        CEDULA
    )
    VALUES(
        NULL,
        P_NOMBRE,
        P_APELLIDO,
        P_FECHA_NACIMIENTO,
        P_SEXO,
        P_TELEFONO,
        P_CORREO,
        P_DIRECCION,
        P_CEDULA
    );

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_ACTUALIZAR_PACIENTE(

    P_ID_PACIENTE          IN NUMBER,
    P_NOMBRE               IN VARCHAR2,
    P_APELLIDO             IN VARCHAR2,
    P_FECHA_NACIMIENTO     IN DATE,
    P_SEXO                 IN CHAR,
    P_TELEFONO             IN VARCHAR2,
    P_CORREO               IN VARCHAR2,
    P_DIRECCION            IN VARCHAR2,
    P_CEDULA               IN VARCHAR2

)
AS
BEGIN

    UPDATE PACIENTE
       SET NOMBRE = P_NOMBRE,
           APELLIDO = P_APELLIDO,
           FECHA_NACIMIENTO = P_FECHA_NACIMIENTO,
           SEXO = P_SEXO,
           TELEFONO = P_TELEFONO,
           CORREO = P_CORREO,
           DIRECCION = P_DIRECCION,
           CEDULA = P_CEDULA
     WHERE ID_PACIENTE = P_ID_PACIENTE;

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_ELIMINAR_PACIENTE(

    P_ID_PACIENTE IN NUMBER

)
AS
BEGIN

    DELETE FROM PACIENTE
    WHERE ID_PACIENTE = P_ID_PACIENTE;

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_LISTAR_PACIENTE(

    P_CURSOR OUT SYS_REFCURSOR

)
AS
BEGIN

    OPEN P_CURSOR FOR
        SELECT *
        FROM PACIENTE
        ORDER BY ID_PACIENTE;

END;
/

---------------------------------------------------------
-- HISTORIAL_CLINICO
---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_INSERTAR_HISTORIAL(

    P_ID_PACIENTE              IN NUMBER,
    P_FECHA_CREACION           IN DATE,
    P_OBSERVACIONES            IN VARCHAR2

)
AS
BEGIN

    INSERT INTO HISTORIAL_CLINICO(

        ID_HISTORIAL,
        ID_PACIENTE,
        FECHA_CREACION,
        OBSERVACIONES_GENERALES

    )

    VALUES(

        NULL,
        P_ID_PACIENTE,
        P_FECHA_CREACION,
        P_OBSERVACIONES

    );

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_ACTUALIZAR_HISTORIAL(

    P_ID_HISTORIAL             IN NUMBER,
    P_ID_PACIENTE              IN NUMBER,
    P_FECHA_CREACION           IN DATE,
    P_OBSERVACIONES            IN VARCHAR2

)
AS
BEGIN

    UPDATE HISTORIAL_CLINICO

       SET ID_PACIENTE = P_ID_PACIENTE,
           FECHA_CREACION = P_FECHA_CREACION,
           OBSERVACIONES_GENERALES = P_OBSERVACIONES

     WHERE ID_HISTORIAL = P_ID_HISTORIAL;

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_ELIMINAR_HISTORIAL(

    P_ID_HISTORIAL IN NUMBER

)
AS
BEGIN

    DELETE FROM HISTORIAL_CLINICO

    WHERE ID_HISTORIAL = P_ID_HISTORIAL;

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_LISTAR_HISTORIAL(

    P_CURSOR OUT SYS_REFCURSOR

)
AS
BEGIN

    OPEN P_CURSOR FOR

        SELECT *

        FROM HISTORIAL_CLINICO

        ORDER BY ID_HISTORIAL;

END;
/

---------------------------------------------------------
-- HORARIO_MEDICO
---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_INSERTAR_HORARIO(

    P_ID_MEDICO        IN NUMBER,
    P_DIA_SEMANA       IN VARCHAR2,
    P_HORA_INICIO      IN VARCHAR2,
    P_HORA_FIN         IN VARCHAR2

)
AS
BEGIN

    INSERT INTO HORARIO_MEDICO(

        ID_HORARIO,
        ID_MEDICO,
        DIA_SEMANA,
        HORA_INICIO,
        HORA_FIN

    )

    VALUES(

        NULL,
        P_ID_MEDICO,
        P_DIA_SEMANA,
        P_HORA_INICIO,
        P_HORA_FIN

    );

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_ACTUALIZAR_HORARIO(

    P_ID_HORARIO       IN NUMBER,
    P_ID_MEDICO        IN NUMBER,
    P_DIA_SEMANA       IN VARCHAR2,
    P_HORA_INICIO      IN VARCHAR2,
    P_HORA_FIN         IN VARCHAR2

)
AS
BEGIN

    UPDATE HORARIO_MEDICO

       SET ID_MEDICO = P_ID_MEDICO,
           DIA_SEMANA = P_DIA_SEMANA,
           HORA_INICIO = P_HORA_INICIO,
           HORA_FIN = P_HORA_FIN

     WHERE ID_HORARIO = P_ID_HORARIO;

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_ELIMINAR_HORARIO(

    P_ID_HORARIO IN NUMBER

)
AS
BEGIN

    DELETE FROM HORARIO_MEDICO

    WHERE ID_HORARIO = P_ID_HORARIO;

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_LISTAR_HORARIO(

    P_CURSOR OUT SYS_REFCURSOR

)
AS
BEGIN

    OPEN P_CURSOR FOR

        SELECT *

        FROM HORARIO_MEDICO

        ORDER BY ID_HORARIO;

END;
/

---------------------------------------------------------
-- CITA
---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_INSERTAR_CITA(

    P_ID_PACIENTE      IN NUMBER,
    P_ID_MEDICO        IN NUMBER,
    P_ID_CONSULTORIO   IN NUMBER,
    P_FECHA            IN DATE,
    P_HORA             IN VARCHAR2,
    P_ESTADO           IN VARCHAR2,
    P_MOTIVO           IN VARCHAR2

)
AS
BEGIN

    INSERT INTO CITA(

        ID_CITA,
        ID_PACIENTE,
        ID_MEDICO,
        ID_CONSULTORIO,
        FECHA,
        HORA,
        ESTADO,
        MOTIVO

    )

    VALUES(

        NULL,
        P_ID_PACIENTE,
        P_ID_MEDICO,
        P_ID_CONSULTORIO,
        P_FECHA,
        P_HORA,
        P_ESTADO,
        P_MOTIVO

    );

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_ACTUALIZAR_CITA(

    P_ID_CITA          IN NUMBER,
    P_ID_PACIENTE      IN NUMBER,
    P_ID_MEDICO        IN NUMBER,
    P_ID_CONSULTORIO   IN NUMBER,
    P_FECHA            IN DATE,
    P_HORA             IN VARCHAR2,
    P_ESTADO           IN VARCHAR2,
    P_MOTIVO           IN VARCHAR2

)
AS
BEGIN

    UPDATE CITA

       SET ID_PACIENTE = P_ID_PACIENTE,
           ID_MEDICO = P_ID_MEDICO,
           ID_CONSULTORIO = P_ID_CONSULTORIO,
           FECHA = P_FECHA,
           HORA = P_HORA,
           ESTADO = P_ESTADO,
           MOTIVO = P_MOTIVO

     WHERE ID_CITA = P_ID_CITA;

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_ELIMINAR_CITA(

    P_ID_CITA IN NUMBER

)
AS
BEGIN

    DELETE FROM CITA

    WHERE ID_CITA = P_ID_CITA;

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_LISTAR_CITA(

    P_CURSOR OUT SYS_REFCURSOR

)
AS
BEGIN

    OPEN P_CURSOR FOR

        SELECT *

        FROM CITA

        ORDER BY FECHA, HORA;

END;
/

---------------------------------------------------------
-- CONSULTA
---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_INSERTAR_CONSULTA(

    P_ID_HISTORIAL      IN NUMBER,
    P_ID_MEDICO         IN NUMBER,
    P_ID_CITA           IN NUMBER,
    P_FECHA             IN DATE,
    P_OBSERVACIONES     IN VARCHAR2

)
AS
BEGIN

    INSERT INTO CONSULTA(

        ID_CONSULTA,
        ID_HISTORIAL,
        ID_MEDICO,
        ID_CITA,
        FECHA,
        OBSERVACIONES

    )

    VALUES(

        NULL,
        P_ID_HISTORIAL,
        P_ID_MEDICO,
        P_ID_CITA,
        P_FECHA,
        P_OBSERVACIONES

    );

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_ACTUALIZAR_CONSULTA(

    P_ID_CONSULTA       IN NUMBER,
    P_ID_HISTORIAL      IN NUMBER,
    P_ID_MEDICO         IN NUMBER,
    P_ID_CITA           IN NUMBER,
    P_FECHA             IN DATE,
    P_OBSERVACIONES     IN VARCHAR2

)
AS
BEGIN

    UPDATE CONSULTA

       SET ID_HISTORIAL = P_ID_HISTORIAL,
           ID_MEDICO = P_ID_MEDICO,
           ID_CITA = P_ID_CITA,
           FECHA = P_FECHA,
           OBSERVACIONES = P_OBSERVACIONES

     WHERE ID_CONSULTA = P_ID_CONSULTA;

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_ELIMINAR_CONSULTA(

    P_ID_CONSULTA IN NUMBER

)
AS
BEGIN

    DELETE FROM CONSULTA

    WHERE ID_CONSULTA = P_ID_CONSULTA;

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_LISTAR_CONSULTA(

    P_CURSOR OUT SYS_REFCURSOR

)
AS
BEGIN

    OPEN P_CURSOR FOR

        SELECT *

        FROM CONSULTA

        ORDER BY FECHA DESC;

END;
/

---------------------------------------------------------
-- DIAGNOSTICO
---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_INSERTAR_DIAGNOSTICO(

    P_ID_CONSULTA      IN NUMBER,
    P_CODIGO_CIE10     IN VARCHAR2,
    P_DESCRIPCION      IN VARCHAR2,
    P_FECHA            IN DATE

)
AS
BEGIN

    INSERT INTO DIAGNOSTICO(

        ID_DIAGNOSTICO,
        ID_CONSULTA,
        CODIGO_CIE10,
        DESCRIPCION,
        FECHA

    )

    VALUES(

        NULL,
        P_ID_CONSULTA,
        P_CODIGO_CIE10,
        P_DESCRIPCION,
        P_FECHA

    );

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_ACTUALIZAR_DIAGNOSTICO(

    P_ID_DIAGNOSTICO    IN NUMBER,
    P_ID_CONSULTA       IN NUMBER,
    P_CODIGO_CIE10      IN VARCHAR2,
    P_DESCRIPCION       IN VARCHAR2,
    P_FECHA             IN DATE

)
AS
BEGIN

    UPDATE DIAGNOSTICO

       SET ID_CONSULTA = P_ID_CONSULTA,
           CODIGO_CIE10 = P_CODIGO_CIE10,
           DESCRIPCION = P_DESCRIPCION,
           FECHA = P_FECHA

     WHERE ID_DIAGNOSTICO = P_ID_DIAGNOSTICO;

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_ELIMINAR_DIAGNOSTICO(

    P_ID_DIAGNOSTICO IN NUMBER

)
AS
BEGIN

    DELETE FROM DIAGNOSTICO

    WHERE ID_DIAGNOSTICO = P_ID_DIAGNOSTICO;

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_LISTAR_DIAGNOSTICO(

    P_CURSOR OUT SYS_REFCURSOR

)
AS
BEGIN

    OPEN P_CURSOR FOR

        SELECT *

        FROM DIAGNOSTICO

        ORDER BY FECHA DESC;

END;
/

---------------------------------------------------------
-- RECETA
---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_INSERTAR_RECETA(

    P_ID_CONSULTA      IN NUMBER,
    P_FECHA            IN DATE,
    P_OBSERVACIONES    IN VARCHAR2

)
AS
BEGIN

    INSERT INTO RECETA(

        ID_RECETA,
        ID_CONSULTA,
        FECHA,
        OBSERVACIONES

    )

    VALUES(

        NULL,
        P_ID_CONSULTA,
        P_FECHA,
        P_OBSERVACIONES

    );

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_ACTUALIZAR_RECETA(

    P_ID_RECETA        IN NUMBER,
    P_ID_CONSULTA      IN NUMBER,
    P_FECHA            IN DATE,
    P_OBSERVACIONES    IN VARCHAR2

)
AS
BEGIN

    UPDATE RECETA

       SET ID_CONSULTA = P_ID_CONSULTA,
           FECHA = P_FECHA,
           OBSERVACIONES = P_OBSERVACIONES

     WHERE ID_RECETA = P_ID_RECETA;

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_ELIMINAR_RECETA(

    P_ID_RECETA IN NUMBER

)
AS
BEGIN

    DELETE FROM RECETA

    WHERE ID_RECETA = P_ID_RECETA;

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_LISTAR_RECETA(

    P_CURSOR OUT SYS_REFCURSOR

)
AS
BEGIN

    OPEN P_CURSOR FOR

        SELECT *

        FROM RECETA

        ORDER BY FECHA DESC;

END;
/

---------------------------------------------------------
-- DETALLE_RECETA
---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_INSERTAR_DETALLE_RECETA(

    P_ID_RECETA         IN NUMBER,
    P_ID_MEDICAMENTO    IN NUMBER,
    P_CANTIDAD          IN NUMBER,
    P_DOSIS             IN VARCHAR2,
    P_INDICACIONES      IN VARCHAR2

)
AS
BEGIN

    INSERT INTO DETALLE_RECETA(
        ID_DETALLE,
        ID_RECETA,
        ID_MEDICAMENTO,
        CANTIDAD,
        DOSIS,
        INDICACIONES
    )
    VALUES(
        NULL,
        P_ID_RECETA,
        P_ID_MEDICAMENTO,
        P_CANTIDAD,
        P_DOSIS,
        P_INDICACIONES
    );

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_ACTUALIZAR_DETALLE_RECETA(

    P_ID_DETALLE         IN NUMBER,
    P_ID_RECETA          IN NUMBER,
    P_ID_MEDICAMENTO     IN NUMBER,
    P_CANTIDAD           IN NUMBER,
    P_DOSIS              IN VARCHAR2,
    P_INDICACIONES       IN VARCHAR2

)
AS
BEGIN

    UPDATE DETALLE_RECETA
       SET ID_RECETA = P_ID_RECETA,
           ID_MEDICAMENTO = P_ID_MEDICAMENTO,
           CANTIDAD = P_CANTIDAD,
           DOSIS = P_DOSIS,
           INDICACIONES = P_INDICACIONES
     WHERE ID_DETALLE = P_ID_DETALLE;

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_ELIMINAR_DETALLE_RECETA(

    P_ID_DETALLE IN NUMBER

)
AS
BEGIN

    DELETE FROM DETALLE_RECETA
    WHERE ID_DETALLE = P_ID_DETALLE;

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_LISTAR_DETALLE_RECETA(

    P_CURSOR OUT SYS_REFCURSOR

)
AS
BEGIN

    OPEN P_CURSOR FOR
        SELECT *
        FROM DETALLE_RECETA
        ORDER BY ID_DETALLE;

END;
/

---------------------------------------------------------
-- TRATAMIENTO
---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_INSERTAR_TRATAMIENTO(

    P_ID_CONSULTA        IN NUMBER,
    P_ID_MEDICAMENTO     IN NUMBER,
    P_DOSIS              IN VARCHAR2,
    P_FRECUENCIA         IN VARCHAR2,
    P_DURACION_DIAS      IN NUMBER,
    P_FECHA_INICIO       IN DATE

)
AS
BEGIN

    INSERT INTO TRATAMIENTO(
        ID_TRATAMIENTO,
        ID_CONSULTA,
        ID_MEDICAMENTO,
        DOSIS,
        FRECUENCIA,
        DURACION_DIAS,
        FECHA_INICIO
    )
    VALUES(
        NULL,
        P_ID_CONSULTA,
        P_ID_MEDICAMENTO,
        P_DOSIS,
        P_FRECUENCIA,
        P_DURACION_DIAS,
        P_FECHA_INICIO
    );

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_ACTUALIZAR_TRATAMIENTO(

    P_ID_TRATAMIENTO     IN NUMBER,
    P_ID_CONSULTA        IN NUMBER,
    P_ID_MEDICAMENTO     IN NUMBER,
    P_DOSIS              IN VARCHAR2,
    P_FRECUENCIA         IN VARCHAR2,
    P_DURACION_DIAS      IN NUMBER,
    P_FECHA_INICIO       IN DATE

)
AS
BEGIN

    UPDATE TRATAMIENTO
       SET ID_CONSULTA = P_ID_CONSULTA,
           ID_MEDICAMENTO = P_ID_MEDICAMENTO,
           DOSIS = P_DOSIS,
           FRECUENCIA = P_FRECUENCIA,
           DURACION_DIAS = P_DURACION_DIAS,
           FECHA_INICIO = P_FECHA_INICIO
     WHERE ID_TRATAMIENTO = P_ID_TRATAMIENTO;

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_ELIMINAR_TRATAMIENTO(

    P_ID_TRATAMIENTO IN NUMBER

)
AS
BEGIN

    DELETE FROM TRATAMIENTO
    WHERE ID_TRATAMIENTO = P_ID_TRATAMIENTO;

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_LISTAR_TRATAMIENTO(

    P_CURSOR OUT SYS_REFCURSOR

)
AS
BEGIN

    OPEN P_CURSOR FOR
        SELECT *
        FROM TRATAMIENTO
        ORDER BY ID_TRATAMIENTO;

END;
/

---------------------------------------------------------
-- ALERGIA
---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_INSERTAR_ALERGIA(

    P_ID_PACIENTE        IN NUMBER,
    P_NOMBRE_ALERGIA     IN VARCHAR2,
    P_TIPO               IN VARCHAR2,
    P_SEVERIDAD          IN VARCHAR2

)
AS
BEGIN

    INSERT INTO ALERGIA(
        ID_ALERGIA,
        ID_PACIENTE,
        NOMBRE_ALERGIA,
        TIPO,
        SEVERIDAD
    )
    VALUES(
        NULL,
        P_ID_PACIENTE,
        P_NOMBRE_ALERGIA,
        P_TIPO,
        P_SEVERIDAD
    );

    COMMIT;

END;
/

CREATE OR REPLACE PROCEDURE SP_ACTUALIZAR_ALERGIA(

    P_ID_ALERGIA         IN NUMBER,
    P_ID_PACIENTE        IN NUMBER,
    P_NOMBRE_ALERGIA     IN VARCHAR2,
    P_TIPO               IN VARCHAR2,
    P_SEVERIDAD          IN VARCHAR2

)
AS
BEGIN

    UPDATE ALERGIA
       SET ID_PACIENTE = P_ID_PACIENTE,
           NOMBRE_ALERGIA = P_NOMBRE_ALERGIA,
           TIPO = P_TIPO,
           SEVERIDAD = P_SEVERIDAD
     WHERE ID_ALERGIA = P_ID_ALERGIA;

    COMMIT;

END;
/

CREATE OR REPLACE PROCEDURE SP_ELIMINAR_ALERGIA(

    P_ID_ALERGIA IN NUMBER

)
AS
BEGIN

    DELETE FROM ALERGIA
    WHERE ID_ALERGIA = P_ID_ALERGIA;

    COMMIT;

END;
/

CREATE OR REPLACE PROCEDURE SP_LISTAR_ALERGIA(

    P_CURSOR OUT SYS_REFCURSOR

)
AS
BEGIN

    OPEN P_CURSOR FOR
        SELECT *
        FROM ALERGIA
        ORDER BY ID_ALERGIA;

END;
/

---------------------------------------------------------
-- ANTECEDENTE_MEDICO
---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_INSERTAR_ANTECEDENTE(

    P_ID_PACIENTE        IN NUMBER,
    P_TIPO               IN VARCHAR2,
    P_DESCRIPCION        IN VARCHAR2,
    P_FECHA              IN DATE

)
AS
BEGIN

    INSERT INTO ANTECEDENTE_MEDICO(
        ID_ANTECEDENTE,
        ID_PACIENTE,
        TIPO,
        DESCRIPCION,
        FECHA_REGISTRO
    )
    VALUES(
        NULL,
        P_ID_PACIENTE,
        P_TIPO,
        P_DESCRIPCION,
        P_FECHA
    );

    COMMIT;

END;
/

CREATE OR REPLACE PROCEDURE SP_ACTUALIZAR_ANTECEDENTE(

    P_ID_ANTECEDENTE     IN NUMBER,
    P_ID_PACIENTE        IN NUMBER,
    P_TIPO               IN VARCHAR2,
    P_DESCRIPCION        IN VARCHAR2,
    P_FECHA              IN DATE

)
AS
BEGIN

    UPDATE ANTECEDENTE_MEDICO
       SET ID_PACIENTE = P_ID_PACIENTE,
           TIPO = P_TIPO,
           DESCRIPCION = P_DESCRIPCION,
           FECHA_REGISTRO = P_FECHA
     WHERE ID_ANTECEDENTE = P_ID_ANTECEDENTE;

    COMMIT;

END;
/

CREATE OR REPLACE PROCEDURE SP_ELIMINAR_ANTECEDENTE(

    P_ID_ANTECEDENTE IN NUMBER

)
AS
BEGIN

    DELETE FROM ANTECEDENTE_MEDICO
    WHERE ID_ANTECEDENTE = P_ID_ANTECEDENTE;

    COMMIT;

END;
/

CREATE OR REPLACE PROCEDURE SP_LISTAR_ANTECEDENTE(

    P_CURSOR OUT SYS_REFCURSOR

)
AS
BEGIN

    OPEN P_CURSOR FOR
        SELECT *
        FROM ANTECEDENTE_MEDICO
        ORDER BY ID_ANTECEDENTE;

END;
/

---------------------------------------------------------
-- INDICADOR_SALUD
---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_INSERTAR_INDICADOR(

    P_ID_PACIENTE      IN NUMBER,
    P_TIPO             IN VARCHAR2,
    P_VALOR            IN NUMBER,
    P_UNIDAD           IN VARCHAR2,
    P_FECHA            IN DATE

)
AS
BEGIN

    INSERT INTO INDICADOR_SALUD(
        ID_INDICADOR,
        ID_PACIENTE,
        TIPO_INDICADOR,
        VALOR,
        UNIDAD_MEDIDA,
        FECHA_REGISTRO
    )
    VALUES(
        NULL,
        P_ID_PACIENTE,
        P_TIPO,
        P_VALOR,
        P_UNIDAD,
        P_FECHA
    );

    COMMIT;

END;
/

CREATE OR REPLACE PROCEDURE SP_ACTUALIZAR_INDICADOR(

    P_ID_INDICADOR     IN NUMBER,
    P_ID_PACIENTE      IN NUMBER,
    P_TIPO             IN VARCHAR2,
    P_VALOR            IN NUMBER,
    P_UNIDAD           IN VARCHAR2,
    P_FECHA            IN DATE

)
AS
BEGIN

    UPDATE INDICADOR_SALUD
       SET ID_PACIENTE = P_ID_PACIENTE,
           TIPO_INDICADOR = P_TIPO,
           VALOR = P_VALOR,
           UNIDAD_MEDIDA = P_UNIDAD,
           FECHA_REGISTRO = P_FECHA
     WHERE ID_INDICADOR = P_ID_INDICADOR;

    COMMIT;

END;
/

CREATE OR REPLACE PROCEDURE SP_ELIMINAR_INDICADOR(

    P_ID_INDICADOR IN NUMBER

)
AS
BEGIN

    DELETE FROM INDICADOR_SALUD
    WHERE ID_INDICADOR = P_ID_INDICADOR;

    COMMIT;

END;
/

CREATE OR REPLACE PROCEDURE SP_LISTAR_INDICADOR(

    P_CURSOR OUT SYS_REFCURSOR

)
AS
BEGIN

    OPEN P_CURSOR FOR
        SELECT *
        FROM INDICADOR_SALUD
        ORDER BY ID_INDICADOR;

END;
/

---------------------------------------------------------
-- SEGURO_MEDICO
---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_INSERTAR_SEGURO(

    P_ID_PACIENTE          IN NUMBER,
    P_ASEGURADORA          IN VARCHAR2,
    P_NUMERO_POLIZA        IN VARCHAR2,
    P_FECHA_VENCIMIENTO    IN DATE

)
AS
BEGIN

    INSERT INTO SEGURO_MEDICO(
        ID_SEGURO,
        ID_PACIENTE,
        ASEGURADORA,
        NUMERO_POLIZA,
        FECHA_VENCIMIENTO
    )
    VALUES(
        NULL,
        P_ID_PACIENTE,
        P_ASEGURADORA,
        P_NUMERO_POLIZA,
        P_FECHA_VENCIMIENTO
    );

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_ACTUALIZAR_SEGURO(

    P_ID_SEGURO            IN NUMBER,
    P_ID_PACIENTE          IN NUMBER,
    P_ASEGURADORA          IN VARCHAR2,
    P_NUMERO_POLIZA        IN VARCHAR2,
    P_FECHA_VENCIMIENTO    IN DATE

)
AS
BEGIN

    UPDATE SEGURO_MEDICO
       SET ID_PACIENTE = P_ID_PACIENTE,
           ASEGURADORA = P_ASEGURADORA,
           NUMERO_POLIZA = P_NUMERO_POLIZA,
           FECHA_VENCIMIENTO = P_FECHA_VENCIMIENTO
     WHERE ID_SEGURO = P_ID_SEGURO;

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_ELIMINAR_SEGURO(

    P_ID_SEGURO IN NUMBER

)
AS
BEGIN

    DELETE FROM SEGURO_MEDICO
    WHERE ID_SEGURO = P_ID_SEGURO;

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_LISTAR_SEGURO(

    P_CURSOR OUT SYS_REFCURSOR

)
AS
BEGIN

    OPEN P_CURSOR FOR
        SELECT *
        FROM SEGURO_MEDICO
        ORDER BY ID_SEGURO;

END;
/

---------------------------------------------------------
-- FACTURA
---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_INSERTAR_FACTURA(

    P_ID_CONSULTA      IN NUMBER,
    P_FECHA            IN DATE,
    P_SUBTOTAL         IN NUMBER,
    P_IMPUESTO         IN NUMBER,
    P_TOTAL            IN NUMBER,
    P_ESTADO           IN VARCHAR2

)
AS
BEGIN

    INSERT INTO FACTURA(
        ID_FACTURA,
        ID_CONSULTA,
        FECHA,
        SUBTOTAL,
        IMPUESTO,
        TOTAL,
        ESTADO
    )
    VALUES(
        NULL,
        P_ID_CONSULTA,
        P_FECHA,
        P_SUBTOTAL,
        P_IMPUESTO,
        P_TOTAL,
        P_ESTADO
    );

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_ACTUALIZAR_FACTURA(

    P_ID_FACTURA       IN NUMBER,
    P_ID_CONSULTA      IN NUMBER,
    P_FECHA            IN DATE,
    P_SUBTOTAL         IN NUMBER,
    P_IMPUESTO         IN NUMBER,
    P_TOTAL            IN NUMBER,
    P_ESTADO           IN VARCHAR2

)
AS
BEGIN

    UPDATE FACTURA
       SET ID_CONSULTA = P_ID_CONSULTA,
           FECHA = P_FECHA,
           SUBTOTAL = P_SUBTOTAL,
           IMPUESTO = P_IMPUESTO,
           TOTAL = P_TOTAL,
           ESTADO = P_ESTADO
     WHERE ID_FACTURA = P_ID_FACTURA;

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_ELIMINAR_FACTURA(

    P_ID_FACTURA IN NUMBER

)
AS
BEGIN

    DELETE FROM FACTURA
    WHERE ID_FACTURA = P_ID_FACTURA;

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_LISTAR_FACTURA(

    P_CURSOR OUT SYS_REFCURSOR

)
AS
BEGIN

    OPEN P_CURSOR FOR
        SELECT *
        FROM FACTURA
        ORDER BY FECHA DESC;

END;
/

---------------------------------------------------------
-- PAGO
---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_INSERTAR_PAGO(

    P_ID_FACTURA       IN NUMBER,
    P_FECHA            IN DATE,
    P_MONTO            IN NUMBER,
    P_METODO_PAGO      IN VARCHAR2,
    P_REFERENCIA       IN VARCHAR2,
    P_OBSERVACIONES    IN VARCHAR2

)
AS
BEGIN

    INSERT INTO PAGO(
        ID_PAGO,
        ID_FACTURA,
        FECHA,
        MONTO,
        METODO_PAGO,
        REFERENCIA,
        OBSERVACIONES
    )
    VALUES(
        NULL,
        P_ID_FACTURA,
        P_FECHA,
        P_MONTO,
        P_METODO_PAGO,
        P_REFERENCIA,
        P_OBSERVACIONES
    );

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_ACTUALIZAR_PAGO(

    P_ID_PAGO          IN NUMBER,
    P_ID_FACTURA       IN NUMBER,
    P_FECHA            IN DATE,
    P_MONTO            IN NUMBER,
    P_METODO_PAGO      IN VARCHAR2,
    P_REFERENCIA       IN VARCHAR2,
    P_OBSERVACIONES    IN VARCHAR2

)
AS
BEGIN

    UPDATE PAGO
       SET ID_FACTURA = P_ID_FACTURA,
           FECHA = P_FECHA,
           MONTO = P_MONTO,
           METODO_PAGO = P_METODO_PAGO,
           REFERENCIA = P_REFERENCIA,
           OBSERVACIONES = P_OBSERVACIONES
     WHERE ID_PAGO = P_ID_PAGO;

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_ELIMINAR_PAGO(

    P_ID_PAGO IN NUMBER

)
AS
BEGIN

    DELETE FROM PAGO
    WHERE ID_PAGO = P_ID_PAGO;

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_LISTAR_PAGO(

    P_CURSOR OUT SYS_REFCURSOR

)
AS
BEGIN

    OPEN P_CURSOR FOR
        SELECT *
        FROM PAGO
        ORDER BY FECHA DESC;

END;
/

---------------------------------------------------------
-- AUDITORIA
---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_INSERTAR_AUDITORIA(

    P_ID_USUARIO       IN NUMBER,
    P_TABLA_AFECTADA   IN VARCHAR2,
    P_ACCION           IN VARCHAR2,
    P_FECHA            IN TIMESTAMP

)
AS
BEGIN

    INSERT INTO AUDITORIA(
        ID_AUDITORIA,
        ID_USUARIO,
        TABLA_AFECTADA,
        ACCION,
        FECHA
    )
    VALUES(
        NULL,
        P_ID_USUARIO,
        P_TABLA_AFECTADA,
        P_ACCION,
        P_FECHA
    );

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_ACTUALIZAR_AUDITORIA(

    P_ID_AUDITORIA     IN NUMBER,
    P_ID_USUARIO       IN NUMBER,
    P_TABLA_AFECTADA   IN VARCHAR2,
    P_ACCION           IN VARCHAR2,
    P_FECHA            IN TIMESTAMP

)
AS
BEGIN

    UPDATE AUDITORIA
       SET ID_USUARIO = P_ID_USUARIO,
           TABLA_AFECTADA = P_TABLA_AFECTADA,
           ACCION = P_ACCION,
           FECHA = P_FECHA
     WHERE ID_AUDITORIA = P_ID_AUDITORIA;

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_ELIMINAR_AUDITORIA(

    P_ID_AUDITORIA IN NUMBER

)
AS
BEGIN

    DELETE FROM AUDITORIA
    WHERE ID_AUDITORIA = P_ID_AUDITORIA;

    COMMIT;

END;
/

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_LISTAR_AUDITORIA(

    P_CURSOR OUT SYS_REFCURSOR

)
AS
BEGIN

    OPEN P_CURSOR FOR

        SELECT *

        FROM AUDITORIA

        ORDER BY FECHA DESC;

END;
/