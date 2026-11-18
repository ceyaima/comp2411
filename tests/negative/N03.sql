-- N03: Reject a negative reorder level (BR01).
-- Prerequisite: baseline seed data; item_id 1 has reorder_level 2000
-- Expected error: 3819 (SQLSTATE HY000), check_item_reorder
-- Expected outcome: item_id 1 retains reorder_level 2000

UPDATE Item
SET reorder_level = -1
WHERE item_id = 1;