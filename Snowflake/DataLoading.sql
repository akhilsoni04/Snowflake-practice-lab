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



-------------------------------
-- Data Loading using json file


--Step 1 — Create Table for JSON
CREATE OR REPLACE TABLE employees_json (
    raw_data VARIANT
);

-- Step 2 — Create Stage
CREATE OR REPLACE STAGE my_json_stage;

--Step 3 — Create JSON File Format
CREATE OR REPLACE FILE FORMAT ff_json
TYPE = JSON
STRIP_OUTER_ARRAY = TRUE;

/* PUT file://C:/path of file/EmployeeJsonFile.json 
    @my_json_stage 
    AUTO_COMPRESS=TRUE;
*/

-- verify uploading 
LIST @my_json_stage;


-- Load the Data

-- Load JSON into table
COPY INTO employees_json
FROM @my_json_stage/EmployeeJsonFile.json
FILE_FORMAT = ff_json
ON_ERROR = 'CONTINUE';

-- Verify loaded
SELECT COUNT(*) FROM employees_json;

-- View data
SELECT * FROM employees_json LIMIT 10;


--------------------------
-- Now unloading json file

--Step 1: Verify Source Data

-- Check your source table
SELECT * FROM employees LIMIT 10;

-- Check row count
SELECT COUNT(*) as total_rows FROM employees;

-- see the json data 
SELECT *
FROM @my_json_stage/EmployeeJsonFile.json
(FILE_FORMAT => ff_json)
LIMIT 10;


-- Step 2: Create Stage for JSON Unload
-- Create a new stage for unloaded JSON files
CREATE OR REPLACE STAGE json_unload_stage;

-- Verify stage created
SHOW STAGES LIKE 'json_unload_stage';


-- Step 3: Create JSON File Format for Unload
-- Create file format for JSON output
CREATE OR REPLACE FILE FORMAT ff_json_unload
TYPE = JSON
COMPRESSION = GZIP;  -- Compress to save space

-- Verify file format
SHOW FILE FORMATS LIKE 'ff_json_unload';


-- Step 4: Unload Data to JSON
-- Unload entire table as JSON

COPY INTO @json_unload_stage/employees_unload
FROM (
    SELECT OBJECT_CONSTRUCT(*) 
    FROM employees
)
FILE_FORMAT = ff_json_unload
OVERWRITE = TRUE;


-- Step 5 — Check Files Created
LIST @json_unload_stage;


-- Step 6 — Preview Unloaded JSON Data (without download)
SELECT *
FROM @json_unload_stage/employees_unload
(FILE_FORMAT => ff_json_unload)
LIMIT 10;


-- Step 7 — Extract Fields from JSON (Optional)
SELECT
  $1:EMPLOYEE_ID::NUMBER   AS employee_id,
  $1:FIRST_NAME::STRING    AS first_name,
  $1:SALARY::NUMBER        AS salary
FROM @json_unload_stage/employees_unload
(FILE_FORMAT => ff_json_unload);


-- Step 8 — Count Rows in Unloaded JSON
SELECT COUNT(*)
FROM @json_unload_stage/employees_unload
(FILE_FORMAT => ff_json_unload);

--View Unloaded JSON Data
SELECT *
FROM @json_unload_stage/employees_unload
(FILE_FORMAT => ff_json_unload)
LIMIT 10;