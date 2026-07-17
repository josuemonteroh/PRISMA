/*
Sistema de Gestión y Consolidación de Información Clínica
SC-504 Lenguajes de Base de Datos

Archivo : 01_tables.sql
Motor    : Oracle Database 23c Free
Autor    : Equipo PRISMA
*/

---------------------------------------------------------
-- TABLA: ROL
---------------------------------------------------------

CREATE TABLE ROL (
    ID_ROL              NUMBER(10)         NOT NULL,
    NOMBRE_ROL          VARCHAR2(50)       NOT NULL,
    DESCRIPCION         VARCHAR2(300),

    CONSTRAINT PK_ROL
        PRIMARY KEY (ID_ROL),

    CONSTRAINT UQ_ROL_NOMBRE
        UNIQUE (NOMBRE_ROL)
);

---------------------------------------------------------
-- TABLA: ESPECIALIDAD
---------------------------------------------------------

CREATE TABLE ESPECIALIDAD (
    ID_ESPECIALIDAD         NUMBER(10)         NOT NULL,
    NOMBRE_ESPECIALIDAD     VARCHAR2(100)      NOT NULL,
    DESCRIPCION             VARCHAR2(300),

    CONSTRAINT PK_ESPECIALIDAD
        PRIMARY KEY (ID_ESPECIALIDAD),

    CONSTRAINT UQ_ESPECIALIDAD_NOMBRE
        UNIQUE (NOMBRE_ESPECIALIDAD)
);

---------------------------------------------------------
-- TABLA: CONSULTORIO
---------------------------------------------------------

CREATE TABLE CONSULTORIO (
    ID_CONSULTORIO      NUMBER(10)         NOT NULL,
    NOMBRE              VARCHAR2(100)      NOT NULL,
    UBICACION           VARCHAR2(150)      NOT NULL,
    PISO                NUMBER(2),

    CONSTRAINT PK_CONSULTORIO
        PRIMARY KEY (ID_CONSULTORIO),

    CONSTRAINT UQ_CONSULTORIO_NOMBRE
        UNIQUE (NOMBRE),

    CONSTRAINT CHK_CONSULTORIO_PISO
        CHECK (PISO >= 0)
);

---------------------------------------------------------
-- TABLA: MEDICAMENTO
---------------------------------------------------------

CREATE TABLE MEDICAMENTO (
    ID_MEDICAMENTO      NUMBER(10)         NOT NULL,
    NOMBRE              VARCHAR2(150)      NOT NULL,
    DESCRIPCION         VARCHAR2(300),
    PRESENTACION        VARCHAR2(100),
    CONCENTRACION       VARCHAR2(50),

    CONSTRAINT PK_MEDICAMENTO
        PRIMARY KEY (ID_MEDICAMENTO),

    CONSTRAINT UQ_MEDICAMENTO_NOMBRE
        UNIQUE (NOMBRE)
);

---------------------------------------------------------
-- TABLA: USUARIO
---------------------------------------------------------

CREATE TABLE USUARIO (
    ID_USUARIO          NUMBER(10)         NOT NULL,
    ID_ROL              NUMBER(10)         NOT NULL,
    NOMBRE_USUARIO      VARCHAR2(50)       NOT NULL,
    CONTRASENA_HASH     VARCHAR2(255)      NOT NULL,
    CORREO              VARCHAR2(150)      NOT NULL,
    ESTADO              VARCHAR2(20)       DEFAULT 'ACTIVO' NOT NULL,

    CONSTRAINT PK_USUARIO
        PRIMARY KEY (ID_USUARIO),

    CONSTRAINT FK_USUARIO_ROL
        FOREIGN KEY (ID_ROL)
        REFERENCES ROL(ID_ROL),

    CONSTRAINT UQ_USUARIO_NOMBRE
        UNIQUE (NOMBRE_USUARIO),

    CONSTRAINT UQ_USUARIO_CORREO
        UNIQUE (CORREO),

    CONSTRAINT CHK_USUARIO_ESTADO
        CHECK (ESTADO IN ('ACTIVO','INACTIVO'))
);

---------------------------------------------------------
-- TABLA: DOCTOR
---------------------------------------------------------

