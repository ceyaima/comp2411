-- tests/positive.sql
-- Successful insert/update/delete operations, labelled POS01, POS02, ...
-- Run with comp2411_g069 selected as the active database.

-- -------------------------------------------------------------
-- POS01: Insert a valid new stock item (Ear Cleaner)
-- -------------------------------------------------------------
INSERT INTO Item (item_code, item_name, unit, reorder_level)
VALUES ('MED-EAR-001', 'Soothing Pet Ear Cleaner', 'mL', 500);

-- Verify POS01 insertion
SELECT item_id, item_code, item_name, unit, reorder_level 
FROM Item 
WHERE item_code = 'MED-EAR-001';

-- -------------------------------------------------------------
-- POS02: Associate the new item with an existing approved supplier
-- -------------------------------------------------------------
INSERT INTO ItemSupplier (item_id, supplier_id, supplier_item_code, unit_price)
VALUES (
    (SELECT item_id FROM Item WHERE item_code = 'MED-EAR-001'),
    1, 
    'SUP-VET-EAR-99', 
    45.5000
);

-- Verify POS02 insertion
SELECT * FROM ItemSupplier 
WHERE item_id = (SELECT item_id FROM Item WHERE item_code = 'MED-EAR-001');

-- -------------------------------------------------------------
-- POS03: Record a valid Service Activity (Grooming)
-- -------------------------------------------------------------
INSERT INTO ServiceActivity (activity_ref, activity_type, service_date)
VALUES ('ACT-2026-TEST01', 'GROOMING', '2026-11-15');

-- Verify POS03 insertion
SELECT * FROM ServiceActivity WHERE activity_ref = 'ACT-2026-TEST01';

-- -------------------------------------------------------------
-- POS04: Update an item's reorder level based on new policy
-- -------------------------------------------------------------
UPDATE Item 
SET reorder_level = reorder_level + 100 
WHERE item_code = 'MED-EAR-001';

-- Verify POS04 update
SELECT item_code, reorder_level FROM Item WHERE item_code = 'MED-EAR-001';

-- -------------------------------------------------------------
-- POS05: Clean up test activity (Safe deletion)
-- -------------------------------------------------------------
DELETE FROM ServiceActivity WHERE activity_ref = 'ACT-2026-TEST01';

-- Verify POS05 deletion: expect zero rows.
SELECT *
FROM ServiceActivity
WHERE activity_ref = 'ACT-2026-TEST01';