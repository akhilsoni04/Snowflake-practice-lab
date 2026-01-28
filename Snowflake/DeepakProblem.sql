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

PUT file://C:/path of your file/DeepalEmployeesData.csv 
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



-- Loads data from a CSV file in a stage into the employees table while transforming it.

/* Snowflake does allow many transformation functions inside COPY when they are simple row-level expressions. 
The restriction applies to joins, aggregations, and complex queries, not basic transformations like UPPER, LOWER, COALESCE, or type casting. */


/* In Snowflake COPY INTO ... FROM (SELECT ...), only row-by-row transformations are allowed (like casting, UPPER/LOWER, COALESCE, TRY_TO_DATE). 
Operations that require multiple rows or other tables (like JOIN, GROUP BY, window functions, or subqueries) are not allowed. */


/* 
We were using direct tranformation like this

COPY INTO employees
(first_name, last_name, email, phone_number, salary, department_id, hire_date)
FROM (
  SELECT
    UPPER($1),
    UPPER($2),
    LOWER($3),
    $4,
    COALESCE($5::NUMBER, 0),
    $6::NUMBER,
    COALESCE(TRY_TO_DATE($7, 'MM/DD/YYYY'), CURRENT_DATE())
  FROM @EMP_STAGE/DeepalEmployeesData.csv
)
FILE_FORMAT = ff_emp_csv;


    - Major mistake part

COPY INTO employees
FROM (
  SELECT
    UPPER($1),        ❌ Error here!
    LOWER($3),        ❌ Error here!
    COALESCE($5::NUMBER, 0)  ❌ Error here!
  FROM @EMP_STAGE/DeepalEmployeesData.csv
)
FILE_FORMAT = ff_emp_csv;

---

The Mistakes:
❌ Mistake #1: Using Functions Not Supported in COPY INTO

    You tried to use:
`UPPER()` - Not allowed in COPY INTO
`LOWER()` - Not allowed in COPY INTO
`COALESCE()` - Not allowed in COPY INTO
`TRY_TO_DATE()` - Not allowed in COPY INTO

* Snowflake's COPY INTO has LIMITED transformation support.

    Only these are allowed:
✅ Column references: `$1, $2, $3`
✅ Type casting: `$1::VARCHAR`, `$5::NUMBER`, `$7::DATE`
✅ Simple column reordering

    NOT allowed:
❌ String functions: `UPPER, LOWER, TRIM, CONCAT`
❌ Conditional functions: `COALESCE, CASE, IFF`
❌ Date functions: `TRY_TO_DATE, DATEADD, DATEDIFF`
❌ Math functions: `ROUND, FLOOR, ABS`
❌ Aggregate functions: `SUM, AVG, COUNT`


❌ Mistake #2: Trying to Do Everything in One Step**

Your approach:
CSV → Transform while loading → Final table


Problem: Snowflake doesn't support complex transformations during COPY.
Correct approach (what you're doing now):

CSV → Load raw → Transform in SQL → Final table
*/


-- Load to Staging, Then Transform to Final Table (Better!)
-- Step 1: Load raw data to staging table
CREATE OR REPLACE TABLE employees_stage (
    first_name STRING,
    last_name STRING,
    email STRING,
    phone_number STRING,
    salary NUMBER,
    department_id NUMBER,
    hire_date DATE
);


-- Step 2: Simple COPY (no transformations)
COPY INTO employees_stage
FROM @EMP_STAGE/DeepalEmployeesData.csv
FILE_FORMAT = ff_emp_csv;


-- Step 3: Transform and insert into final table
CREATE OR REPLACE TABLE employees AS
SELECT
    UPPER(first_name) as first_name,
    UPPER(last_name) as last_name,
    LOWER(email) as email,
    phone_number,
    COALESCE(salary, 0) as salary,
    department_id,
    COALESCE(hire_date, CURRENT_DATE()) as hire_date
FROM employees_stage;


-- Step 4: Verify
SELECT * FROM employees LIMIT 10;


/*  
Problem & Solution Note

Problem:
Cannot use transformation functions like UPPER(), LOWER(), COALESCE() directly in COPY INTO statement because Snowflake's COPY command only supports basic operations (column references $1, $2 and type casting ::NUMBER, ::DATE).

Solution:
Use two-step ELT approach:

1. Load raw data into staging table using COPY INTO (no transformations)
2. Transform data using CREATE TABLE AS SELECT with any SQL functions
*/