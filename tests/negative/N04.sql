-- N04: Reject an unsupported item unit (BR01).
-- Prerequisite: baseline seed data; item_id 1 uses g
-- Expected error: 3819 (SQLSTATE HY000), check_item_unit
-- Expected outcome: item_id 1 retains unit g

UPDATE Item
SET unit = 'kg'
WHERE item_id = 1;