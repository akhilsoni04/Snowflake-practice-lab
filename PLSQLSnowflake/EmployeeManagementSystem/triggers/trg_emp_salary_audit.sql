CREATE OR REPLACE TRIGGER emp_salary_audit
AFTER UPDATE OF salary ON employees
FOR EACH ROW 

BEGIN 
    INSERT INTO salary_history (history_id, employee_id, old_salary, new_salary, change_date) 
    VALUES (salary_history_seq.NEXTVAL, :OLD.employee_id, :OLD.salary, :NEW.salary, SYSDATE);    
END emp_salary_audit;
/