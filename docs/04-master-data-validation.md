# Master-Data Validation Baseline

## 1. Purpose

Record the initial Oracle AI Database 26ai Free schema inventory,
row counts, constraints, and verified relationships for the MFG_OWNER
master-data tables.

## 2. Environment

- Database: Oracle AI Database 26ai Free
- Service: freepdb1
- Schema: MFG_OWNER
- Validation method: Oracle data dictionary queries

## 3. Table Inventory and Row Counts

| Table | Row Count |
|---|---:|
| COMPANIES | 1 |
| CUSTOMERS | 1 |
| ITEMS | 2 |
| SITES | 1 |
| SUPPLIERS | 1 |
| UOMS | 2 |
| WAREHOUSES | 2 |
| **Total** | **10** |

These counts are the observed baseline at the time of inspection.
They may change as the project evolves.

## 4. Constraint Summary

| Constraint Type | Count | Observed Status |
|---|---:|---|
| Primary keys | 7 | Enabled and validated |
| Unique constraints | 7 | Enabled and validated |
| Foreign keys | 3 | Enabled and validated |
| Check constraints | 26 | Enabled and validated |
| **Total** | **43** | **Enabled and validated** |

## 5. Verified Unique Business Codes

| Table | Unique Column |
|---|---|
| COMPANIES | COMPANY_CODE |
| CUSTOMERS | CUSTOMER_CODE |
| ITEMS | ITEM_CODE |
| SITES | SITE_CODE |
| SUPPLIERS | SUPPLIER_CODE |
| UOMS | UOM_CODE |
| WAREHOUSES | WAREHOUSE_CODE |

Each code is unique within its own table. Cross-table code uniqueness
has not been established as a requirement.

## 6. Verified Foreign-Key Relationships

| Child Table.Column | Parent Table.Column |
|---|---|
| SITES.COMPANY_ID | COMPANIES.COMPANY_ID |
| WAREHOUSES.SITE_ID | SITES.SITE_ID |
| ITEMS.UOM_ID | UOMS.UOM_ID |

All three foreign keys were observed as ENABLED and VALIDATED.

## 7. Verified Item-Type Rule

The ITEMS table enforces:

ITEM_TYPE IN ('RAW','FINISHED')

The ITEM_ID, ITEM_CODE, ITEM_NAME, ITEM_TYPE, and UOM_ID columns
are also protected by NOT NULL constraints.

The inspected schema additionally enforces required identifier,
code, and name fields on the other master-data tables.

## 8. Validation Scope and Limitations

This baseline records Oracle dictionary metadata and observed row counts.
It does not by itself prove that all business scenarios have been tested.

The following remain separate validation activities:

- Duplicate-code rejection tests
- Invalid foreign-key rejection tests
- Invalid item-type rejection tests
- Transaction rollback tests
- Repeatable deployment and regression tests
- Query-performance measurements
- Backup and recovery validation

No production-scale performance, availability, or recovery claims are
made by this baseline.

## 9. Evidence Source

Results were obtained from read-only queries against USER_TABLES,
USER_CONSTRAINTS, and USER_CONS_COLUMNS in the MFG_OWNER schema.

Constraint names currently include Oracle-generated SYS_C names.
Naming-standard improvements, if required, should be implemented through
a reviewed and repeatable schema migration.
