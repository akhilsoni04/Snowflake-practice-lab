# Expected Output – Employee Management System (PL/SQL)

This file describes the expected results after running the complete test scripts.

---

## ✅ 1) Seed Data Execution

### After running:
- `seed_departments.sql`
- `seed_employees.sql`

### Expected:
Departments and Employees should be inserted successfully.

---

## ✅ 2) Seed Salary Updates Execution

### After running:
- `seed_salary_updates.sql`

### Expected DBMS_OUTPUT:
✅ Salary updates done, salary_history should be filled.

---

## ✅ 3) Running Main Test Script

### After running:
- `test_run_all.sql`

---

## ✅ Expected DBMS_OUTPUT

### Hire Employees
Expected messages:
- ✅ Seed employees inserted successfully.
- Employee hired successfully (if included in script)

### Bonus Calculation
Example expected output:
- ✅ Bonus for emp 102 (15%) = 11700

(Actual bonus depends on current salary value)

### Termination
Expected message:
- ✅ Employee 401 terminated.

---

## ✅ 4) Expected Table Output

---

### A) EMPLOYEES Table
Query:
```sql
SELECT employee_id, first_name, last_name, salary, department_id, status
FROM employees
ORDER BY employee_id;
