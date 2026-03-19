-- 02_validate_productivity.sql

-- row counts
SELECT 'raw_row_count' AS check_name, COUNT() AS value
FROM raw_department_productivity
UNION ALL
SELECT 'staged_row_count', COUNT()
FROM stg_department_productivity;

-- bad / missing hours
SELECT *
FROM stg_department_productivity
WHERE productive_hours IS NULL
OR productive_hours <= 0;

-- overtime / agency usage
SELECT
month,
hospital,
department,
SUM(overtime_hours) AS overtime_hours,
SUM(agency_hours) AS agency_hours,
SUM(encounters) AS encounters
FROM stg_department_productivity
GROUP BY month, hospital, department
ORDER BY overtime_hours DESC;

-- high variance
SELECT
month,
hospital,
department,
role_group,
actual_productivity,
productivity_target,
variance_pct
FROM stg_department_productivity
WHERE variance_pct IS NOT NULL
AND ABS(variance_pct) >= 0.10
ORDER BY ABS(variance_pct) DESC;