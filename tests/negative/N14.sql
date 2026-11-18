-- N14: Reject a duplicate activity reference (BR10).
-- Prerequisite: activity 1 uses ACT-2026-001 and activity 2 uses ACT-2026-002
-- Expected error: 1062 (SQLSTATE 23000), unique_activity_ref
-- Expected outcome: activity 2 retains ACT-2026-002

UPDATE ServiceActivity
SET activity_ref = 'ACT-2026-001'
WHERE activity_id = 2;