# to be deleted when report is made

#### 4.1 Summary of Test Results

| Test ID | Rule / Objective | Script | Starting State | Expected Outcome | Actual Result | Status |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **POS01** | Item Catalog Intake | `tests/positive.sql` | Baseline seed data | Insert item `MED-EAR-001` | Record inserted successfully | **PASS** |
| **POS02** | Supplier Catalog Setup | `tests/positive.sql` | Item `MED-EAR-001` exists | Link item to Supplier 1 | Linked with code `SUP-VET-EAR-99` | **PASS** |
| **POS03** | Service Activity Intake | `tests/positive.sql` | Baseline seed data | Add grooming service activity | Activity `ACT-2026-TEST01` added | **PASS** |
| **POS04** | Inventory Update | `tests/positive.sql` | Item `MED-EAR-001` exists | Increase `reorder_level` by 100 | Reorder level updated | **PASS** |
| **POS05** | Service Cleanup | `tests/positive.sql` | Activity exists | Delete `ACT-2026-TEST01` | Row deleted cleanly | **PASS** |
| **TXC01** | Multi-statement Commit | `tests/transaction_commit.sql` | Baseline seed data | Both header and line persist on `COMMIT` | All changes persisted to DB | **PASS** |
| **TXR01** | **BR07** Stock Overdraw Guard | `tests/transaction_rollback.sql` | Baseline seed data | Overdraw detected; header rolled back | All pre-transaction states restored | **PASS** |
| **N01** | **BR06** Supplier Link Check | `tests/negative/N01.sql` | Receipt header created | Receipt line rejected (item not supplied) | Blocked with Error 3819 (`HY000`) | **PASS** |

#### 4.2 Analytical Evaluation of Test Outcomes
- **Commit Path Verification (`TXC01`):** Demonstrates that operational receipts comprising parent records in `StockMovement` and child records in `StockMovementLine` enforce atomic persistence. Pre- and post-transaction row counts confirm that partial writes do not occur.
- **Rollback Path Verification (`TXR01`):** Evaluates business rule BR07. After successfully inserting an issue header and its first line, the script checks a second requested quantity against available stock. Insufficient stock produces a zero quantity, which `check_quantity` rejects with Error 3819. Explicitly executing `ROLLBACK` in the same connection removes the temporary header and first line. Post-rollback checks confirm that row counts and stock balances match the baseline.
- **Supplier Constraint Enforcement (`N01`):** Demonstrates the explicit SQL check for BR06. Before inserting a receipt line, the statement checks whether the supplier offers the item in `ItemSupplier`. A missing link produces a zero quantity, which `check_quantity` rejects with Error 3819. Verification confirms that no line was inserted and the line count remained unchanged. Direct inserts that bypass this SQL check do not enforce BR06.

---

