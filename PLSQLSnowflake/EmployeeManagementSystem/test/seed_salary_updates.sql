SET SERVEROUTPUT ON;

BEGIN
  emp_management.update_salary(101, 52000);
  emp_management.update_salary(102, 78000);
  emp_management.update_salary(201, 47000);
  emp_management.update_salary(401, 43000);

  DBMS_OUTPUT.PUT_LINE('✅ Salary updates done, salary_history should be filled.');
END;
/
