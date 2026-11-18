-- Q06: Which service activities used more distinct items than the average among activities with recorded issues?
-- Techniques: join;join3plus;group_by;having;subquery
-- Expected result:
-- Activities with issues use 3, 4 and 1 distinct items.
-- Their average is 8 / 3; activities 1 and 2 exceed it.
-- Activity 4 has no issues and is excluded by the current query.
-- Activity 3's two issues of gloves still count as one distinct item.

SELECT SA.activity_ref, COUNT(DISTINCT SML.item_id) AS distinct_items
FROM ServiceActivity SA
JOIN StockMovement SM      ON SA.activity_id = SM.activity_id
JOIN StockMovementLine SML ON SM.movement_id = SML.movement_id
WHERE SM.movement_type = 'ISSUE'
GROUP BY SA.activity_ref
HAVING COUNT(DISTINCT SML.item_id) > (
    SELECT AVG(distinct_items)
    FROM (
        SELECT COUNT(DISTINCT SML2.item_id) AS distinct_items
        FROM ServiceActivity SA2
        JOIN StockMovement SM2      ON SA2.activity_id = SM2.activity_id
        JOIN StockMovementLine SML2 ON SM2.movement_id = SML2.movement_id
        WHERE SM2.movement_type = 'ISSUE'
        GROUP BY SA2.activity_ref
    ) AS per_activity
);