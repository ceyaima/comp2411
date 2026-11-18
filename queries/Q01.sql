-- Q01: Which items need replenishment, and what are their balances and reorder levels?
-- Techniques: view
-- Prerequisite: sql/03_views.sql; comp2411_g069 selected.
-- Expected result on the baseline seed data:
-- Six items need replenishment: BAG-001, COMB-001, FOOD-001, PAD-001, SHAM-001, WIPE-001.
-- Includes balances below and exactly equal to their reorder levels.
-- GLOVE-001 and TREAT-001 are above their reorder levels.
SELECT item_code, item_name, unit, current_balance, reorder_level
FROM v_item_balance
WHERE current_balance <= reorder_level
ORDER BY item_code;
