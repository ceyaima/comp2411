-- N05: Reject a nonexistent staff reference (BR02).
-- Prerequisite: movement_id 1 has staff_id 1; staff_id 99999 is absent
-- Expected error: 1452 (SQLSTATE 23000), fk_stockmovement_staff
-- Expected outcome: movement_id 1 retains staff_id 1

UPDATE StockMovement
SET staff_id = 99999
WHERE movement_id = 1;