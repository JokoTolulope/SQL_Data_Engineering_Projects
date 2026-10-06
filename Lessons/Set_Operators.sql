--Create Temp table with data from job_postings dataset for 2023 and 2024 separately.
--UNION/UNION ALL
--INTERSECT/INTERSECT ALL
--EXCEPT/EXCEPT ALL

USE data_jobs;

CREATE TEMP TABLE jobs_2023 AS
SELECT * EXCLUDE (job_id, job_posted_date)
FROM job_postings_fact
WHERE EXTRACT(YEAR FROM job_posted_date) = 2023;

CREATE TEMP TABLE jobs_2024 AS
SELECT * EXCLUDE (job_id, job_posted_date)
FROM job_postings_fact
WHERE EXTRACT(YEAR FROM job_posted_date) = 2024;

SELECT * from jobs_2023;
SELECT *  from jobs_2024;

--which unique job postings appeared in either 2023 or 2024?
SELECT * FROM jobs_2023
UNION 
SELECT * FROM jobs_2024;

--which job postings from 2023 remain after subtracting matching 2024 postings, one-for-one?

SELECT * FROM jobs_2023
EXCEPT ALL
SELECT * FROM jobs_2024;

--which job posting appeared in 2023 & 2024
SELECT * FROM jobs_2023
INTERSECT
SELECT * FROM jobs_2024;