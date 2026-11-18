-- Q04: Which items have fewer than two recorded suppliers?
-- Techniques: join;group_by;having;null_handling
-- Expected Result on the baseline seed data:
-- Five items have fewer than two suppliers:
-- PAD-001 has zero, and COMB-001, GLOVE-001, TREAT-001 and WIPE-001 each have one.

SELECT item_code, item_name, COUNT(supplier_id) AS supplier_count
FROM Item
LEFT JOIN ItemSupplier
USING (item_id)
GROUP BY item_id
HAVING COUNT(supplier_id) < 2
ORDER BY supplier_count, item_code;