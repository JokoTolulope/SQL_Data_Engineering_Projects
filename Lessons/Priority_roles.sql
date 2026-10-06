--.read Lessons/Priority_roles.sql
USE job_mart;

CREATE OR REPLACE TABLE staging.priority_roles(
            role_id INTEGER PRIMARY KEY,
            role_name VARCHAR,
            priority INTEGER
);

INSERT INTO staging.priority_roles(role_id, role_name, priority)
VALUES(1, 'Data Engineer', 1),
      (2, 'Senior Data Engineer', 1),
      (3, 'Software Engineer', 3);

SELECT * FROM staging.priority_roles;