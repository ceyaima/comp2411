-- N18: Reject a negative supplier quote (BR11).
-- Prerequisite: item 1 supplier 1 has unit_price 0.0400
-- Expected error: 3819 (SQLSTATE HY000), check_unitprice
-- Expected outcome: unit_price remains 0.0400

UPDATE ItemSupplier
SET unit_price = -0.0100
WHERE item_id = 1 AND supplier_id = 1;