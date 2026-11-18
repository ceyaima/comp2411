-- N10: Reject an issue with a supplier (BR03).
-- Prerequisite: movement 4 is an ISSUE with activity and no supplier; supplier 1 exists
-- Expected error: 3819 (SQLSTATE HY000), check_br03
-- Expected outcome: movement 4 retains supplier_id NULL

UPDATE StockMovement
SET supplier_id = 1
WHERE movement_id = 4;