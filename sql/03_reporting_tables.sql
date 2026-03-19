-- 03_reporting_tables.sql

-- monthly rollup
CREATE OR REPLACE TEMP VIEW rpt_department_monthly_summary AS
SELECT
month,
hospital,
department,
SUM(encounters) AS encounters,
SUM(productive_hours) AS productive_hours,
SUM(nonproductive_hours) AS nonproductive_hours,
SUM(overtime_hours) AS overtime_hours,
SUM(agency_hours) AS agency_hours,
AVG(productivity_target) AS productivity_target,

-- productivity
ROUND(SUM(encounters) / NULLIF(SUM(productive_hours), 0), 2) AS actual_productivity,

-- variance
ROUND(
((SUM(encounters) / NULLIF(SUM(productive_hours), 0)) - AVG(productivity_target))
/ NULLIF(AVG(productivity_target), 0), 4
) AS variance_pct,

-- staffing
AVG(budgeted_fte) AS budgeted_fte,
AVG(worked_fte) AS worked_fte

FROM stg_department_productivity
WHERE productive_hours > 0
GROUP BY month, hospital, department;

-- priority list
CREATE OR REPLACE TEMP VIEW rpt_priority_review AS
SELECT
month,
hospital,
department,
encounters,
productive_hours,
overtime_hours,
agency_hours,
productivity_target,
actual_productivity,
variance_pct,
budgeted_fte,
worked_fte,

-- flags
CASE
WHEN variance_pct <= -0.10 AND overtime_hours > 100
THEN 'Low productivity + overtime pressure'
WHEN variance_pct <= -0.10
THEN 'Productivity below target'
WHEN agency_hours > 75
THEN 'High premium labor'
ELSE 'Monitor'
END AS review_flag

FROM rpt_department_monthly_summary;

-- output
SELECT *
FROM rpt_priority_review
ORDER BY ABS(variance_pct) DESC, overtime_hours DESC;