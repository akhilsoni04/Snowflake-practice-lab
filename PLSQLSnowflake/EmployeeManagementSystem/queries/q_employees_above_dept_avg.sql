-- Employees earning above department average
SELECT 
  e.first_name || ' ' || e.last_name AS emp_name,
  e.salary,
  (SELECT ROUND(AVG(salary), 2)
     FROM employees
    WHERE department_id = e.department_id) AS dept_avg
FROM employees e
WHERE e.salary >
  (SELECT AVG(salary)
     FROM employees
    WHERE department_id = e.department_id);
