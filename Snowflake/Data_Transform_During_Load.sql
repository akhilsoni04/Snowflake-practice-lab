-- Load and transform data 

-- Using SELECT in COPY:

COPY INTO employees
FROM (
  SELECT
    $1::NUMBER AS employee_id,
    UPPER($2) AS first_name,
    UPPER($3) AS last_name,
    LOWER($4) AS email,
    COALESCE($5::NUMBER, 0) AS salary,
    $6::NUMBER AS department_id,
    COALESCE(TRY_TO_DATE($7, 'MM/DD/YYYY'), CURRENT_DATE()) AS hire_date
  FROM @EMP_STAGE/employees.csv
) 
FILE_FORMAT = ff_emp_csv
ON_ERROR = CONTINUE;


-- Load RAW data into staging table (no transformation)
COPY INTO employees_stage
FROM @EMP_STAGE/employees.csv
FILE_FORMAT = ff_emp_csv
ON_ERROR = CONTINUE;



-- Transform-During-Load for employees
INSERT INTO employees (
    employee_id,
    first_name,
    last_name,
    email,
    salary,
    department_id,
    hire_date
)
SELECT
    employee_id,
    UPPER(first_name),
    UPPER(last_name),
    LOWER(email),
    COALESCE(salary, 0),
    department_id,
    COALESCE(hire_date, CURRENT_DATE())
FROM employees_stage;


-- STEP 1 — Check Raw File Data Before Loading
SELECT * 
FROM @EMP_STAGE/employees.csv
(FILE_FORMAT => ff_emp_csv)
LIMIT 5;
-- This lets you preview the file without loading.


-- STEP 2 — Load Into Staging Table
COPY INTO employees_stage
FROM @EMP_STAGE/employees.csv
FILE_FORMAT = ff_emp_csv
ON_ERROR = CONTINUE;


--Check if rows loaded:
SELECT COUNT(*) FROM employees_stage;
SELECT * FROM employees_stage LIMIT 5;


-- STEP 3 — Test Transform Logic Before Insert
SELECT
    employee_id,
    UPPER(first_name) AS first_name,
    UPPER(last_name) AS last_name,
    LOWER(email) AS email,
    COALESCE(salary, 0) AS salary,
    department_id,
    COALESCE(hire_date, CURRENT_DATE()) AS hire_date
FROM employees_stage
LIMIT 5;


-- STEP 4 — Insert Into Final Table
INSERT INTO employees (
    employee_id,
    first_name,
    last_name,
    email,
    salary,
    department_id,
    hire_date
)
SELECT
    employee_id,
    UPPER(first_name),
    UPPER(last_name),
    LOWER(email),
    COALESCE(salary, 0),
    department_id,
    COALESCE(hire_date, CURRENT_DATE())
FROM employees_stage;

-- STEP 5 — Validate Final Data
SELECT * FROM employees ORDER BY employee_id;




-- Complex data tranforming
-- STEP 1 — Raw Staging Table (That Already i have)
-- STEP 2 — Create Final Summary Table
-- Load data



-- STEP 2 — Create Final Summary Table
CREATE OR REPLACE TABLE department_salary_summary (
    department_id NUMBER,
    department_name STRING,
    employee_count NUMBER,
    total_salary NUMBER(12,2),
    avg_salary NUMBER(10,2)
);


-- STEP 3 — Complex Transformation (Like Your Sales Example)

-- Now we apply filtering, join, aggregation:

INSERT INTO department_salary_summary
SELECT
    e.department_id,
    d.department_name,
    COUNT(*) AS employee_count,
    SUM(COALESCE(e.salary, 0)) AS total_salary,
    AVG(COALESCE(e.salary, 0)) AS avg_salary
FROM employees_stage e
JOIN departments d
    ON e.department_id = d.department_id   -- Filtering valid departments
WHERE e.salary IS NOT NULL                -- Filtering invalid salary rows
GROUP BY e.department_id, d.department_name;


/* | Transformation Type | How You Did It               
 ------------------- | ---------------------------- 
 Filtering           | `WHERE e.salary IS NOT NULL` 
 Lookup / Join       | `JOIN departments`           
 Aggregation         | `COUNT, SUM, AVG`            
 Deduplication       | `GROUP BY department_id`     
*/

-- STEP 4 — Verify Result
SELECT * FROM department_salary_summary ORDER BY department_id;



-- Surrogate Key Generation
-- STEP 1 — Staging Table (Raw Load)
-- Load data

-- STEP 2 — Final Employee Dimension Table

CREATE OR REPLACE TABLE dim_employees (
    emp_sk NUMBER,              -- Surrogate key
    employee_id NUMBER,         -- Business key
    first_name STRING,
    last_name STRING,
    email STRING,
    salary NUMBER(10,2),
    department_id NUMBER,
    hire_date DATE
);


-- STEP 3 — Deduplicate + Generate Surrogate Key

-- We remove duplicates based on employee_id.

INSERT INTO dim_employees
SELECT
    DENSE_RANK() OVER (ORDER BY employee_id) AS emp_sk,
    employee_id,
    UPPER(first_name) AS first_name,
    UPPER(last_name) AS last_name,
    LOWER(email) AS email,
    COALESCE(salary, 0) AS salary,
    department_id,
    COALESCE(hire_date, CURRENT_DATE()) AS hire_date
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY employee_id ORDER BY hire_date DESC) AS rn
    FROM employees_stage
)
WHERE rn = 1;


-- STEP 4 — Verify
SELECT * FROM dim_employees ORDER BY emp_sk;




-- testing of unloaded data
-- Step 1 — Check If Files Were Created
LIST @my_unload_stage;

-- Step 2 — Preview File Content Inside Snowflake
SELECT $1, $2, $3, $4, $5
FROM @my_unload_stage/employees_export_0_0_0.csv
(FILE_FORMAT => ff_unload_csv)
LIMIT 10;


-- Step 3 — Compare Row Count
-- Check original table:
SELECT COUNT(*) FROM employees;


-- Then count rows in file:

SELECT COUNT(*)
FROM @my_unload_stage/employees_export_0_0_0.csv
(FILE_FORMAT => ff_unload_csv);


-- Step 4 — Download File (Optional)
/*

Go to Data → Stages
Open MY_UNLOAD_STAGE
Select the file
Click Download 

*/


-- View data directly from unloaded stage
SELECT $1, $2, $3, $4, $5, 
FROM @my_unload_stage/employees_export_0_0_0.csv
LIMIT 10;

