-- tests/transaction_rollback.sql
-- TXR01: setup, failure, explicit ROLLBACK, verification (run blocks in one connection).
-- Run with comp2411_g069 selected as the active database.

-- 1. PRE-TRANSACTION EVIDENCE
SELECT 'Pre-rollback StockMovement count' AS stage, COUNT(*) AS cnt FROM StockMovement;
SELECT 'Pre-rollback StockMovementLine count' AS stage, COUNT(*) AS cnt FROM StockMovementLine;

-- Record baseline item balance
SELECT 
    i.item_id, 
    i.item_name,
    COALESCE(SUM(CASE WHEN sm.movement_type = 'RECEIPT' THEN sml.quantity ELSE -sml.quantity END), 0) AS current_balance
FROM Item i
LEFT JOIN StockMovementLine sml ON i.item_id = sml.item_id
LEFT JOIN StockMovement sm ON sml.movement_id = sm.movement_id
WHERE i.item_id = 1
GROUP BY i.item_id, i.item_name;

-- 2. TRANSACTION EXECUTION (FAILURE PATH)
START TRANSACTION;

-- Step 1: Insert movement header (Succeeds)
INSERT INTO StockMovement (movement_type, movement_datetime, staff_id, supplier_id, activity_id)
VALUES ('ISSUE', NOW(), 1, NULL, 1);

-- Save generated ID into session variable
SET @new_movement_id = LAST_INSERT_ID();

-- Valid first line: issue 10 units of item 2
INSERT INTO StockMovementLine (movement_id, item_id, quantity)
VALUES (@new_movement_id, 2, 10);

-- Verify this line exists before the later failure
SELECT *
FROM StockMovementLine
WHERE movement_id = @new_movement_id;

-- Step 2: Guarded check for BR07 before adding issue line
SELECT 
    COALESCE(SUM(CASE WHEN sm.movement_type = 'RECEIPT' THEN sml.quantity ELSE -sml.quantity END), 0) INTO @current_stock
FROM StockMovementLine sml
JOIN StockMovement sm ON sml.movement_id = sm.movement_id
WHERE sml.item_id = 1;

-- Attempt to issue more of item 1 than is currently available
SET @requested_quantity = @current_stock + 1;

-- Expected error: 3819 (HY000), check_quantity
-- Insufficient stock produces zero, causing the CHECK to reject the line
INSERT INTO StockMovementLine (movement_id, item_id, quantity)
VALUES (
    @new_movement_id,
    1,
    CASE
        WHEN @requested_quantity > 0
         AND @requested_quantity <= @current_stock
        THEN @requested_quantity
        ELSE 0
    END
);

-- The requested quantity exceeds available stock.
-- After the expected error, manually execute ROLLBACK below in the same connection. Do not execute the whole script at once.
ROLLBACK;

-- 3. POST-ROLLBACK VERIFICATION EVIDENCE (Proving atomicity and undo)
SELECT 'Post-rollback StockMovement count' AS stage, COUNT(*) AS cnt FROM StockMovement;
SELECT 'Post-rollback StockMovementLine count' AS stage, COUNT(*) AS cnt FROM StockMovementLine;

-- Verify header @new_movement_id does NOT exist in StockMovement
SELECT * FROM StockMovement WHERE movement_id = @new_movement_id;

-- The successful first line must also have been rolled back
SELECT *
FROM StockMovementLine
WHERE movement_id = @new_movement_id;

-- Both balances MUST match the baseline
SELECT item_code, current_balance
FROM v_item_balance
WHERE item_id IN (1, 2)
ORDER BY item_id;