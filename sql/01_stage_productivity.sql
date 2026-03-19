-- 01_stage_productivity.sql

-- load raw file
CREATE OR REPLACE TEMP VIEW raw_department_productivity AS
SELECT * FROM csv.data/raw/raw_department_productivity.csv;

-- clean + cast
CREATE OR REPLACE TEMP VIEW stg_department_productivity AS
SELECT
TRIM(month) AS month,
TRIM(hospital) AS hospital,
TRIM(department) AS department,
TRIM(role_group) AS role_group,
CAST(encounters AS DOUBLE) AS encounters,
CAST(productive_hours AS DOUBLE) AS productive_hours,
CAST(nonproductive_hours AS DOUBLE) AS nonproductive_hours,
CAST(overtime_hours AS DOUBLE) AS overtime_hours,
CAST(agency_hours AS DOUBLE) AS agency_hours,
CAST(budgeted_fte AS DOUBLE) AS budgeted_fte,
CAST(worked_fte AS DOUBLE) AS worked_fte,
CAST(productivity_target AS DOUBLE) AS productivity_target,

-- productivity
CASE
WHEN CAST(productive_hours AS DOUBLE) > 0
THEN ROUND(CAST(encounters AS DOUBLE) / CAST(productive_hours AS DOUBLE), 2)
ELSE NULL
END AS actual_productivity,

-- variance vs target
CASE
WHEN CAST(productive_hours AS DOUBLE) > 0
AND CAST(productivity_target AS DOUBLE) > 0
THEN ROUND(
((CAST(encounters AS DOUBLE) / CAST(productive_hours AS DOUBLE))
- CAST(productivity_target AS DOUBLE))
/ CAST(productivity_target AS DOUBLE), 4
)
ELSE NULL
END AS variance_pct

FROM raw_department_productivity;