CREATE TABLE DOCTOR (
    ID_MEDICO               NUMBER(10)         NOT NULL,
    ID_ESPECIALIDAD         NUMBER(10)         NOT NULL,
    NOMBRE                  VARCHAR2(100)      NOT NULL,
    APELLIDO                VARCHAR2(100)      NOT NULL,
    TELEFONO                VARCHAR2(20),
    CORREO                  VARCHAR2(150),
    NUMERO_COLEGIATURA      VARCHAR2(30)       NOT NULL,

    CONSTRAINT PK_DOCTOR
        PRIMARY KEY (ID_MEDICO),

    CONSTRAINT FK_DOCTOR_ESPECIALIDAD
        FOREIGN KEY (ID_ESPECIALIDAD)
        REFERENCES ESPECIALIDAD(ID_ESPECIALIDAD),

    CONSTRAINT UQ_DOCTOR_COLEGIATURA
        UNIQUE (NUMERO_COLEGIATURA),

    CONSTRAINT UQ_DOCTOR_CORREO
        UNIQUE (CORREO)
);

---------------------------------------------------------
-- TABLA: PACIENTE
---------------------------------------------------------

CREATE TABLE PACIENTE (
    ID_PACIENTE             NUMBER(10)         NOT NULL,
    NOMBRE                  VARCHAR2(100)      NOT NULL,
    APELLIDO                VARCHAR2(100)      NOT NULL,
    FECHA_NACIMIENTO        DATE               NOT NULL,
    SEXO                    CHAR(1)            NOT NULL,
    TELEFONO                VARCHAR2(20),
    CORREO                  VARCHAR2(150),
    DIRECCION               VARCHAR2(200),
    CEDULA                  VARCHAR2(20)       NOT NULL,

    CONSTRAINT PK_PACIENTE
        PRIMARY KEY (ID_PACIENTE),

    CONSTRAINT UQ_PACIENTE_CEDULA
        UNIQUE (CEDULA),

    CONSTRAINT UQ_PACIENTE_CORREO
        UNIQUE (CORREO),

    CONSTRAINT CHK_PACIENTE_SEXO
        CHECK (SEXO IN ('M','F'))
);

---------------------------------------------------------
-- TABLA: HISTORIAL_CLINICO
---------------------------------------------------------

CREATE TABLE HISTORIAL_CLINICO (
    ID_HISTORIAL               NUMBER(10)         NOT NULL,
    ID_PACIENTE                NUMBER(10)         NOT NULL,
    FECHA_CREACION             DATE               NOT NULL,
    OBSERVACIONES_GENERALES    VARCHAR2(500),

    CONSTRAINT PK_HISTORIAL_CLINICO
        PRIMARY KEY (ID_HISTORIAL),

    CONSTRAINT FK_HISTORIAL_PACIENTE
        FOREIGN KEY (ID_PACIENTE)
        REFERENCES PACIENTE(ID_PACIENTE),

    CONSTRAINT UQ_HISTORIAL_PACIENTE
        UNIQUE (ID_PACIENTE)
);

---------------------------------------------------------
-- TABLA: HORARIO_MEDICO
---------------------------------------------------------

CREATE TABLE HORARIO_MEDICO (
    ID_HORARIO             NUMBER(10)         NOT NULL,
    ID_MEDICO              NUMBER(10)         NOT NULL,
    DIA_SEMANA             VARCHAR2(15)       NOT NULL,
    HORA_INICIO            VARCHAR2(5)        NOT NULL,
    HORA_FIN               VARCHAR2(5)        NOT NULL,

    CONSTRAINT PK_HORARIO_MEDICO
        PRIMARY KEY (ID_HORARIO),

    CONSTRAINT FK_HORARIO_MEDICO_DOCTOR
        FOREIGN KEY (ID_MEDICO)
        REFERENCES DOCTOR(ID_MEDICO),

    CONSTRAINT CHK_DIA_SEMANA
        CHECK (
            DIA_SEMANA IN (
                'LUNES',
                'MARTES',
                'MIERCOLES',
                'JUEVES',
                'VIERNES',
                'SABADO',
                'DOMINGO'
            )
        )
);

---------------------------------------------------------
-- TABLA: CITA
---------------------------------------------------------

