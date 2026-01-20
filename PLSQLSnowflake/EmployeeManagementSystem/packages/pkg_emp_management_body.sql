-- Package BODY 

CREATE OR REPLACE PACKAGE BODY emp_management
IS
  PROCEDURE hire_employee (
    p_emp_id      IN NUMBER,
    p_first_name  IN VARCHAR2,
    p_last_name   IN VARCHAR2,
    p_email       IN VARCHAR2,
    p_salary      IN NUMBER,
    p_dept_id     IN NUMBER
  )
  IS
    v_count NUMBER;
  BEGIN
    IF p_salary <= 0 THEN
      RAISE_APPLICATION_ERROR(-20001, 'Salary must be greater than 0');
    END IF;

    SELECT COUNT(*)
    INTO v_count
    FROM departments
    WHERE department_id = p_dept_id;

    IF v_count = 0 THEN
      RAISE_APPLICATION_ERROR(-20002, 'Department does not exist');
    END IF;

    INSERT INTO employees(employee_id, first_name, last_name, email, salary, department_id)
    VALUES (p_emp_id, p_first_name, p_last_name, p_email, p_salary, p_dept_id);

    COMMIT;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      ROLLBACK;
      RAISE_APPLICATION_ERROR(-20003, 'Duplicate employee id/email');
    WHEN OTHERS THEN
      ROLLBACK;
      RAISE_APPLICATION_ERROR(-20099, 'Hire employee failed: ' || SQLERRM);
  END hire_employee;


  PROCEDURE update_salary(
    p_emp_id      IN NUMBER,
    p_new_salary  IN NUMBER
  )
  IS
  BEGIN
    IF p_new_salary <= 0 THEN
      RAISE_APPLICATION_ERROR(-20011, 'New salary must be greater than 0');
    END IF;

    UPDATE employees
    SET salary = p_new_salary
    WHERE employee_id = p_emp_id;

    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-20012, 'Employee not found');
    END IF;

    COMMIT; -- trigger will insert into salary_history
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      RAISE_APPLICATION_ERROR(-20098, 'Update salary failed: ' || SQLERRM);
  END update_salary;


  FUNCTION calculate_bonus(
    p_emp_id        IN NUMBER,
    p_bonus_percent IN NUMBER
  ) RETURN NUMBER
  IS
    v_salary employees.salary%TYPE;
  BEGIN
    IF p_bonus_percent < 0 OR p_bonus_percent > 1 THEN
      RAISE_APPLICATION_ERROR(-20021, 'Bonus percent must be between 0 and 1');
    END IF;

    SELECT salary INTO v_salary
    FROM employees
    WHERE employee_id = p_emp_id;

    RETURN v_salary * p_bonus_percent;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20022, 'Employee not found for bonus calculation');
  END calculate_bonus;


  PROCEDURE terminate_employee(
    p_emp_id IN NUMBER
  )
  IS
  BEGIN
    UPDATE employees
    SET status = 'TERMINATED'
    WHERE employee_id = p_emp_id;

    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-20031, 'Employee not found');
    END IF;

    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      RAISE_APPLICATION_ERROR(-20097, 'Termination failed: ' || SQLERRM);
  END terminate_employee;

END emp_management;
/
