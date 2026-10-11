# Negative Integrity Test Results

## 1. Environment

- Database: Oracle AI Database 26ai Free
- Service: freepdb1
- Schema: MFG_OWNER
- Test type: Negative integrity tests
- Execution: PL/SQL anonymous block with rollback

## 2. Results

| Test | Expected Error | Actual Result | Status |
|---|---|---|---|
| Duplicate COMPANIES.COMPANY_CODE (DEMO) | ORA-00001 | ORA-00001 | PASSED |
| Invalid ITEMS.ITEM_TYPE (INVALID) | ORA-02290 | ORA-02290 | PASSED |
| Invalid ITEMS.UOM_ID (999999999) | ORA-02291 | ORA-02291 | PASSED |

## 3. Baseline Preservation

Post-test row counts matched the previously recorded baseline.

| Table | Expected Rows | Observed Rows |
|---|---:|---:|
| COMPANIES | 1 | 1 |
| CUSTOMERS | 1 | 1 |
| ITEMS | 2 | 2 |
| SITES | 1 | 1 |
| SUPPLIERS | 1 | 1 |
| UOMS | 2 | 2 |
| WAREHOUSES | 2 | 2 |
| **Total** | **10** | **10** |

## 4. Conclusion

All three negative integrity tests passed. Oracle rejected the duplicate
business code, invalid item type, and invalid UOM reference with the
expected error codes. The observed table row counts remained unchanged.

These results validate only the tested scenarios. They do not establish
that every constraint or business process has been tested.

## 5. Follow-up Tests

- Duplicate-code rejection for the remaining six tables
- Required-field rejection
- Invalid company and site foreign-key rejection
- Valid insert and update scenarios
- Transaction rollback and recovery behavior
- Repeatable automated regression tests

## Expanded Regression Test Results

Environment: Oracle AI Database 26ai Free, PDB `FREEPDB1`, schema `MFG_OWNER`.

### Test execution summary

| Test suite | Result | Coverage |
|---|---:|---|
| `negative_integrity_tests.sql` | 3/3 passed | Duplicate company code, invalid item type, invalid UOM reference |
| `expanded_negative_integrity_tests.sql` | 16/16 passed | Duplicate business codes, NULL business codes, invalid company/site references |
| `required_fields_and_item_fk_tests.sql` | 10/10 passed | Required descriptive fields, required item UOM, invalid item UOM reference |

Total: **29 successful negative-test assertions** across the three suites.

### Data-preservation validation

After regression testing, the baseline remained unchanged:

| Table | Rows |
|---|---:|
| `COMPANIES` | 1 |
| `CUSTOMERS` | 1 |
| `ITEMS` | 2 |
| `SITES` | 1 |
| `SUPPLIERS` | 1 |
| `UOMS` | 2 |
| `WAREHOUSES` | 2 |
| **Total** | **10** |

The test DML was rolled back. Oracle identity sequences may advance during rolled-back inserts; this does not mean test rows were retained.

### Reproduction

Connect as `MFG_OWNER` to `FREEPDB1`, then run from the repository root:

```sql
@tests/sql/negative_integrity_tests.sql
@tests/sql/expanded_negative_integrity_tests.sql
@tests/sql/required_fields_and_item_fk_tests.sql
```

All three suites passed in the local development environment. These results validate the tested scenarios, not exhaustive coverage or production readiness.
