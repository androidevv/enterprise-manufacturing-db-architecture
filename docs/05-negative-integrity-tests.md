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
