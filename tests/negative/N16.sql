-- N16: Reject a missing service date (BR10).
-- Prerequisite: activity 1 has service_date 2026-11-03
-- Expected error: 1048 (SQLSTATE 23000)
-- Expected outcome: service_date remains 2026-11-03

UPDATE ServiceActivity
SET service_date = NULL
WHERE activity_id = 1;