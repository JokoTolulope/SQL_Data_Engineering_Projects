-- .read Lessons/priority_jobs_snapshot.sql
CREATE OR REPLACE TEMP TABLE src_priority_jobs AS 
SELECT jpf.job_id,
       jpf.job_title_short,
       cd.name AS company_name,
       jpf.job_posted_date,
       jpf.salary_year_avg,
       r.priority,
       CURRENT_TIMESTAMP AS updated_at
FROM data_jobs.job_postings_fact AS jpf
LEFT JOIN data_jobs.company_dim AS cd ON cd.company_id = jpf.company_id
INNER JOIN staging.priority_roles AS r ON r.role_name = jpf.job_title_short;

-- ---------------------------------------------------
-- UPDATE main.priority_jobs_snapshot AS tgt
-- SET priority = src.priority,
--     updated_at = src.updated_at
-- FROM src_priority_jobs AS src
-- WHERE tgt.job_id = src.job_id
--       AND tgt.priority IS DISTINCT FROM src.priority;

-- --------------------------------------------------
-- INSERT INTO main.priority_jobs_snapshot(
--     job_id,
--     job_title_short,
--     company_name,
--     job_posted_date,
--     salary_year_avg,
--     priority,
--     updated_at
-- )
-- SELECT 
--       src.job_id,
--       src.job_title_short,
--       src.company_name,
--       src.job_posted_date,
--       src.salary_year_avg,
--       src.priority,
--       src.updated_at
-- FROM src_priority_jobs AS src
-- WHERE NOT EXISTS(SELECT 1
--                     FROM main.priority_jobs_snapshot AS tgt
--                     WHERE tgt.job_id = src.job_id);

-- ---------------------------------------------------------
-- DELETE FROM main.priority_jobs_snapshot AS tgt
-- WHERE NOT EXISTS(SELECT 1
--                 FROM src_priority_jobs AS src
--                 WHERE src.job_id = tgt.job_id);

-----------------------------------
--MERGE INTO
MERGE INTO main.priority_jobs_snapshot AS tgt
USING src_priority_jobs AS src
ON tgt.job_id = src.job_id

WHEN MATCHED AND tgt.priority IS DISTINCT FROM src.priority THEN
UPDATE SET priority = src.priority,
           updated_at = src.updated_at

WHEN NOT MATCHED THEN
INSERT (job_id,
    job_title_short,
    company_name,
    job_posted_date,
    salary_year_avg,
    priority,
    updated_at
)
VALUES (src.job_id,
      src.job_title_short,
      src.company_name,
      src.job_posted_date,
      src.salary_year_avg,
      src.priority,
      src.updated_at)

WHEN NOT MATCHED BY SOURCE THEN DELETE;
    






SELECT 
     job_title_short,
     COUNT(*) AS job_count,
     MIN(priority) AS priority,
     MIN(updated_at) AS updated_at
FROM priority_jobs_snapshot
GROUP BY job_title_short
ORDER BY job_count   DESC;