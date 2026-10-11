# Fresh-Install Deployment Validation

## Environment
- Database: Oracle AI Database 26ai Free
- PDB/service: FREEPDB1
- Test schema: MFG_DEPLOY_TEST
- Installation entry point: database/install.sql

## Result

Status: PASSED

The deployment package was executed in a separate test schema,
without using the existing MFG_OWNER schema.

### Validated object counts

| Object / rule | Expected | Actual | Result |
|---|---:|---:|---|
| Master-data tables | 7 | 7 | PASS |
| Primary keys | 7 | 7 | PASS |
| Unique constraints | 7 | 7 | PASS |
| Foreign keys | 3 | 3 | PASS |
| ITEM_TYPE check constraint | 1 | 1 | PASS |

Validation output ended with:

`VALIDATION PASSED`

## Deployment files

- `database/install.sql`
- `database/ddl/01_create_master_tables.sql`
- `database/ddl/02_validate_master_tables.sql`

## Scope and limitations

This test validates fresh schema creation and selected constraint
counts in MFG_DEPLOY_TEST. It does not yet prove seed-data
deployment, repeatability from a reset schema, least-privilege
security, performance, or backup and recovery.

The existing MFG_OWNER schema was preserved.