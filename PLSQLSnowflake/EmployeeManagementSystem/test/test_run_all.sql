SET SERVEROUTPUT ON;

-- ==========================
-- A) Calculate bonus
-- ==========================
DECLARE
  v_bonus NUMBER;
BEGIN
  v_bonus := emp_management.calculate_bonus(102, 0.15);
  DBMS_OUTPUT.PUT_LINE('✅ Bonus for emp 102 (15%) = ' || v_bonus);
END;
/

-- ==========================
-- B) Terminate employee
-- ==========================
BEGIN
  emp_management.terminate_employee(401);
  DBMS_OUTPUT.PUT_LINE('✅ Employee 401 terminated.');
END;
/

-- ==========================
-- C) Check salary history
-- ==========================
SELECT * FROM salary_history
WHERE employee_id IN (101,102,201,401)
ORDER BY change_date DESC;

-- ==========================
-- D) Complex Query: above dept average
-- ==========================
SELECT 
  e.first_name || ' ' || e.last_name AS emp_name,
  e.salary,
  (SELECT ROUND(AVG(salary),2)
     FROM employees
    WHERE department_id = e.department_id) AS dept_avg
FROM employees e
WHERE e.salary >
  (SELECT AVG(salary)
     FROM employees
    WHERE department_id = e.department_id);

-- ==========================
-- E) Ranking: salary rank in each dept
-- ==========================
SELECT 
  e.first_name || ' ' || e.last_name AS emp_name,
  e.department_id,
  e.salary,
  RANK() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC) AS rank_in_dept
FROM employees e;

-- ==========================
-- F) Top 3 salary in each dept
-- ==========================
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

-- ==========================
-- G) Verify termination
-- ==========================
SELECT employee_id, first_name, last_name, status
FROM employees
WHERE employee_id = 401;
