-- N13: Reject a nonexistent item reference (BR05).
-- Prerequisite: movement 1 item 1 exists; item 99999 is absent
-- Expected error: 1452 (SQLSTATE 23000), fk_stockmovementline_item
-- Expected outcome: the original line remains unchanged

UPDATE StockMovementLine
SET item_id = 99999
WHERE movement_id = 1 AND item_id = 1;