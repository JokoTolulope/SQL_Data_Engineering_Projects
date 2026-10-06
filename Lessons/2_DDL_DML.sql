-- .read Lessons/2_DDL_DML.sql
USE job_mart;
--Create CTAS(Create Table AS Select) under staging schema. Using company_dim & job_postings_fact tables from data_jobs db.
CREATE OR REPLACE TABLE staging.job_postings_flat AS
SELECT jpf.job_id,
       jpf.job_title_short,
       jpf.job_title,
       jpf.job_location,
       jpf.job_via,
       jpf.job_schedule_type,
       jpf.job_work_from_home,
       jpf.search_location,
       jpf.job_posted_date,
       jpf.job_no_degree_mention,
       jpf.job_health_insurance,
       jpf.job_country,
       jpf.salary_rate,
       jpf.salary_year_avg,
       jpf.salary_hour_avg,
       cd.name AS company_name
FROM data_jobs.job_postings_fact jpf
LEFT JOIN data_jobs.company_dim cd ON cd.company_id = jpf.company_id;

Select * from staging.job_postings_flat LIMIT 5;

--Creating View under the main schema
CREATE OR REPLACE VIEW priority_jobs_flat_view AS
Select jpf.*
FROM staging.job_postings_flat jpf
JOIN staging.priority_roles pr ON pr.role_name = jpf.job_title_short
WHERE pr.priority = 1;

Select * from priority_jobs_flat_view;

--Select * from information_schema.tables;

Select job_title_short, count(*)
From priority_jobs_flat_view
Group By job_title_short
Order By Count(*) DESC;

--Create Temp table

CREATE TEMPORARY TABLE IF NOT EXISTS senior_jobs_flat_temp AS
Select * 
From priority_jobs_flat_view
Where job_title_short = 'Senior Data Engineer'; 

Select job_title_short, count(*)
From senior_jobs_flat_temp
Group By job_title_short
Order By Count(*) DESC;

TRUNCATE TABLE staging.job_postings_flat;

INSERT INTO staging.job_postings_flat
SELECT jpf.job_id,
       jpf.job_title_short,
       jpf.job_title,
       jpf.job_location,
       jpf.job_via,
       jpf.job_schedule_type,
       jpf.job_work_from_home,
       jpf.search_location,
       jpf.job_posted_date,
       jpf.job_no_degree_mention,
       jpf.job_health_insurance,
       jpf.job_country,
       jpf.salary_rate,
       jpf.salary_year_avg,
       jpf.salary_hour_avg,
       cd.name AS company_name
FROM data_jobs.job_postings_fact jpf
LEFT JOIN data_jobs.company_dim cd ON cd.company_id = jpf.company_id
WHERE job_posted_date >= '2024-01-01';

select count(*)
from staging.job_postings_flat;

