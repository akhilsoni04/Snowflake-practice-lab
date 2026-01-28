-- Assign Database & Schema
USE DATABASE HCL;
USE SCHEMA PUBLIC;

-- creating a new table to store data
CREATE OR REPLACE TABLE employees (
    employee_id NUMBER AUTOINCREMENT,  -- system-generated
    first_name STRING,
    last_name STRING,
    email STRING,
    phone_number STRING,
    salary NUMBER(10,2),
    department_id NUMBER,
    hire_date DATE
);


-- create stage
CREATE OR REPLACE STAGE emp_stage;


-- Create File Format
CREATE OR REPLACE FILE FORMAT ff_emp_csv
TYPE = CSV
FIELD_DELIMITER = ','
SKIP_HEADER = 1
FIELD_OPTIONALLY_ENCLOSED_BY = '"'
NULL_IF = ('NULL', 'null', '');


-- Upload File to Stage

-- IF using vs code run this command in terminal or if you are using snowflake ui then manually do it from ingestion
--PUT file://C:/path/to/your/employees.csv @emp_stage AUTO_COMPRESS=TRUE;

PUT file://C:/Users/HP/OneDrive/Desktop/PL_SQL_Snowflake/DeepalEmployeesData.csv 
    @emp_stage 
    AUTO_COMPRESS=TRUE;


-- Load Data into Table
COPY INTO employees
(first_name, last_name, email, phone_number, salary, department_id, hire_date)
FROM @emp_stage/DeepalEmployeesData.csv
FILE_FORMAT = ff_emp_csv
ON_ERROR = CONTINUE;


LIST @emp_stage;


-- validate loading
SELECT COUNT(*) FROM employees;
SELECT * FROM employees LIMIT 10;
