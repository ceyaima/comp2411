-- Q07: Which suppliers offer the lowest known price for each item needing replenishment?
-- Techniques: view;join;join3plus;subquery;correlated;exists;null_handling
-- Prerequisite: sql/03_views.sql; comp2411_g069 selected.
-- Expected result from baseline data:
-- Four cheapest-known-quote rows:
-- BAG-001: supplier 2 at 0.0000.
-- FOOD-001: supplier 1 at 0.0400.
-- SHAM-001: suppliers 2 and 3, both at 0.0800.
-- Items with no suppliers or only unknown quotes are omitted.
SELECT B.item_code, B.item_name, B.unit, B.current_balance, B.reorder_level,
       S.supplier_id, S.supplier_name, IT.supplier_item_code,
       IT.unit_price AS quoted_price_hkd_per_unit
FROM v_item_balance B
JOIN ItemSupplier IT ON IT.item_id = B.item_id
JOIN Supplier S ON S.supplier_id = IT.supplier_id
WHERE B.current_balance <= B.reorder_level
  AND IT.unit_price IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM ItemSupplier Cheaper
      WHERE Cheaper.item_id = IT.item_id
        AND Cheaper.unit_price < IT.unit_price
  )
ORDER BY B.item_code, S.supplier_id;
