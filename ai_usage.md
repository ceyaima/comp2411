# AI Assistance Declaration - Stage 2

## Tool used

Codex / Claude

## Purpose and scope of assistance

- Assistance interpreting setup instructions, inspecting existing SQL, and preparing an initial implementation of Mikel's balance view and four queries. AI identified that the originally planned Q05 duplicated Daphne's implemented Q08 since she got it mixed up initially.

- Assistance structuring the testing framework according to project guidelines (6.4, 6.4.1, 9.4). AI provided suggestions on structuring the multi-statement commit and rollback patterns, drafting test templates for positive and negative cases (BR06, BR07) and structuring `evidence/test_cases.csv`

- On 15 November 2026, Mikel and Candice took over the seed-data and database-constraint testing tasks previously assigned to Khalia. This is where Codex supplied draft SQL and helped correct any faulty tests.

## Affected files and sections

- `sql/02_data.sql`, `sql/03_views.sql`
- `queries/`
- `tests/positive.sql`, `tests/transaction_commit.sql`, `tests/transaction_rollback.sql`, `tests/negative/`
- `evidence/query_map.csv`, `evidence/test_cases.csv`

## Suggestions accepted, adapted, or rejected

- AI suggested using `LAST_INSERT_ID()` and dynamic subquery lookups in test scripts so test execution does not break while seed data is being finalized. Accepted.

- AI suggested implementing BR07 (stock overdraw guard) as the dedicated multi-statement rollback test in `tests/transaction_rollback.sql`, using session variables and a conditional stock check followed by manually executed ROLLBACK. Accepted.

- AI suggested separating the BR06 supplier link check into an isolated negative test script (`tests/negative/N01.sql`) with a documented expected error code, rather than mixing it with construction scripts. Accepted.

## Verification by the group

- Team member Mikel reported on 7 November 2026 that the view and four query files executed successfully in his local MySQL environment. Codex also checked portable SQL logic using temporary SQLite fixtures.
- On 10 November 2026, Candice reviewed the test scripts to verify MySQL 8.4 syntax compliance:
  - Confirmed that transaction test blocks exclude DDL statements to avoid implicit commits in MySQL InnoDB.
  - Checked that before/after verification queries in `transaction_commit.sql` and `transaction_rollback.sql` prove state persistence and complete reversal respectively.
  - Verified that `test_cases.csv` matches the required 8-column schema and status conventions.
- Executed Q01-Q08 and exported CSV results on November 15, double-checking for no errors.