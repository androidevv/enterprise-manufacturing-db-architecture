# 03 - Architecture Acceptance Criteria

The project is considered validated only when evidence is recorded for
the relevant criteria.

| ID | Acceptance Criterion | Status | Evidence / Remaining Work |
|---|---|---|---|
| AC-01 | Required business domains are documented | IN PROGRESS | See `docs/01-business-problem.md` and `docs/02-requirements.md`; review completeness against all required domains. |
| AC-02 | Core entities and relationships are modeled | IN PROGRESS | Review ERDs in `diagrams/` and verify they match implemented DDL. |
| AC-03 | Required primary and foreign keys are implemented | IN PROGRESS | `docs/04-master-data-validation.md` records 43 enabled, validated constraints; review DDL and relationship coverage before passing. |
| AC-04 | Duplicate master records are rejected where prohibited | PASSED | `docs/04-master-data-validation.md`; duplicate business-code tests are included in `tests/sql/expanded_negative_integrity_tests.sql`. |
| AC-05 | Invalid transactions are rejected | IN PROGRESS | Negative tests cover specified required fields, invalid item types, and foreign keys; broader business-rule coverage remains to be assessed. |
| AC-06 | Transaction rollback behaves as designed | IN PROGRESS | Regression-test changes were rolled back and baseline row counts remained unchanged; dedicated transaction rollback behavior still needs explicit verification. |
| AC-07 | Application permissions follow least privilege | NOT STARTED | Add and execute role/grant tests; document the intended privilege model. |
| AC-08 | Required audit events are recorded | NOT STARTED | Define audit requirements and verify the resulting audit records. |
| AC-09 | Representative queries have baseline measurements | NOT STARTED | Identify representative queries and record repeatable timing and execution-plan evidence. |
| AC-10 | Reports reconcile with source transactions | NOT STARTED | Define reconciliation rules and record source-to-report comparison results. |
| AC-11 | Deployment scripts can be rerun safely where designed | NOT STARTED | Execute deployment scripts against a controlled schema more than once and record outcomes. |
| AC-12 | Backup/recovery approach is documented | NOT STARTED | Document backup/recovery procedures and capture a recovery test. |
| AC-13 | Repository setup and execution instructions are complete | IN PROGRESS | Review `README.md` by following setup and execution instructions from a clean starting point. |
| AC-14 | Test results are reproducible | IN PROGRESS | Four version-controlled SQL test scripts passed 32 assertions in total; rerun from the documented procedure and retain the output log. |

## Reporting Rule

Each criterion must be marked as:

- NOT STARTED
- IN PROGRESS
- PASSED
- FAILED
- NOT APPLICABLE (with explanation)

Do not mark an item PASSED until supporting evidence exists.
