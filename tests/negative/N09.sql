-- N09: Reject an issue without a service activity (BR03).
-- Prerequisite: movement 4 is an ISSUE with activity_id 1
-- Expected error: 3819 (SQLSTATE HY000), check_br03
-- Expected outcome: movement 4 retains activity_id 1

UPDATE StockMovement
SET activity_id = NULL
WHERE movement_id = 4;