-- N07: Reject a receipt without a supplier (BR03).
-- Prerequisite: movement 1 is a RECEIPT with supplier_id 1
-- Expected error: 3819 (SQLSTATE HY000), check_br03
-- Expected outcome: movement 1 retains supplier_id 1

UPDATE StockMovement
SET supplier_id = NULL
WHERE movement_id = 1;