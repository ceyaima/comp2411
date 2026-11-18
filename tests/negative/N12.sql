-- N12: Reject zero movement quantity (BR05).
-- Prerequisite: movement 1 item 1 has quantity 2000
-- Expected error: 3819 (SQLSTATE HY000), check_quantity
-- Expected outcome: quantity remains 2000

UPDATE StockMovementLine
SET quantity = 0
WHERE movement_id = 1 AND item_id = 1;