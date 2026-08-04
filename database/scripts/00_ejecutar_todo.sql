-- Este script corre los 8 scripts en el orden correcto, uno detrás de otro.
-- Sirve para no tener que escribirlos uno por uno a mano.

-- Sin esto, sqlplus corta las instrucciones SQL cada vez que encuentra
-- una línea en blanco dentro de una tabla/vista/etc, y eso rompe todo.
SET SQLBLANKLINES ON
SET DEFINE OFF

@@01_tables.sql
@@02_sequences.sql
@@03_triggers.sql
@@04_procedures.sql
@@05_functions.sql
@@06_views.sql
@@07_packages.sql
@@08_seed.sql

EXIT;
