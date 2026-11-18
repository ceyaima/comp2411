-- sql/02_data.sql
-- Synthetic seed data in a valid insertion order (parents before children).
-- Run with comp2411_g069 selected as the active database.

START TRANSACTION;

-- 1. Items
INSERT INTO Item
    (item_id, item_code, item_name, unit, reorder_level)
VALUES
    (1, 'FOOD-001', 'Dry dog food', 'g', 2000),
    (2, 'SHAM-001', 'Gentle pet shampoo', 'mL', 500),
    (3, 'GLOVE-001', 'Disposable gloves', 'pair', 50),
    (4, 'PAD-001', 'Absorbent kennel pads', 'pcs', 30),
    (5, 'WIPE-001', 'Pet cleaning wipes', 'pcs', 40),
    (6, 'BAG-001', 'Pet waste bags', 'pcs', 20),
    (7, 'TREAT-001', 'Training treats', 'g', 300),
    (8, 'COMB-001', 'Disposable grooming combs', 'pcs', 0);

-- 2. Suppliers
-- Suppliers 1-3 have receipt history.
-- Supplier 4 has catalog links but no receipts.
-- Supplier 5 has neither catalog links nor receipts.
INSERT INTO Supplier
    (supplier_id, supplier_name, phone, email)
VALUES
    (1, 'Harbour Pet Supplies', NULL, 'sales@harbourpet.example'),
    (2, 'Gentle Grooming Supplies', NULL, 'sales@gentlegroom.example'),
    (3, 'Kennel Essentials', NULL, 'sales@kennelessentials.example'),
    (4, 'Reserve Pet Wholesale', NULL, 'sales@reservepet.example'),
    (5, 'New Supplier Prospect', NULL, NULL);

-- 3. Staff
INSERT INTO Staff
    (staff_id, staff_name, role)
VALUES
    (1, 'John Lee', 'STOCK_KEEPER'),
    (2, 'Eaedeepea Forforfhive', 'GROOMER'),
    (3, 'Nicole Reeyn', 'KENNEL_STAFF'),
    (4, 'Tuh Junyin', 'MANAGER');

-- 4. Service activities
-- Activity 4 has no recorded issues.
INSERT INTO ServiceActivity
    (activity_id, activity_ref, activity_type, service_date)
VALUES
    (1, 'ACT-2026-001', 'BOARDING', '2026-11-03'),
    (2, 'ACT-2026-002', 'GROOMING', '2026-11-05'),
    (3, 'ACT-2026-003', 'BOARDING', '2026-11-09'),
    (4, 'ACT-2026-004', 'GROOMING', '2026-11-12');

-- 5. Supplier catalogs and current quotes
-- Item 4 has no suppliers.
-- Items 5 and 8 have only unknown quotes.
-- Item 2 has two equally cheap quotes.
-- Item 6 has a valid zero-price quote.
-- Supplier 1 does NOT supply item 2
INSERT INTO ItemSupplier
    (item_id, supplier_id, supplier_item_code, unit_price)
VALUES
    (1, 1, 'HP-FOOD-01', 0.0400),
    (1, 2, 'GG-FOOD-01', 0.0450),
    (1, 4, 'RP-FOOD-01', 0.0500),
    (2, 2, 'GG-SHAM-01', 0.0800),
    (2, 3, 'KE-SHAM-01', 0.0800),
    (3, 1, 'HP-GLOVE-01', 1.2000),
    (5, 3, 'KE-WIPE-01', NULL),
    (6, 2, 'GG-BAG-01', 0.0000),
    (6, 3, 'KE-BAG-01', 0.5000),
    (7, 1, 'HP-TREAT-01', 0.0600),
    (8, 4, 'RP-COMB-01', NULL);

-- 6. Stock movement headers
-- Receipts precede issues in the recorded history.
-- Receipts 2 and 3 deliberately share a timestamp, allowing Q05
-- to return both latest receipts for item 2.
-- Q02 includes 1-9 November 2026:
-- movement 6 is included; movement 7 on 10 November is excluded.
INSERT INTO StockMovement
    (movement_id, movement_type, movement_datetime,
     staff_id, supplier_id, activity_id)
VALUES
    (1, 'RECEIPT', '2026-10-31 09:00:00', 1, 1, NULL),
    (2, 'RECEIPT', '2026-11-01 10:00:00', 1, 2, NULL),
    (3, 'RECEIPT', '2026-11-01 10:00:00', 4, 3, NULL),
    (4, 'ISSUE', '2026-11-03 09:00:00', 3, NULL, 1),
    (5, 'ISSUE', '2026-11-05 14:00:00', 2, NULL, 2),
    (6, 'ISSUE', '2026-11-09 23:59:59', 3, NULL, 3),
    (7, 'ISSUE', '2026-11-10 00:00:00', 3, NULL, 3);

-- 7. Stock movement lines
-- Every header has at least one line before COMMIT.
-- Every receipt item is linked to its supplier in ItemSupplier.
-- No issue causes a negative running stock balance.
-- Each item occurs at most once within a movement.
INSERT INTO StockMovementLine
    (movement_id, item_id, quantity)
VALUES
    -- Receipt 1: Harbour Pet Supplies
    (1, 1, 2000),
    (1, 3, 100),
    (1, 7, 500),
    -- Receipt 2: Gentle Grooming Supplies
    (2, 1, 500),
    (2, 2, 800),
    (2, 6, 40),
    -- Receipt 3: Kennel Essentials
    (3, 2, 200),
    (3, 5, 50),
    (3, 6, 20),
    -- Issue 4: Boarding activity 1
    (4, 1, 700),
    (4, 2, 300),
    (4, 5, 30),
    -- Issue 5: Grooming activity 2
    (5, 1, 300),
    (5, 2, 200),
    (5, 6, 40),
    (5, 7, 100),
    -- Issue 6: Boarding activity 3, inside Q02's date range
    (6, 3, 10),
    -- Issue 7: Boarding activity 3, outside Q02's date range
    (7, 3, 5);

COMMIT;

-- -------------------------------------------------------------
-- Baseline checks
-- -------------------------------------------------------------

-- Table counts:
-- Item: 8
-- Supplier: 5
-- Staff: 4
-- ServiceActivity: 4
-- ItemSupplier: 11
-- StockMovement: 7
-- StockMovementLine: 18

-- Current balances:
-- FOOD-001:  2000 + 500 - 700 - 300 = 1500 g
-- SHAM-001:  800 + 200 - 300 - 200  = 500 mL
-- GLOVE-001: 100 - 10 - 5           = 85 pairs
-- PAD-001:   no movements           = 0 pcs
-- WIPE-001:  50 - 30                = 20 pcs
-- BAG-001:   40 + 20 - 40           = 20 pcs
-- TREAT-001: 500 - 100              = 400 g
-- COMB-001:  no movements           = 0 pcs