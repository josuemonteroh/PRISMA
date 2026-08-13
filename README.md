# PRISMA

## Sistema de Gestión y Consolidación de Información Clínica

Proyecto final desarrollado para el curso **SC-504 Lenguajes de Base de Datos** de la **Universidad Fidélitas**, II Cuatrimestre 2026.

PRISMA es un sistema web académico diseñado para centralizar la gestión de información clínica mediante una aplicación integrada con **Oracle Database**, utilizando **SQL y PL/SQL** como base para la lógica, procesamiento y administración de los datos.

---

## Descripción

PRISMA permite gestionar de forma centralizada la información asociada a pacientes, médicos, citas, consultas, tratamientos, medicamentos y usuarios.

La aplicación integra una interfaz web con un backend desarrollado en PHP y una base de datos Oracle. Las principales operaciones de negocio y acceso a datos se encuentran implementadas mediante objetos PL/SQL, permitiendo mantener la lógica de la aplicación centralizada y estructurada dentro de la base de datos.

Los datos utilizados en el sistema corresponden a escenarios simulados con fines exclusivamente académicos.

## Objetivo

Diseñar e implementar una solución basada en una **base de datos relacional Oracle** que permita gestionar información clínica de manera organizada, íntegra y disponible, aplicando los conocimientos desarrollados durante el curso en:

* SQL
* PL/SQL
* Procedimientos almacenados
* Funciones
* Vistas
* Paquetes
* Triggers
* Cursores
* Secuencias
* Excepciones
* Integridad y gestión de datos

## Arquitectura

```text
┌─────────────────────────────┐
│           Usuario           │
└──────────────┬──────────────┘
               │
               ▼
┌─────────────────────────────┐
│        Interfaz Web         │
│ HTML · CSS · Bootstrap · JS │
└──────────────┬──────────────┘
               │
               ▼
┌─────────────────────────────┐
│           PHP               │
│ Backend · Sesiones · OCI8   │
└──────────────┬──────────────┘
               │
               ▼
┌─────────────────────────────┐
│       Oracle Database       │
│        SQL · PL/SQL         │
└─────────────────────────────┘
```

La aplicación web se comunica con Oracle desde PHP mediante **OCI8**. Las operaciones principales del sistema utilizan procedimientos almacenados y otros objetos PL/SQL para interactuar con la información.

## Tecnologías

| **Componente**             | **Tecnología**                     |
| -------------------------- | ---------------------------------- |
| Frontend                   | HTML5, CSS3, Bootstrap, JavaScript |
| Backend                    | PHP 8.2                            |
| Base de datos              | Oracle Database                    |
| Lenguajes de base de datos | SQL y PL/SQL                       |
| Conectividad Oracle        | OCI8                               |
| Visualización de datos     | Chart.js                           |
| Contenedores               | Docker / Docker Compose            |
| Control de versiones       | Git / GitHub                       |

## Módulos

| **Módulo**               | **Estado** | **Descripción**                                              |
| ------------------------ | ---------- | ------------------------------------------------------------ |
| Pacientes                | Completo   | CRUD funcional integrado con Oracle.                         |
| Médicos                  | Completo   | CRUD funcional y gestión de especialidades.                  |
| Medicamentos             | Completo   | Gestión del catálogo de medicamentos.                        |
| Usuarios                 | Completo   | CRUD, asignación de roles, estados y credenciales.           |
| Roles                    | Completo   | Gestión de roles y control de acceso.                        |
| Citas                    | Completo   | Gestión integrada de pacientes, médicos y consultorios.      |
| Consultas                | Completo   | CRUD mediante procedimientos almacenados.                    |
| Tratamientos             | Completo   | Gestión integrada con consultas y medicamentos.              |
| Dashboard                | Completo   | Indicadores, gráficas y citas recientes con datos de Oracle. |
| Reportes                 | Completo   | KPIs, gráficas y resúmenes obtenidos desde la base de datos. |
| Configuración            | Completo   | Consulta y actualización de la cuenta autenticada.           |
| Autenticación y sesiones | Completo   | Inicio y cierre de sesión mediante PHP, Oracle y PL/SQL.     |
| Control de acceso        | Completo   | Restricción de navegación y módulos según el rol.            |

