-- tests/transaction_commit.sql
-- TXC01: commit path with before/after evidence.
-- Run with comp2411_g069 selected as the active database.

-- 1. PRE-TRANSACTION BASELINE EVIDENCE
SELECT 'Pre-transaction count of StockMovement' AS check_point, COUNT(*) AS count_val FROM StockMovement;
SELECT 'Pre-transaction count of StockMovementLine' AS check_point, COUNT(*) AS count_val FROM StockMovementLine;

-- 2. TRANSACTION EXECUTION
START TRANSACTION;

-- Step 1: Create the receipt movement header
INSERT INTO StockMovement (movement_type, movement_datetime, staff_id, supplier_id, activity_id)
VALUES ('RECEIPT', NOW(), 1, 1, NULL);

-- Step 2: Insert receipt movement line (receiving 50 units of item_id 1)
INSERT INTO StockMovementLine (movement_id, item_id, quantity)
VALUES (LAST_INSERT_ID(), 1, 50);

-- Commit transaction atomically
COMMIT;

-- 3. POST-TRANSACTION PERSISTENCE EVIDENCE
SELECT 'Post-transaction count of StockMovement' AS check_point, COUNT(*) AS count_val FROM StockMovement;
SELECT 'Post-transaction count of StockMovementLine' AS check_point, COUNT(*) AS count_val FROM StockMovementLine;

-- Verify the newly persisted record
SELECT sm.movement_id, sm.movement_type, sm.staff_id, sm.supplier_id, sml.item_id, sml.quantity
FROM StockMovement sm
JOIN StockMovementLine sml ON sm.movement_id = sml.movement_id
ORDER BY sm.movement_id DESC
LIMIT 1;

