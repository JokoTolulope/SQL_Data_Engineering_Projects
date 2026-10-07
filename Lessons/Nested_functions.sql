--Array
Select [1, 2, 3];

Select ['Python', 'sql', 'excel'] AS skills_array;

WITH skills AS(
Select 'python' AS skill
Union All 
Select 'sql'
Union All 
Select 'r')

Select ARRAY_AGG(skill) AS skills_array
FROM skills;