## Implementación en Oracle

La capa de base de datos constituye uno de los componentes principales de PRISMA. La lógica necesaria para gestionar y procesar la información se implementa utilizando diferentes objetos y estructuras de Oracle.

El proyecto incorpora:

* Procedimientos almacenados para operaciones CRUD y procesos del sistema.
* Funciones PL/SQL para procesamiento y consulta de información.
* Vistas para facilitar el acceso estructurado a los datos.
* Paquetes para agrupar y centralizar lógica relacionada.
* Triggers para automatización y control de operaciones.
* Cursores para procesamiento de conjuntos de registros.
* Secuencias para generación de identificadores.
* Manejo de excepciones PL/SQL.
* Restricciones para garantizar la integridad de los datos.
* Procedimientos destinados a autenticación y generación de reportes.

## Funcionalidades principales

* Registro y administración de pacientes.
* Gestión de médicos y especialidades.
* Administración de citas médicas.
* Registro y consulta de consultas clínicas.
* Gestión de tratamientos.
* Administración del catálogo de medicamentos.
* Gestión de usuarios y roles.
* Autenticación y manejo de sesiones.
* Control de acceso basado en roles.
* Dashboard con indicadores y visualizaciones.
* Reportes alimentados desde Oracle.
* Gestión de la información de la cuenta autenticada.

## Estructura del repositorio

```text
PRISMA-SC504/
│
├── app/
│   └── Código fuente de la aplicación
│
├── database/
│   └── Scripts SQL y PL/SQL
│
├── docs/
│   └── Documentación y entregables
│
├── docker/
│   └── Configuración del entorno
│
├── docker-compose.yml
└── README.md
```

### `app/`

Contiene la aplicación web, incluyendo la interfaz, lógica PHP, conexión con Oracle y módulos del sistema.

### `database/`

Contiene los scripts necesarios para construir y configurar la base de datos, incluyendo tablas, secuencias, triggers, procedimientos, funciones, vistas, paquetes y datos iniciales.

### `docs/`

Contiene la documentación académica y técnica relacionada con el desarrollo del proyecto.

### `docker/`

Contiene los recursos complementarios utilizados para configurar el entorno mediante Docker.

## Ejecución

El proyecto utiliza Docker para facilitar la ejecución de la aplicación PHP y Oracle Database.

### 1. Clonar el repositorio

```bash
git clone https://github.com/josuemonteroh/PRISMA-SC504.git
cd PRISMA-SC504
```

### 2. Levantar los contenedores

```bash
docker compose up -d
```

### 3. Verificar los contenedores

```bash
docker compose ps
```

Una vez que Oracle haya terminado su proceso de inicialización, se pueden ejecutar los scripts correspondientes de la base de datos y acceder a la aplicación desde el entorno configurado en Docker.

## Integrantes

| **Integrante**                |
| ----------------------------- |
| Antony Mora Castro            |
| Emmanuel Rivera Cordero       |
| Josué David Montero Hernández |
| Matías Camacho Santamaría     |

## Contexto académico

**Universidad:** Universidad Fidélitas
**Curso:** SC-504 – Lenguajes de Base de Datos
**Periodo:** II Cuatrimestre 2026
**Tipo:** Proyecto final académico

## Estado

**Proyecto finalizado**

PRISMA cuenta con integración funcional entre la aplicación web, PHP y Oracle Database. Los módulos principales se encuentran implementados y la solución incorpora SQL y PL/SQL como componentes centrales para la gestión y procesamiento de la información.

---

### PRISMA · SC-504

**Universidad Fidélitas · II Cuatrimestre 2026**

