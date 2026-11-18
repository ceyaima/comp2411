-- Q05: What is the latest receipt datetime and supplier for each item?
-- Techniques: join;join3plus;subquery;correlated;exists;null_handling
-- Prerequisite: sql/01_schema.sql; comp2411_g069 selected.
-- Latest means greatest recorded movement_datetime, not insertion order.
-- Expected result:
-- Ten rows across eight items.
-- SHAM-001 has two latest receipts: movements 2 and 3.
-- PAD-001 and COMB-001 have NULL receipt and supplier details.
-- FOOD-001's latest receipt is movement 2.
-- GLOVE-001 and TREAT-001 have latest receipt movement 1.
-- WIPE-001 has latest receipt movement 3.
-- BAG-001 has two latest receipts: movements 2 and 3.
SELECT I.item_code, I.item_name, I.unit,
       R.movement_id, R.movement_datetime AS latest_receipt_datetime,
       S.supplier_id, S.supplier_name, R.quantity AS received_quantity
FROM Item I
LEFT JOIN (
    SELECT SML.item_id, SM.movement_id, SM.movement_datetime,
           SM.supplier_id, SML.quantity
    FROM StockMovement SM
    JOIN StockMovementLine SML ON SML.movement_id = SM.movement_id
    WHERE SM.movement_type = 'RECEIPT'
) R ON R.item_id = I.item_id
LEFT JOIN Supplier S ON S.supplier_id = R.supplier_id
WHERE NOT EXISTS (
    SELECT 1
    FROM StockMovement SM2
    JOIN StockMovementLine SML2 ON SML2.movement_id = SM2.movement_id
    WHERE SML2.item_id = I.item_id
      AND SM2.movement_type = 'RECEIPT'
      AND SM2.movement_datetime > R.movement_datetime
)
ORDER BY I.item_code, R.movement_id;
