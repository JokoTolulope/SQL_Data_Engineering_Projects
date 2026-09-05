# Exploratory Data Analysis with SQL: Data Engineering Job Market Analysis

A SQL-based analysis of over 1.6 million job postings, exploring the most in-demand skills, highest paying skills, and optimal skills for data engineering roles. Built using DuckDB and MotherDuck, this project demonstrates my ability to **write production-quality analytical SQL queries against large-scale datasets to extract actionable career insights**.

## Executive Summary
**Project Scope:** Analysed job postings data, 
spanning multiple countries with a focused lens on the Nigerian market where 
relevant. Queries were written across three joined tables; job_postings_fact, 
skills_job_dim, and skills_dim, reflecting a real star schema data model.

**Data Modeling:** The dataset follows a star schema structure with job_postings_fact as the 
central fact table, joined to dimension tables for skills and companies. 
All analysis was performed directly against this model using multi-table 
joins and aggregations.

**Analytics:** 3 analytical questions were investigated:
- **Demand**: Which skills appear most frequently in Data Engineer job postings in Nigeria?
- **Salary**: Which skills command the highest median salaries globally?
- **Optimal**: Which skills offer the best balance of demand and pay using a logarithmic scoring model?

**Outcomes:** - SQL and Python confirmed as the non-negotiable foundation for data engineering roles
- Terraform identified as the highest paying skill globally despite moderate demand
- No data warehouse platforms appeared in Nigeria's top 10, a notable gap in the local market
- A clear skill priority roadmap emerged: Python and SQL first, then AWS, 
  Spark and Airflow, with Terraform and Kafka as later specialisations.

Check out the queries for each of the analysis:

1. [`Top Demanded skills Query`](1_Top_In-Demand_skill.sql) - Demand analysis with multi-table joins

2. [`Top Paying skills Query`](./2_Top_Paying_Skill.sql) - Salary analysis with aggregations

3. [`Optimal skills Query`](./3_Optimal_skill.sql) - Combined demand/salary optimization query

## Problem & Context



Breaking into data engineering means deciding which skills to prioritise 
across a crowded ecosystem. This project uses real job postings data to 
answer that question with SQL.

### The Questions
1. **What are the most in-demand skills for Data Engineers in Nigeria?**
2. **Which skills command the highest salaries globally?**
3. **What is the optimal skill - balancing both demand and pay?**

## Tech Stack


- **Query Engine:** DuckDB for fast OLAP-style analytical queries
- **Language:** SQL (ANSI-style with analytical functions)
- **Data Model:** Star schema with fact + dimension + bridge tables
- **Cloud Database:** MotherDuck for hosting and sharing the job postings dataset
- **Development:** VS Code for SQL editing + Terminal for DuckDB CLI
- **Version Control:** Git/GitHub for versioned SQL scripts

## Analysis Overview


### 1. Most In-Demand Skills - Nigeria Focus
Queried across three joined tables to identify the top 10 skills appearing 
most frequently in Nigerian Data Engineer job postings.

```sql
Select sd.skills, count(jpf.job_id) as skill_count
from job_postings_fact as jpf
Join skills_job_dim as sjd on sjd.job_id = jpf.job_id
Left Join skills_dim as sd on sd.skill_id = sjd.skill_id
where jpf.job_title_short ='Data Engineer' AND jpf.job_country = 'Nigeria'
Group by sd.skills
Order by skill_count desc
LIMIT 10;
```

**Key Finding:** SQL and Python dominate. No data warehouse platform 
appears in Nigeria's top 10.

---

### 2. Top Paying Skills - Global View
Calculated median salary per skill across all countries to identify 
which specialisations command the highest compensation.

```sql
Select sd.skills, Median(jpf.salary_year_avg) Median_salary,
count(jpf.job_id) skill_count
from job_postings_fact as jpf
Join skills_job_dim as sjd on sjd.job_id = jpf.job_id
Join skills_dim as sd on sd.skill_id = sjd.skill_id
where jpf.job_title_short ='Data Engineer'
Group By sd.skills
Order By Median_salary desc
Limit 20;
```

**Key Finding:** Mongo leads at $201,000 median salary. Many top paying 
skills have low demand counts - high reward but narrow opportunity.

---

### 3. Optimal Skills - Balancing Demand & Pay
Combined demand and salary into a single score using a logarithmic 
formula to prevent high-volume skills from unfairly dominating the ranking.

```sql
ROUND((LN(COUNT(jpf.*)) * MEDIAN(jpf.salary_year_avg))/1_000_000, 2) 
AS optimal_score
```

**Key Finding:** Terraform scores highest but Python and SQL are the 
true optimal skills when volume and pay are balanced. Clear priority 
roadmap: Python & SQL → AWS, Spark, Airflow → Terraform & Kafka.

## SQL Skills Demonstrated

### Query Construction
- **Multi-table Joins** - Connected fact and dimension tables across
  three tables (job_postings_fact, skills_job_dim, skills_dim) to
  enrich job postings with skill context
- **Filtering** - Applied WHERE clauses to isolate specific job titles,
  countries, and remote roles from 1.6 million rows
- **Aliasing** - Used column aliases throughout for clean, readable
  and analyst-friendly output
- **Sorting & Limiting** - ORDER BY with DESC and LIMIT for top-N analysis

### Data Analysis Techniques
- **Grouping** - GROUP BY for categorical analysis by skill
- **Conditional Logic** - CASE WHEN statements for derived metrics
- **Mathematical Functions** - LN() for natural logarithm transformation
  to normalize demand metrics
- **Calculated Metrics** - Derived optimal score combining log-transformed
  demand with median salary
- **HAVING Clause** - Filtering aggregated results (skills with >= 100 postings)
- **NULL Handling** - Proper filtering of incomplete records
  (`salary_year_avg IS NOT NULL`)

