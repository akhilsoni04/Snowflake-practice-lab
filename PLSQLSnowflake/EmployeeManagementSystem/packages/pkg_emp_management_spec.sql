-- Package Specification {Procedures , Function}
CREATE OR REPLACE PACKAGE emp_management 
IS 
    -- Procedure Will do actions (insert/update/delete)
    PROCEDURE hire_employee (
        p_emp_id IN NUMBER,
        p_first_name IN VARCHAR2,
        p_last_name IN VARCHAR2,
        p_email IN VARCHAR2,
        p_salary IN NUMBER,
        p_dept_id IN NUMBER
    );
    
    PROCEDURE update_salary(
        p_emp_id IN NUMBER,
        p_new_salary IN NUMBER
    );
    
    -- Return something (bonus amount)
    FUNCTION calculate_bonus(
        p_emp_id IN NUMBER,
        p_bonus_percent IN NUMBER
    ) 
    RETURN NUMBER;
    
    PROCEDURE terminate_employee(
        p_emp_id IN NUMBER
    );

END emp_management;
/