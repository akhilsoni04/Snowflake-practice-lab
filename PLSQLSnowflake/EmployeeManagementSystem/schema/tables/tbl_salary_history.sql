CREATE TABLE salary_history(
    history_id NUMBER PRIMARY KEY,
    employee_id NUMBER NOT NULL,
    old_salary NUMBER(10,2),
    new_salary NUMBER(10,2),
    change_date DATE DEFAULT SYSDATE,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);