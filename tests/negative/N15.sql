-- N15: Reject an unsupported activity type (BR10).
-- Prerequisite: activity 1 has type BOARDING
-- Expected error: 3819 (SQLSTATE HY000), check_activity_type
-- Expected outcome: activity 1 retains type BOARDING

UPDATE ServiceActivity
SET activity_type = 'GENERAL'
WHERE activity_id = 1;