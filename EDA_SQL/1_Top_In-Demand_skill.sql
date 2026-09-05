--SQL EDA PROJECT
Select * from job_postings_fact limit 10;
select * from skills_job_dim;
select * from skills_dim;

Select jpf.job_id,
       jpf.job_title,
       sjd.skill_id,
       sd.skills,
       sd.type
from job_postings_fact as jpf
Join skills_job_dim as sjd on sjd.job_id = jpf.job_id
left join skills_dim as sd on sd.skill_id = sjd.skill_id;

--FIND THE MOST IN-DEMAND SKILLS FOR DATA ENGINEERS IN NIGERIA
Select 
       sd.skills,
       count(jpf.job_id) as skill_count
from job_postings_fact as jpf
Join skills_job_dim as sjd on sjd.job_id = jpf.job_id
Left Join skills_dim as sd on sd.skill_id = sjd.skill_id
where jpf.job_title_short ='Data Engineer' AND jpf.job_country = 'Nigeria'
Group by sd.skills
Order by skill_count desc
LIMIT 10;

/*
Key Insights:
- Queried the job_postings_fact, skills_job_dim, skills_dim tables to get the most in-demand skills for data engineers in Nigeria.
- From the result, it shows SQL & Python being the top skill for data engineers.
- AWS top cloud platform.
- Spark and Kafka as big data and stream processing platform.
- Airflow as the top orchestration tool.
- I noticed there are no data warehouse platform in the top 10 result for job postings for data engineers in Nigeria.
┌────────────┬─────────────┐
│   skills   │ skill_count │
│  varchar   │    int64    │
├────────────┼─────────────┤
│ sql        │         368 │
│ python     │         364 │
│ aws        │         266 │
│ azure      │         194 │
│ spark      │         126 │
│ kafka      │         104 │
│ airflow    │         100 │
│ flow       │          94 │
│ mongodb    │          94 │
│ kubernetes │          92 │
└────────────┴─────────────┘
*/


