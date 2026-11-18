-- N08: Reject a receipt with a service activity (BR03).
-- Prerequisite: movement 1 is a RECEIPT with supplier 1; activity 1 exists and movement 1 has no activity.
-- Expected error: 3819 (SQLSTATE HY000), check_br03
-- Expected outcome: movement 1 retains activity_id NULL

UPDATE StockMovement
SET activity_id = 1
WHERE movement_id = 1;