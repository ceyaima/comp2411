-- N11: Reject a duplicate item within a movement (BR04).
-- Prerequisite: movement 1 already contains item 1, quantity 2000
-- Expected error: 1062 (SQLSTATE 23000), PRIMARY
-- Expected outcome: existing quantity remains 2000; no new line

INSERT INTO StockMovementLine (movement_id, item_id, quantity)
VALUES (1, 1, 10);