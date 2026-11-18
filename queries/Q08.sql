-- Q08: Which suppliers are recorded as supplying at least one item but have never delivered a receipt?
-- Techniques: subquery;correlated;exists
-- Expected result: Supplier 4 only
-- Supplier 5 has no catalog links, so it is excluded

SELECT S.supplier_id, S.supplier_name
FROM Supplier S
WHERE EXISTS (
        SELECT 1
        FROM ItemSupplier IT
        WHERE IT.supplier_id = S.supplier_id
      )
  AND NOT EXISTS (
        SELECT 1
        FROM StockMovement SM
        WHERE SM.supplier_id = S.supplier_id
          AND SM.movement_type = 'RECEIPT'
      )
ORDER BY S.supplier_id;
