USE data_jobs;

--Average Salary per job title where the avg salary per job is greater than overall avg salary using CTE & sUBQUERY
WITH job_salary_avg AS
(SELECT
       job_title_short,
       CAST(Avg(salary_year_avg) AS INT) Avg_salary
FROM job_postings_fact
GROUP BY job_title_short)

SELECT * FROM job_salary_avg js
WHERE js.Avg_salary > (SELECT Avg(salary_year_avg) FROM job_postings_fact);

--Show all job postings where salary > avg salary for the specific job title using SUBQUERY & WINDOWS FUNC wrapped in cte

SELECT
       job_title_short,
       CAST(Avg(salary_year_avg) AS INT) Avg_salary
FROM job_postings_fact
GROUP BY job_title_short
HAVING Avg(salary_year_avg) > (SELECT Avg(salary_year_avg) FROM job_postings_fact)
ORDER BY Avg(salary_year_avg) DESC;

SELECT job_id, job_title_short, salary_year_avg
FROM job_postings_fact jpf
WHERE salary_year_avg > (
SELECT avg(salary_year_avg) Avg_salary
FROM job_postings_fact 
WHERE jpf.job_title_short = job_title_short);


--Using windows functions in CTE
WITH job_avg_salary AS(
SELECT job_id, job_title_short, salary_year_avg, 
       AVG(salary_year_avg) OVER (PARTITION BY job_title_short) as avg_salary_per_role
FROM job_postings_fact)
SELECT job_id, 
       job_title_short, 
       salary_year_avg
FROM job_avg_salary
WHERE salary_year_avg > avg_salary_per_role;

--3. Give me a list of all companies that have at least one job posting requiring Python.
SELECT DISTINCT company_id, name
FROM company_dim cd
WHERE EXISTS (Select 1
              from job_postings_fact jpf
              join skills_job_dim sjd on sjd.job_id = jpf.job_id
              join skills_dim sd on sjd.skill_id = sd.skill_id
              where sd.skills = 'python' AND jpf.company_id = cd.company_id);


select * from job_postings_fact limit 2;
select * from skills_dim limit 2;
select * from skills_job_dim limit 2;
select * from company_dim limit 2;

SELECT DISTINCT company_id, name
FROM company_dim cd
WHERE NOT EXISTS (Select 1
              from job_postings_fact jpf
              join skills_job_dim sjd on sjd.job_id = jpf.job_id
              join skills_dim sd on sjd.skill_id = sd.skill_id
              where sd.skills = 'python' AND jpf.company_id = cd.company_id);

