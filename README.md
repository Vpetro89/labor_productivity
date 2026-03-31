## Labor Productivity Workflow

### Description
This project focuses on department-level labor productivity reporting using workload and staffing hours. It is built to show whether staffing levels match actual volume and to help explain when overtime or agency labor is being used to cover gaps.

### Data
- Encounters
- Productive hours
- Overtime
- Agency labor

### Calculations
- `productivity = workload / productive hours`
- Target versus actual productivity
- Productivity variance

### Run Order
- `01_stage_productivity.sql`
- `02_validate_productivity.sql`
- `03_reporting_tables.sql`

### Use
- Identify where staffing does not match volume
- Check whether overtime or agency labor is covering gaps
- Determine whether the issue is volume, staffing, or labor mix
