# PRISMA

## Clinical Information Management & Consolidation System

PRISMA is a full-stack academic web application designed to centralize and manage clinical information through an integrated system powered by **Oracle Database, SQL, and PL/SQL**.

The project was developed as the final project for the **SC-504 Database Languages** course at **Universidad Fidélitas** during the second academic term of 2026.

PRISMA integrates a web interface, a PHP backend, and an Oracle database to manage patients, doctors, appointments, consultations, treatments, medications, users, and clinical information.

---

## Project Overview

The main objective of PRISMA was to design and implement a relational database solution capable of managing clinical information while applying advanced database concepts in a functional web application.

A significant portion of the application's business and data-access logic is implemented directly in Oracle using **SQL and PL/SQL**.

The final implementation integrates:

- Web interface
- PHP backend
- Oracle Database
- SQL and PL/SQL
- OCI8 connectivity
- Authentication and sessions
- Role-based access control
- Database-driven reports
- Docker-based development environment

All information used by the system represents simulated academic scenarios.

---

## Key Features

- Patient management
- Doctor and specialty management
- Appointment management
- Clinical consultation management
- Treatment management
- Medication catalog
- User management
- Role management
- Authentication and session handling
- Role-based access control
- Dashboard with KPIs and charts
- Database-driven reports
- Account configuration
- Data validation
- Integrated CRUD operations

---

## Technology Stack

| Component | Technology |
| --- | --- |
| Frontend | HTML5, CSS3, Bootstrap, JavaScript |
| Backend | PHP 8.2 |
| Database | Oracle Database |
| Database Languages | SQL, PL/SQL |
| Oracle Connectivity | OCI8 |
| Data Visualization | Chart.js |
| Development Environment | Docker, Docker Compose |
| Version Control | Git, GitHub |

---

## Architecture

PRISMA follows a client-server architecture integrated with Oracle Database:

```text
User
  │
  ▼
Web Interface
HTML5 · CSS3 · Bootstrap · JavaScript
  │
  ▼
Backend
PHP · Sessions · OCI8
  │
  ▼
Oracle Database
SQL · PL/SQL
```

The PHP backend communicates with Oracle Database through **OCI8**.

Database operations and application processes use stored procedures and other PL/SQL objects to centralize data access and business logic.

---

## Core Modules

### Patients

- Patient registration
- Patient information management
- CRUD operations
- Database integration

### Doctors

- Doctor management
- Specialty management
- Integrated CRUD operations

### Appointments

- Appointment management
- Patient integration
- Doctor integration
- Consulting room management

### Clinical Consultations

- Consultation registration
- Consultation management
- Stored procedure integration
- Patient clinical information

### Treatments

- Treatment management
- Consultation integration
- Medication integration

### Medications

- Medication catalog
- Medication management
- Database-connected operations

### Users & Roles

- User management
- Role assignment
- Account status management
- Credentials
- Role-based access control

### Authentication

- Login and logout
- PHP session management
- Oracle-backed authentication
- Internal page protection
- Role validation

### Dashboard

- General indicators
- Clinical KPIs
- Charts and visualizations
- Recent appointments
- Oracle-connected data

### Reports

- Database-generated KPIs
- Charts
- Clinical summaries
- Oracle-based report data

### Configuration

- Authenticated account information
- Account configuration
- User data updates

---

## Oracle Database Implementation

The database layer represents one of the core components of PRISMA.

The project applies multiple Oracle and PL/SQL concepts, including:

- Stored procedures
- PL/SQL functions
- Views
- Packages
- Triggers
- Cursors
- Sequences
- Exception handling
- Transactions
- Data integrity constraints
- Authentication procedures
- Reporting procedures
- CRUD operations

These components allow application logic and data-processing operations to remain structured and centralized within the database layer.

---

## Repository Structure

```text
PRISMA-SC504/
│
├── app/
│   └── Web application source code
│
├── database/
│   └── SQL and PL/SQL scripts
│
├── docs/
│   └── Academic and technical documentation
│
├── docker/
│   └── Development environment configuration
│
├── docker-compose.yml
│
└── README.md
```

### `app/`

Contains the web application, including the user interface, PHP logic, Oracle connectivity, and application modules.

### `database/`

Contains the scripts required to build and configure the database, including tables, sequences, triggers, procedures, functions, views, packages, and initial data.

### `docs/`

Contains academic and technical documentation related to the project.

### `docker/`

Contains the resources used to configure the development environment with Docker.

---

## Development Team

| Team Member |
| --- |
| Emmanuel Rivera Cordero |
| Josué David Montero Hernández |
| Matías Camacho Santamaría |

### My Contribution

My primary contribution to PRISMA focused on the **Oracle database layer and application integration**.

I worked extensively with **SQL and PL/SQL**, contributing to database logic and objects including stored procedures, functions, views, triggers, transactions, and data-processing operations used throughout the application.

I also contributed to the **frontend development** and the integration between **PHP and Oracle Database through OCI8**, connecting application functionality with the database layer.

The project provided hands-on experience with relational database design, PL/SQL development, database-driven application logic, frontend/backend/database integration, debugging, and collaborative software development.

---

## Development Workflow

The project was developed collaboratively using **Git and GitHub**.

Development responsibilities were distributed across the application, database, and integration layers while the team progressively connected each component into the final system.

The project provided practical experience with:

- Collaborative Git workflows
- SQL and PL/SQL development
- Database design
- Stored database logic
- PHP and Oracle integration
- OCI8
- Frontend development
- Debugging and validation
- Full application integration
- Team-based software development

---

## Running the Project

PRISMA uses Docker to provide the PHP and Oracle Database development environment.

### 1. Clone the repository

```bash
git clone https://github.com/josuemonteroh/PRISMA-SC504.git
cd PRISMA-SC504
```

### 2. Start the containers

```bash
docker compose up -d
```

### 3. Verify the containers

```bash
docker compose ps
```

Once Oracle has completed its initialization process, the corresponding database scripts can be executed and the application can be accessed through the configured Docker environment.

---

## Project Status

**Status: Completed**

PRISMA reached its final implementation with functional integration between the web application, PHP backend, and Oracle Database.

The main application modules were completed, including authentication, role-based access control, clinical management, dashboard functionality, and database-driven reporting.

SQL and PL/SQL serve as core components for data management, processing, and application logic.

---

## Academic Context

**University:** Universidad Fidélitas  
**Course:** SC-504 – Database Languages  
**Period:** II Academic Term, 2026  
**Project Type:** Final Academic Project

PRISMA provided practical experience applying database development concepts within a complete web application, including SQL, PL/SQL, Oracle Database, PHP integration, data modeling, version control, and collaborative development.

---

## License

This project was developed for academic and educational purposes as part of the SC-504 Database Languages course at Universidad Fidélitas.

Commercial use is not permitted without authorization from the project authors.

