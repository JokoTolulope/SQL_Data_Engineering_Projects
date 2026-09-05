-- Top Paying Skill for Data Engineer job posting.
Select 
       sd.skills,
       Median(jpf.salary_year_avg) Median_salary,
       count(jpf.job_id) skill_count
from job_postings_fact as jpf
Join skills_job_dim as sjd on sjd.job_id = jpf.job_id
Join skills_dim as sd on sd.skill_id = sjd.skill_id 
where jpf.job_title_short ='Data Engineer' AND jpf.job_country = 'Nigeria'
Group By sd.skills
Order By Median_salary desc
Limit 20;

/*
Key Insights:
- The job postings for data engineering jobs in Nigeria seemed to be the same avg salary for all the skills.
- The average salary for DE jobs in Nigeria falls at 69300.
- With Python ranking as the most in-demand skill.
- Also shows some skills even have Nulls under the salary column.

Result:
┌────────────┬───────────────┬─────────────┐
│   skills   │ Median_salary │ skill_count │
│  varchar   │    double     │    int64    │
├────────────┼───────────────┼─────────────┤
│ azure      │       69300.0 │         194 │
│ golang     │       69300.0 │           9 │
│ redshift   │       69300.0 │          88 │
│ kubernetes │       69300.0 │          92 │
│ postgresql │       69300.0 │          65 │
│ airflow    │       69300.0 │         100 │
│ python     │       69300.0 │         364 │
│ scala      │       69300.0 │          74 │
│ java       │       69300.0 │          92 │
│ gcp        │       69300.0 │          81 │
│ mysql      │       69300.0 │          49 │
│ kafka      │       69300.0 │         104 │
│ mongodb    │       69300.0 │          94 │
│ aws        │       69300.0 │         266 │
│ shell      │          NULL │           3 │
│ firebase   │          NULL │           4 │
│ npm        │          NULL │           2 │
│ jenkins    │          NULL │          14 │
│ oracle     │          NULL │          20 │
│ jupyter    │          NULL │           9 │
└────────────┴───────────────┴─────────────┘

* If i comment out the country filter from the query, just to capture the top salary for data engineering skills regardless of the country
Select 
       sd.skills,
       Median(jpf.salary_year_avg) Median_salary,
       count(jpf.job_id) skill_count
from job_postings_fact as jpf
Join skills_job_dim as sjd on sjd.job_id = jpf.job_id
Join skills_dim as sd on sd.skill_id = sjd.skill_id 
where jpf.job_title_short ='Data Engineer' --AND jpf.job_country = 'Nigeria'
Group By sd.skills
Order By Median_salary desc
Limit 20;

- This shows Mongo as the highest paid skill for data engineering job postings across all countries in the dataset.
Result:
───────────────┬───────────────┬─────────────┐
│    skills     │ Median_salary │ skill_count │
│    varchar    │    double     │    int64    │
├───────────────┼───────────────┼─────────────┤
│ mongo         │      201000.0 │        3795 │
│ solidity      │      192500.0 │         174 │
│ next.js       │      190000.0 │          80 │
│ ocaml         │      172500.0 │           9 │
│ erlang        │      172500.0 │          50 │
│ rust          │      169687.5 │        1317 │
│ ggplot2       │      162500.0 │          98 │
│ arch          │      157641.5 │         151 │
│ groovy        │      157500.0 │         813 │
│ puppet        │      157500.0 │        1066 │
│ vue           │      156500.0 │        1107 │
│ drupal        │      156000.0 │          61 │
│ codecommit    │      155000.0 │         292 │
│ zoom          │      155000.0 │         669 │
│ golang        │      155000.0 │        2805 │
│ typescript    │      150000.0 │        2616 │
│ node          │      150000.0 │        1084 │
│ ruby on rails │      150000.0 │         319 │
│ ansible       │      150000.0 │        6122 │
│ cassandra     │      147500.0 │       12206 │
└───────────────┴───────────────┴─────────────┘
*/
