-- sql/04_indexes.sql
-- Additional index(es) or comments justifying an existing index; cite the target query ID.
-- Run with comp2411_g069 selected as the active database.

-- Target query: Q02 (issued quantities for boarding vs grooming, 1-9 November 2026).
-- Supports Q02's WHERE condition on StockMovement:
-- movement_type = 'ISSUE' AND movement_datetime >= '2026-11-01' AND movement_datetime < '2026-11-10'
-- Existing indexes on StockMovement (PK movement_id; FK indexes on staff_id, supplier_id,
-- activity_id) do not cover either column, so without this index the filter scans every movement.
-- Column order: the equality column (movement_type) comes first, so all ISSUE entries are
-- stored together sorted by movement_datetime; the date range is then one contiguous scan.
-- movement_type alone has only two values and would not be selective; the date range is,
-- since a short period matches a small fraction of a growing movement history.
-- Trade-off: additional disk space and index maintenance on inserts, deletes and updates to indexed columns.
-- The append-only workflow normally avoids updates and deletes.
CREATE INDEX idx_stockmovement_type_datetime
    ON StockMovement (movement_type, movement_datetime);
