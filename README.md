### sample readme, will be edited later once everything is done

# Environment
- **DBMS**: MySQL Community Server 8.4.11
- **Client**: DBeaver Community 26.2.4.202611012052
- **Dialect and storage engine**: MySQL 8.4; all seven base tables use InnoDB
- **Prerequisites**: A course user account with standard privileges (`CREATE`, `DROP`, `SELECT`, `INSERT`, `UPDATE`, `DELETE`, `CREATE VIEW`, `INDEX`, `ALTER`) on the target database.
- **Database Name**: `comp2411_g069`
- **Approval Reference**: None (Standard catalogue scenario D11-W05)

# Build
Start with an empty dedicated database named `comp2411_g069`, created by the evaluator or local administrator. Select it as the active database in DBeaver before running the construction scripts. The scripts create project objects and data; they do not create the database or user accounts.

For a local rebuild, first preserve any results or work you need. Have the local administrator remove and recreate only the dedicated project database, then reconnect and select it. This deletes its existing tables, views and data.

Execute the four construction scripts in strict numerical order:
1. `sql/01_schema.sql`: Creates all 7 base relational tables, primary keys, foreign keys, and CHECK constraints.
2. `sql/02_data.sql`: Populates realistic synthetic seed data in dependency order.
3. `sql/03_views.sql`: Creates `v_item_balance`, which calculates each item's current stock balance.
4. `sql/04_indexes.sql`: Implements justified secondary indexes to optimize operational lookups.

# Queries
- Export query results from the freshly constructed seed baseline, before tests modify the data. Include column headers. Represent SQL NULL as `\N` and leave empty strings empty.
- Each query file contains one business `SELECT` statement and is executed directly on the freshly built seed database.
- Business queries are stored under `queries/Q01.sql` through `queries/Q08.sql`.
- Corresponding captured outputs are located under `evidence/query_results/Q01.csv` through `evidence/query_results/Q08.csv`.
- Query metadata, business rationale, and relational techniques are cataloged in `evidence/query_map.csv`.

# Tests
Start each test from the seed baseline unless its exact prerequisites are documented. To restore the baseline, recreate the empty dedicated project database as described under Build, then execute construction scripts 01–04 in order. Rerunning the scripts over existing tables does not reset the database.
Negative tests that fail as expected and leave the relevant data unchanged can be run consecutively when their documented prerequisites still hold. Positive and commit tests modify the baseline; rebuild before subsequent tests that require fresh seed data.
Tests were executed with session autocommit enabled (`@@SESSION.autocommit = 1`). The transaction scripts explicitly use `START TRANSACTION` and end with `COMMIT` or a manually executed `ROLLBACK`. Keep all blocks of each transaction test in the same connection.
- **Positive Tests**: Run `tests/positive.sql` in a single execution block to verify valid inserts, updates, and deletes.
- **Commit Transaction**: Run `tests/transaction_commit.sql` from the seed baseline in the same connection. The script explicitly starts a transaction, inserts a receipt header and line, and commits. Verify that header and line counts increase from 7 to 8 and 18 to 19 respectively, and that the new receipt contains item 1 with quantity 50.
- **Rollback Transaction**: Run `tests/transaction_rollback.sql` in separate blocks using the same connection. Execute the baseline checks, transaction start, header insert and valid first-line insert. Then execute the stock check and guarded second-line insert, which should fail with Error 3819 (`check_quantity`). After the error, manually execute `ROLLBACK`, followed by the verification queries. Confirm that the temporary header and first line are absent, counts return to 7 headers and 18 lines, and FOOD-001 and SHAM-001 balances return to 1500 and 500. Do not run the entire file unattended; an error alone does not roll back the earlier successful statements.
- **Negative Tests**: Files under `tests/negative/` (e.g., `N01.sql`) contain deliberate failure checks. Execute each file individually. Rejection prevents invalid data insertion, leaving existing records unchanged.

# Limitations
- **Enforced via Database Constraints**:
  - Foreign keys enforce valid references and restrict deletion or key changes of referenced parents. They do not enforce the requirement that every movement has at least one line.
  - Strict movement classification: `RECEIPT` movements must specify a `supplier_id` and no `activity_id`; `ISSUE` movements must specify an `activity_id` and no `supplier_id` (BR03, enforced via `check_br03`).
  - Positive quantities (`quantity > 0`) and non-negative reorder levels and unit prices.
- **Checked via SQL / Application Logic**:
  - Verification that an item belongs to the supplier's approved catalog (`ItemSupplier`) prior to receipt line creation (BR06).
  - Verification that issue quantity does not exceed calculated real-time stock balance prior to issue commitment (BR07).
- **Documented Limitations**:
  - Automated recurring reorder notifications, background daemon processes, and multi-user concurrent stock locking are out of project scope and managed manually.

# File inventory
- `metadata.json`: Machine-readable project configuration and group metadata.
- `ai_usage.md`: AI tool assistance declaration.
- `report.pdf`: Complete Stage 2 report including final ER, data dictionary, query analysis, and test logs.
- `contribution.pdf`: Signed contribution declaration form.
- `presentation.pdf`: Presentation slides for in-person demonstration.
- `sql/`:
  - `01_schema.sql`: Table definitions and relational constraints.
  - `02_data.sql`: Synthetic seed dataset.
  - `03_views.sql`: Database view definitions.
  - `04_indexes.sql`: Justified index definitions.
- `queries/`: Distinct analytical and operational queries (`Q01.sql`–`Q08.sql`).
- `tests/`:
  - `positive.sql`: Normal case operational validation.
  - `transaction_commit.sql`: Two-step transaction commit test.
  - `transaction_rollback.sql`: Guarded inventory rollback test.
  - `negative/`: Isolated constraint and business rule violation scripts.
- `evidence/`:
  - `query_map.csv`: Mapping of queries to business questions and techniques.
  - `test_cases.csv`: Machine-readable test execution log.
  - `query_results/`: Exported query outputs (`Q01.csv`–`Q08.csv`).