CREATE TABLE CITA (
    ID_CITA                 NUMBER(10)         NOT NULL,
    ID_PACIENTE             NUMBER(10)         NOT NULL,
    ID_MEDICO               NUMBER(10)         NOT NULL,
    ID_CONSULTORIO          NUMBER(10)         NOT NULL,
    FECHA                   DATE               NOT NULL,
    HORA                    VARCHAR2(5)        NOT NULL,
    ESTADO                  VARCHAR2(20)       NOT NULL,
    MOTIVO                  VARCHAR2(300),

    CONSTRAINT PK_CITA
        PRIMARY KEY (ID_CITA),

    CONSTRAINT FK_CITA_PACIENTE
        FOREIGN KEY (ID_PACIENTE)
        REFERENCES PACIENTE(ID_PACIENTE),

    CONSTRAINT FK_CITA_DOCTOR
        FOREIGN KEY (ID_MEDICO)
        REFERENCES DOCTOR(ID_MEDICO),

    CONSTRAINT FK_CITA_CONSULTORIO
        FOREIGN KEY (ID_CONSULTORIO)
        REFERENCES CONSULTORIO(ID_CONSULTORIO),

    CONSTRAINT CHK_CITA_ESTADO
        CHECK (
            ESTADO IN (
                'PROGRAMADA',
                'CONFIRMADA',
                'ATENDIDA',
                'CANCELADA'
            )
        )
);

---------------------------------------------------------
-- TABLA: CONSULTA
---------------------------------------------------------

CREATE TABLE CONSULTA (
    ID_CONSULTA             NUMBER(10)         NOT NULL,
    ID_HISTORIAL            NUMBER(10)         NOT NULL,
    ID_MEDICO               NUMBER(10)         NOT NULL,
    ID_CITA                 NUMBER(10)         NOT NULL,
    FECHA                   DATE               NOT NULL,
    OBSERVACIONES           VARCHAR2(500),

    CONSTRAINT PK_CONSULTA
        PRIMARY KEY (ID_CONSULTA),

    CONSTRAINT FK_CONSULTA_HISTORIAL
        FOREIGN KEY (ID_HISTORIAL)
        REFERENCES HISTORIAL_CLINICO(ID_HISTORIAL),

    CONSTRAINT FK_CONSULTA_DOCTOR
        FOREIGN KEY (ID_MEDICO)
        REFERENCES DOCTOR(ID_MEDICO),

    CONSTRAINT FK_CONSULTA_CITA
        FOREIGN KEY (ID_CITA)
        REFERENCES CITA(ID_CITA),

    CONSTRAINT UQ_CONSULTA_CITA
        UNIQUE (ID_CITA)
);

---------------------------------------------------------
-- TABLA: DIAGNOSTICO
---------------------------------------------------------

CREATE TABLE DIAGNOSTICO (
    ID_DIAGNOSTICO         NUMBER(10)         NOT NULL,
    ID_CONSULTA            NUMBER(10)         NOT NULL,
    CODIGO_CIE10           VARCHAR2(10)       NOT NULL,
    DESCRIPCION            VARCHAR2(300)      NOT NULL,
    FECHA                  DATE               NOT NULL,

    CONSTRAINT PK_DIAGNOSTICO
        PRIMARY KEY (ID_DIAGNOSTICO),

    CONSTRAINT FK_DIAGNOSTICO_CONSULTA
        FOREIGN KEY (ID_CONSULTA)
        REFERENCES CONSULTA(ID_CONSULTA)
);

---------------------------------------------------------
-- TABLA: RECETA
---------------------------------------------------------

CREATE TABLE RECETA (
    ID_RECETA              NUMBER(10)         NOT NULL,
    ID_CONSULTA            NUMBER(10)         NOT NULL,
    FECHA                  DATE               NOT NULL,
    OBSERVACIONES          VARCHAR2(300),

    CONSTRAINT PK_RECETA
        PRIMARY KEY (ID_RECETA),

    CONSTRAINT FK_RECETA_CONSULTA
        FOREIGN KEY (ID_CONSULTA)
        REFERENCES CONSULTA(ID_CONSULTA)
);

---------------------------------------------------------
-- TABLA: DETALLE_RECETA
---------------------------------------------------------

