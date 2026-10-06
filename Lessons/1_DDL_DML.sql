-- .read Lessons/1_DDL_DML.sql
USE data_jobs;

DROP DATABASE IF EXISTS job_mart;

CREATE DATABASE IF NOT EXISTS job_mart;

SHOW DATABASES;

CREATE SCHEMA IF NOT EXISTS job_mart.staging;
SELECT * FROM Information_schema.schemata;

USE job_mart;

CREATE TABLE IF NOT EXISTS staging.preferred_roles(
    role_id INTEGER PRIMARY KEY,
    role_name VARCHAR
);

Select table_name, table_schema from information_schema.tables;

INSERT INTO staging.preferred_roles(role_id, role_name)
Select 1, 'Data Engineer',
Union All Select 2, 'Senior Data Engineer',
Union All Select 3, 'Software Engineer';

Select * from staging.preferred_roles;

ALTER TABLE staging.preferred_roles
ADD COLUMN preferred_role BOOLEAN;

UPDATE staging.preferred_roles
SET preferred_role = TRUE
WHERE role_id in(1,2);

UPDATE staging.preferred_roles
SET preferred_role = FALSE
WHERE role_id in(3);

ALTER TABLE staging.preferred_roles
RENAME TO priority_roles;

ALTER TABLE staging.priority_roles
RENAME COLUMN preferred_role TO priority;

ALTER TABLE staging.priority_roles
ALTER COLUMN priority TYPE INTEGER;

UPDATE staging.priority_roles
SET priority = 3
WHERE role_id = 3;

Select * from staging.priority_roles;

