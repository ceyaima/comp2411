-- N06: Reject a missing staff reference (BR02).
-- Prerequisite: movement_id 1 has staff_id 1
-- Expected error: 1048 (SQLSTATE 23000)
-- Expected outcome: movement_id 1 retains staff_id 1

UPDATE StockMovement
SET staff_id = NULL
WHERE movement_id = 1;