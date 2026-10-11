# 03 - Architecture Acceptance Criteria

The project is considered validated only when evidence is recorded for
the relevant criteria.

| ID | Acceptance Criterion | Evidence |
|---|---|---|
| AC-01 | Required business domains are documented | Domain inventory |
| AC-02 | Core entities and relationships are modeled | Conceptual and logical ERDs |
| AC-03 | Required primary and foreign keys are implemented | DDL and constraint tests |
| AC-04 | Duplicate master records are rejected where prohibited | Negative test results |
| AC-05 | Invalid transactions are rejected | Business-rule test results |
| AC-06 | Transaction rollback behaves as designed | Transaction tests |
| AC-07 | Application permissions follow least privilege | Role/grant tests |
| AC-08 | Required audit events are recorded | Audit verification |
| AC-09 | Representative queries have baseline measurements | SQL scripts and timing results |
| AC-10 | Reports reconcile with source transactions | Reconciliation results |
| AC-11 | Deployment scripts can be rerun safely where designed | Repeatability test log |
| AC-12 | Backup/recovery approach is documented | Recovery plan and test evidence |
| AC-13 | Repository setup and execution instructions are complete | README review |
| AC-14 | Test results are reproducible | Versioned scripts and test log |

## Reporting Rule

Each criterion must be marked as:

- NOT STARTED
- IN PROGRESS
- PASSED
- FAILED
- NOT APPLICABLE (with explanation)

Do not mark an item PASSED until supporting evidence exists.