CREATE TABLE DETALLE_RECETA (
    ID_DETALLE             NUMBER(10)         NOT NULL,
    ID_RECETA              NUMBER(10)         NOT NULL,
    ID_MEDICAMENTO         NUMBER(10)         NOT NULL,
    CANTIDAD               NUMBER(10)         NOT NULL,
    DOSIS                  VARCHAR2(50)       NOT NULL,
    INDICACIONES           VARCHAR2(300),

    CONSTRAINT PK_DETALLE_RECETA
        PRIMARY KEY (ID_DETALLE),

    CONSTRAINT FK_DETALLE_RECETA
        FOREIGN KEY (ID_RECETA)
        REFERENCES RECETA(ID_RECETA),

    CONSTRAINT FK_DETALLE_MEDICAMENTO
        FOREIGN KEY (ID_MEDICAMENTO)
        REFERENCES MEDICAMENTO(ID_MEDICAMENTO),

    CONSTRAINT CHK_DETALLE_CANTIDAD
        CHECK (CANTIDAD > 0)
);

---------------------------------------------------------
-- TABLA: TRATAMIENTO
---------------------------------------------------------

CREATE TABLE TRATAMIENTO (
    ID_TRATAMIENTO         NUMBER(10)         NOT NULL,
    ID_CONSULTA            NUMBER(10)         NOT NULL,
    ID_MEDICAMENTO         NUMBER(10)         NOT NULL,
    DOSIS                  VARCHAR2(50)       NOT NULL,
    FRECUENCIA             VARCHAR2(50)       NOT NULL,
    DURACION_DIAS          NUMBER(10)         NOT NULL,
    FECHA_INICIO           DATE               NOT NULL,

    CONSTRAINT PK_TRATAMIENTO
        PRIMARY KEY (ID_TRATAMIENTO),

    CONSTRAINT FK_TRATAMIENTO_CONSULTA
        FOREIGN KEY (ID_CONSULTA)
        REFERENCES CONSULTA(ID_CONSULTA),

    CONSTRAINT FK_TRATAMIENTO_MEDICAMENTO
        FOREIGN KEY (ID_MEDICAMENTO)
        REFERENCES MEDICAMENTO(ID_MEDICAMENTO),

    CONSTRAINT CHK_TRATAMIENTO_DIAS
        CHECK (DURACION_DIAS > 0)
);

---------------------------------------------------------
-- TABLA: ALERGIA
---------------------------------------------------------

CREATE TABLE ALERGIA (
    ID_ALERGIA             NUMBER(10)         NOT NULL,
    ID_PACIENTE            NUMBER(10)         NOT NULL,
    NOMBRE_ALERGIA         VARCHAR2(100)      NOT NULL,
    TIPO                   VARCHAR2(50),
    SEVERIDAD              VARCHAR2(20),

    CONSTRAINT PK_ALERGIA
        PRIMARY KEY (ID_ALERGIA),

    CONSTRAINT FK_ALERGIA_PACIENTE
        FOREIGN KEY (ID_PACIENTE)
        REFERENCES PACIENTE(ID_PACIENTE),

    CONSTRAINT CHK_ALERGIA_SEVERIDAD
        CHECK (SEVERIDAD IN ('LEVE','MODERADA','GRAVE'))
);

---------------------------------------------------------
-- TABLA: ANTECEDENTE_MEDICO
---------------------------------------------------------

CREATE TABLE ANTECEDENTE_MEDICO (
    ID_ANTECEDENTE         NUMBER(10)         NOT NULL,
    ID_PACIENTE            NUMBER(10)         NOT NULL,
    TIPO                   VARCHAR2(20)       NOT NULL,
    DESCRIPCION            VARCHAR2(300),
    FECHA_REGISTRO         DATE               NOT NULL,

    CONSTRAINT PK_ANTECEDENTE_MEDICO
        PRIMARY KEY (ID_ANTECEDENTE),

    CONSTRAINT FK_ANTECEDENTE_PACIENTE
        FOREIGN KEY (ID_PACIENTE)
        REFERENCES PACIENTE(ID_PACIENTE)
);

---------------------------------------------------------
-- TABLA: INDICADOR_SALUD
---------------------------------------------------------

