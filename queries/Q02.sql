-- Q02: How much of each item was issued for boarding compared with grooming?
-- Techniques: join;join3plus;group_by
-- Expected Result on baseline seed data:
-- Issued boarding/grooming quantities within 1-9 November:
-- BAG-001:     0 / 40
-- FOOD-001:  700 / 300
-- GLOVE-001:  10 / 0
-- SHAM-001:  300 / 200
-- TREAT-001:   0 / 100
-- WIPE-001:   30 / 0
-- The additional 5 glove pairs issued on 10 November are excluded.

SELECT I.item_code,
       I.item_name,
       SUM(CASE WHEN SA.activity_type = 'BOARDING' THEN SML.quantity ELSE 0 END) AS boarding_issued,
       SUM(CASE WHEN SA.activity_type = 'GROOMING' THEN SML.quantity ELSE 0 END) AS grooming_issued
FROM ServiceActivity SA
JOIN StockMovement SM ON SA.activity_id = SM.activity_id
JOIN StockMovementLine SML ON SM.movement_id = SML.movement_id
JOIN Item I ON SML.item_id = I.item_id
WHERE SM.movement_datetime >= '2026-11-01' AND SM.movement_datetime < '2026-11-10'
  AND SM.movement_type = 'ISSUE'
GROUP BY I.item_id, I.item_code, I.item_name
ORDER BY I.item_code;