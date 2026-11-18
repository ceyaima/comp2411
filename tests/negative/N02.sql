-- N02: Reject a duplicate item code (BR01).
-- Prerequisite: baseline seed data loaded; FOOD-001 already exists
-- Expected error: 1062 (SQLSTATE 23000), unique_item_code
-- Expected outcome: no new row, so the original item is unchanged

INSERT INTO Item
    (item_code, item_name, unit, reorder_level)
VALUES
    ('FOOD-001', 'Duplicate test item', 'g', 100);