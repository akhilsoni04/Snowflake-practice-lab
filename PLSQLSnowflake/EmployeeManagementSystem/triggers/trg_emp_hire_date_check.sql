CREATE OR REPLACE TRIGGER emp_hire_date_check
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
  IF :NEW.hire_date IS NOT NULL AND :NEW.hire_date > SYSDATE THEN
    RAISE_APPLICATION_ERROR(-20001, 'Hire date cannot be in future');
  END IF;
END emp_hire_date_check;
/