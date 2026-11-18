-- N17: Reject a duplicate item code within one supplier (BR11).
-- Prerequisite: supplier 1 uses HP-FOOD-01 for item 1 and HP-GLOVE-01 for item 3
-- Expected error: 1062 (SQLSTATE 23000), unique_supplier_item_code
-- Expected outcome: item 3 retains supplier code HP-GLOVE-01

UPDATE ItemSupplier
SET supplier_item_code = 'HP-FOOD-01'
WHERE item_id = 3 AND supplier_id = 1;