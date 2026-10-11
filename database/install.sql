-- Run only in a dedicated, empty target schema.
-- Do not run against the populated MFG_OWNER schema.
WHENEVER SQLERROR EXIT SQL.SQLCODE
WHENEVER OSERROR EXIT FAILURE
SET ECHO ON

PROMPT === Creating manufacturing master-data tables ===
@C:\AI-Engineer\enterprise-manufacturing-db-architecture\database\ddl\01_create_master_tables.sql

PROMPT === Validating manufacturing master-data tables ===
@C:\AI-Engineer\enterprise-manufacturing-db-architecture\database\ddl\02_validate_master_tables.sql

EXIT SUCCESS