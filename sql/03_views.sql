-- Current balances (BR08): receipts minus issues, in each item's base unit.
-- Run once after 01_schema.sql with comp2411_g069 selected.
-- LEFT JOIN preserves items with no movements; COALESCE gives them zero stock.
-- Aggregate before joining supplier options to avoid multiplying quantities.
CREATE OR REPLACE VIEW v_item_balance AS
SELECT I.item_id, I.item_code, I.item_name, I.unit, I.reorder_level,
       COALESCE(SUM(CASE
           WHEN SM.movement_type = 'RECEIPT' THEN SML.quantity
           WHEN SM.movement_type = 'ISSUE' THEN -SML.quantity
           ELSE 0
       END), 0) AS current_balance
FROM Item I
LEFT JOIN StockMovementLine SML ON SML.item_id = I.item_id
LEFT JOIN StockMovement SM ON SM.movement_id = SML.movement_id
GROUP BY I.item_id, I.item_code, I.item_name, I.unit, I.reorder_level;
