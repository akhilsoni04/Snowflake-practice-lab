-- Rank employees by salary within department
SELECT 
  e.first_name || ' ' || e.last_name AS emp_name,
  e.salary, e.department_id,
  RANK() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC) 
  AS
  rank_in_dept FROM employees e;