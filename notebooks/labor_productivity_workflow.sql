-- Databricks notebook source

-- load
CREATE OR REPLACE TEMP VIEW raw_department_productivity AS
SELECT * FROM csv.`data/raw/raw_department_productivity.csv`;

-- COMMAND ----------

-- clean + calc
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

    CASE
        WHEN CAST(productive_hours AS DOUBLE) > 0
            THEN ROUND(CAST(encounters AS DOUBLE) / CAST(productive_hours AS DOUBLE), 2)
        ELSE NULL
    END AS actual_productivity

FROM raw_department_productivity;

-- COMMAND ----------

-- rollup
SELECT
    month,
    hospital,
    department,
    SUM(encounters) AS encounters,
    SUM(productive_hours) AS productive_hours,
    SUM(overtime_hours) AS overtime_hours,
    SUM(agency_hours) AS agency_hours,
    AVG(productivity_target) AS productivity_target,
    ROUND(SUM(encounters) / NULLIF(SUM(productive_hours), 0), 2) AS actual_productivity

FROM stg_department_productivity
WHERE productive_hours > 0
GROUP BY month, hospital, department
ORDER BY month, hospital, department;

-- COMMAND ----------

-- bad rows
SELECT *
FROM stg_department_productivity
WHERE productive_hours <= 0;