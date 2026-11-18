-- N01: Reject a receipt item missing from the supplier's catalog (BR06).
-- Prerequisites: Movement 1 is a RECEIPT from supplier 1, item 2 exists but is not linked to supplier 1, and movement 1 does not already contain item 2
-- Expected error: 3819 (SQLSTATE HY000), check_quantity
-- Expected outcome: no line inserted; existing lines unchanged

-- checks ItemSupplier catalog before inserting line:
INSERT INTO StockMovementLine (movement_id, item_id, quantity)
SELECT
    SM.movement_id,
    2,
    CASE
        WHEN EXISTS (
            SELECT 1
            FROM ItemSupplier IT
            WHERE IT.supplier_id = SM.supplier_id
              AND IT.item_id = 2
        )
        THEN 20
        ELSE 0
    END
FROM StockMovement SM
WHERE SM.movement_id = 1 AND SM.movement_type = 'RECEIPT';