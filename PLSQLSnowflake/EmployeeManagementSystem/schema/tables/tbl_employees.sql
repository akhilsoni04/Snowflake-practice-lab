CREATE TABLE employees(
    employee_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    email VARCHAR2(100) UNIQUE,
    salary NUMBER(10,2) CHECK(salary > 0),
    department_id NUMBER NOT NULL,
    hire_date DATE DEFAULT SYSDATE,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);