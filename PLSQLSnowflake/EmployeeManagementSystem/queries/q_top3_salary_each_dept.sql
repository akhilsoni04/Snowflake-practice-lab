-- Find top 3 highest paid employees in each department 
SELECT *
FROM (
  SELECT 
    e.first_name || ' ' || e.last_name AS emp_name,
    e.department_id,
    e.salary,
    DENSE_RANK() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC) AS rnk
  FROM employees e
)
WHERE rnk <= 3;