CREATE TABLE INDICADOR_SALUD (
    ID_INDICADOR           NUMBER(10)         NOT NULL,
    ID_PACIENTE            NUMBER(10)         NOT NULL,
    TIPO_INDICADOR         VARCHAR2(50)       NOT NULL,
    VALOR                  NUMBER(10,2)       NOT NULL,
    UNIDAD_MEDIDA          VARCHAR2(20)       NOT NULL,
    FECHA_REGISTRO         DATE               NOT NULL,

    CONSTRAINT PK_INDICADOR_SALUD
        PRIMARY KEY (ID_INDICADOR),

    CONSTRAINT FK_INDICADOR_PACIENTE
        FOREIGN KEY (ID_PACIENTE)
        REFERENCES PACIENTE(ID_PACIENTE)
);

---------------------------------------------------------
-- TABLA: SEGURO_MEDICO
---------------------------------------------------------

CREATE TABLE SEGURO_MEDICO (
    ID_SEGURO              NUMBER(10)         NOT NULL,
    ID_PACIENTE            NUMBER(10)         NOT NULL,
    ASEGURADORA            VARCHAR2(100)      NOT NULL,
    NUMERO_POLIZA          VARCHAR2(50)       NOT NULL,
    FECHA_VENCIMIENTO      DATE               NOT NULL,

    CONSTRAINT PK_SEGURO_MEDICO
        PRIMARY KEY (ID_SEGURO),

    CONSTRAINT FK_SEGURO_PACIENTE
        FOREIGN KEY (ID_PACIENTE)
        REFERENCES PACIENTE(ID_PACIENTE),

    CONSTRAINT UQ_POLIZA
        UNIQUE (NUMERO_POLIZA)
);

---------------------------------------------------------
-- TABLA: FACTURA
---------------------------------------------------------

CREATE TABLE FACTURA (
    ID_FACTURA             NUMBER(10)         NOT NULL,
    ID_CONSULTA            NUMBER(10)         NOT NULL,
    FECHA                  DATE               NOT NULL,
    SUBTOTAL               NUMBER(10,2)       NOT NULL,
    IMPUESTO               NUMBER(10,2)       NOT NULL,
    TOTAL                  NUMBER(10,2)       NOT NULL,
    ESTADO                 VARCHAR2(20)       NOT NULL,

    CONSTRAINT PK_FACTURA
        PRIMARY KEY (ID_FACTURA),

    CONSTRAINT FK_FACTURA_CONSULTA
        FOREIGN KEY (ID_CONSULTA)
        REFERENCES CONSULTA(ID_CONSULTA),

    CONSTRAINT CHK_FACTURA_ESTADO
        CHECK (ESTADO IN ('PENDIENTE','PAGADA','ANULADA'))
);

---------------------------------------------------------
-- TABLA: PAGO
---------------------------------------------------------

CREATE TABLE PAGO (
    ID_PAGO                NUMBER(10)         NOT NULL,
    ID_FACTURA             NUMBER(10)         NOT NULL,
    FECHA                  DATE               NOT NULL,
    MONTO                  NUMBER(10,2)       NOT NULL,
    METODO_PAGO            VARCHAR2(30)       NOT NULL,
    REFERENCIA             VARCHAR2(50),
    OBSERVACIONES          VARCHAR2(300),

    CONSTRAINT PK_PAGO
        PRIMARY KEY (ID_PAGO),

    CONSTRAINT FK_PAGO_FACTURA
        FOREIGN KEY (ID_FACTURA)
        REFERENCES FACTURA(ID_FACTURA),

    CONSTRAINT CHK_MONTO_PAGO
        CHECK (MONTO > 0)
);

---------------------------------------------------------
-- TABLA: AUDITORIA
---------------------------------------------------------

CREATE TABLE AUDITORIA (
    ID_AUDITORIA           NUMBER(10)         NOT NULL,
    ID_USUARIO             NUMBER(10)         NOT NULL,
    TABLA_AFECTADA         VARCHAR2(50)       NOT NULL,
    ACCION                 VARCHAR2(20)       NOT NULL,
    FECHA                  TIMESTAMP          DEFAULT CURRENT_TIMESTAMP NOT NULL,

    CONSTRAINT PK_AUDITORIA
        PRIMARY KEY (ID_AUDITORIA),

    CONSTRAINT FK_AUDITORIA_USUARIO
        FOREIGN KEY (ID_USUARIO)
        REFERENCES USUARIO(ID_USUARIO),

    CONSTRAINT CHK_ACCION_AUDITORIA
        CHECK (ACCION IN ('INSERT','UPDATE','DELETE','LOGIN','LOGOUT'))
);

