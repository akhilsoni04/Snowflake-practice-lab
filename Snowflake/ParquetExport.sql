USE DATABASE HCL;
USE SCHEMA PUBLIC;

-- STEP 1 — What We Are Doing
/*
We are going to:

1️⃣ Take data from a Snowflake table
2️⃣ Convert it into Parquet format
3️⃣ Store it in a stage (internal or external)

Snowflake command used: COPY INTO
*/

-- STEP 2 — Creating Sample Table (Practice Data)
CREATE OR REPLACE TABLE employees_parquet (
    emp_id INT,
    name STRING,
    department STRING,
    salary NUMBER
);

-- Insert some data
INSERT INTO employees_parquet VALUES
(1, 'Akhil', 'Engineering', 70000),
(2, 'Ravi', 'HR', 50000),
(3, 'Neha', 'Engineering', 72000),
(4, 'Priya', 'Finance', 65000);


-- STEP 3 — Create a Stage (Storage Location)
--Internal Stage

CREATE OR REPLACE STAGE parquet_stage;


-- Step 4 Create a Parquet File Format
CREATE OR REPLACE FILE FORMAT parquet_format
TYPE = PARQUET
COMPRESSION = SNAPPY;   -- Best and most common

-- SNAPPY?
-- Fast compression + widely supported in big data tools.

-- STEP 5 — Export Table to Parquet

COPY INTO @parquet_stage/my_first_parquet_export//
FROM employees_parquet
FILE_FORMAT = (FORMAT_NAME = parquet_format)
HEADER = TRUE
OVERWRITE = TRUE;

-- if needed remove it
REMOVE @parquet_stage/my_first_parquet_export/;


-- STEP 6 — Check Exported Files
LIST @parquet_stage/my_first_parquet_export;



-- These are some parts which you can do 
-- STEP 7 — Download the Parquet File (Optional)

GET @parquet_stage/employees_parquet file://C:/data/parquet_files;

-- STEP 8 — Export Only Selected Columns (Optimization)
COPY INTO @parquet_stage/high_salary/
FROM (
    SELECT emp_id, salary
    FROM employees
    WHERE salary > 60000
)
FILE_FORMAT = (TYPE = PARQUET);

--Now only 2 columns are stored → smaller & faster for analytics.

-- “In Snowflake, Parquet export is done using COPY INTO with FILE_FORMAT = PARQUET to unload columnar, compressed files to a stage or data lake for efficient big data processing.”



-- Testing 
CREATE OR REPLACE FILE FORMAT parquet_read_format
TYPE = PARQUET;


SELECT *
FROM @parquet_stage/employees_parquet/
(FILE_FORMAT => parquet_read_format);
