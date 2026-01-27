
-- Employee Management System 
USE EMPLOYEEMANAGEMENT;

-- Table Creation
CREATE TABLE departments (
    department_id NUMBER PRIMARY KEY,
    department_name VARCHAR2(100) NOT NULL UNIQUE
);

-- departments data
INSERT INTO departments (department_id, department_name)
VALUES
(10, 'IT'),
(20, 'HR'),
(30, 'Finance'),
(40, 'Sales');

SELECT * FROM departments;
TRUNCATE TABLE departments;


CREATE OR REPLACE TABLE employees(
    employee_id NUMBER PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    salary NUMBER(10,2) ,
    department_id NUMBER NOT NULL,
    hire_date DATE DEFAULT CURRENT_DATE(),
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

CREATE TABLE salary_history(
    history_id NUMBER PRIMARY KEY,
    employee_id NUMBER NOT NULL,
    old_salary NUMBER(10,2),
    new_salary NUMBER(10,2),
    change_date DATE DEFAULT CURRENT_DATE(),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);


-- Defining the packages 
-- CREATE PACKAGE 
CREATE OR REPLACE PROCEDURE hire_employee
(
    p_emp_id NUMBER,
    p_first_name VARCHAR,
    p_last_name VARCHAR,
    p_email VARCHAR,
    p_salary NUMBER,
    p_dept_id NUMBER
)
RETURNS STRING
LANGUAGE SQL 
AS
$$
DECLARE 
    v_message STRING;
BEGIN
    -- salary validation 
    IF (p_salary <= 0) THEN 
        v_message := 'ERROR : Salray must be greater than 0';
        RETURN v_message;
    END IF;

    -- Email validation
    IF (NOT REGEXP_LIKE(p_email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')) THEN
        v_message := 'Error: Invalid email address'; 
        RETURN v_message;
    END IF;

    -- Insert row
    INSERT INTO employees(employee_id, first_name, last_name, email, salary, department_id, hire_date)
    VALUES
    (p_emp_id, p_first_name, p_last_name, p_email, p_salary, p_dept_id, CURRENT_DATE());

    -- Return success message 
    v_message := 'Employee hired successfully';
    RETURN v_message;

EXCEPTION
    WHEN OTHER THEN 
        v_message := 'Employee hiring failed'; 
        RETURN v_message;
END;
$$


-- Stage creation for testing csv data 

CREATE OR REPLACE STAGE EMP_STAGE;
SHOW STAGES;

-- Step 1: Confirm file stage me hai
LIST @EMP_STAGE;

-- remove xls file from stage
REMOVE @EMP_STAGE/EmployeeDataSnowflakeOne.xlsx;



-- Step 2: Create File Format (CSV)
CREATE OR REPLACE FILE FORMAT ff_emp_csv
TYPE = CSV
FIELD_DELIMITER = ','
SKIP_HEADER = 1
FIELD_OPTIONALLY_ENCLOSED_BY = '"'
NULL_IF = ('', 'NULL', 'null');


-- Step 3: Create Staging Table (Excel rows hold karne ke liye)
CREATE OR REPLACE TABLE employees_stage (
    employee_id NUMBER,
    first_name STRING,
    last_name STRING,
    email STRING,
    salary NUMBER(10,2),
    department_id NUMBER,
    hire_date DATE
);


-- Step 4: Copy data from stage → staging table
COPY INTO employees_stage
FROM @EMP_STAGE
FILE_FORMAT = ff_emp_csv;


-- Step 5: Verify staging table loaded
SELECT * FROM employees_stage ORDER BY employee_id;


-- TeSTing
SELECT employee_id, first_name, last_name, email, salary, department_id
FROM employees_stage
ORDER BY employee_id
LIMIT 1;


CALL hire_employee(1001,'Akhil','Soni','akhil@gmail.com',50000,10);


SELECT * FROM departments WHERE department_id = 10;
SELECT * FROM employees WHERE employee_id = 1001;




-- A Single Procedure and practice on that by akhil / A Second portion of this work is at data_transform_during_load.sql


-- Employee Management System 
USE EMPLOYEEMANAGEMENT;

-- Table Creation
CREATE TABLE departments (
    department_id NUMBER PRIMARY KEY,
    department_name VARCHAR2(100) NOT NULL UNIQUE
);

-- departments data
INSERT INTO departments (department_id, department_name)
VALUES
(10, 'IT'),
(20, 'HR'),
(30, 'Finance'),
(40, 'Sales');

SELECT * FROM departments;
TRUNCATE TABLE departments;


CREATE OR REPLACE TABLE employees(
    employee_id NUMBER PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    salary NUMBER(10,2) ,
    department_id NUMBER NOT NULL,
    hire_date DATE DEFAULT CURRENT_DATE(),
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

CREATE TABLE salary_history(
    history_id NUMBER PRIMARY KEY,
    employee_id NUMBER NOT NULL,
    old_salary NUMBER(10,2),
    new_salary NUMBER(10,2),
    change_date DATE DEFAULT CURRENT_DATE(),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);


-- Defining the packages 
-- CREATE PACKAGE 
CREATE OR REPLACE PROCEDURE hire_employee
(
    p_emp_id NUMBER,
    p_first_name VARCHAR,
    p_last_name VARCHAR,
    p_email VARCHAR,
    p_salary NUMBER,
    p_dept_id NUMBER
)
RETURNS STRING
LANGUAGE SQL 
AS
$$
DECLARE 
    v_message STRING;
BEGIN
    -- salary validation 
    IF (p_salary <= 0) THEN 
        v_message := 'ERROR : Salray must be greater than 0';
        RETURN v_message;
    END IF;

    -- Email validation
    IF (NOT REGEXP_LIKE(p_email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')) THEN
        v_message := 'Error: Invalid email address'; 
        RETURN v_message;
    END IF;

    -- Insert row
    INSERT INTO employees(employee_id, first_name, last_name, email, salary, department_id, hire_date)
    VALUES
    (p_emp_id, p_first_name, p_last_name, p_email, p_salary, p_dept_id, CURRENT_DATE());

    -- Return success message 
    v_message := 'Employee hired successfully';
    RETURN v_message;

EXCEPTION
    WHEN OTHER THEN 
        v_message := 'Employee hiring failed'; 
        RETURN v_message;
END;
$$


-- Stage creation for testing csv data 

CREATE OR REPLACE STAGE EMP_STAGE;
SHOW STAGES;

-- Step 1: Confirm file stage me hai
LIST @EMP_STAGE;

-- remove xls file from stage
REMOVE @EMP_STAGE/EmployeeDataSnowflakeOne.xlsx;



-- Step 2: Create File Format (CSV)
CREATE OR REPLACE FILE FORMAT ff_emp_csv
TYPE = CSV
FIELD_DELIMITER = ','
SKIP_HEADER = 1
FIELD_OPTIONALLY_ENCLOSED_BY = '"'
NULL_IF = ('', 'NULL', 'null');


-- Step 3: Create Staging Table (Excel rows hold karne ke liye)
CREATE OR REPLACE TABLE employees_stage (
    employee_id NUMBER,
    first_name STRING,
    last_name STRING,
    email STRING,
    salary NUMBER(10,2),
    department_id NUMBER,
    hire_date DATE
);


-- Step 4: Copy data from stage → staging table
COPY INTO employees_stage
FROM @EMP_STAGE
FILE_FORMAT = ff_emp_csv;``


-- Step 5: Verify staging table loaded
SELECT * FROM employees_stage ORDER BY employee_id;


-- TeSTing
SELECT employee_id, first_name, last_name, email, salary, department_id
FROM employees_stage
ORDER BY employee_id
LIMIT 1;


CALL hire_employee(1001,'Akhil','Soni','akhil@gmail.com',50000,10);


SELECT * FROM departments WHERE department_id = 10;
SELECT * FROM employees WHERE employee_id = 1001;
