-- Q03: Which suppliers can provide items needing replenishment, and at what quoted prices?
-- Techniques: view;join;join3plus;null_handling
-- Prerequisite: sql/03_views.sql; comp2411_g069 selected.
-- Expected result from baseline seed data:
-- Ten rows of replenishment supplier options.
-- PAD-001 remains as one row with NULL supplier details.
-- COMB-001 and WIPE-001 retain their suppliers with NULL quotes.
-- Multiple suppliers do not multiply the stock balances.
SELECT B.item_code, B.item_name, B.unit, B.current_balance, B.reorder_level,
       S.supplier_id, S.supplier_name, IT.supplier_item_code,
       IT.unit_price AS quoted_price_hkd_per_unit
FROM v_item_balance B
LEFT JOIN ItemSupplier IT ON IT.item_id = B.item_id
LEFT JOIN Supplier S ON S.supplier_id = IT.supplier_id
WHERE B.current_balance <= B.reorder_level
ORDER BY B.item_code, S.supplier_id;
