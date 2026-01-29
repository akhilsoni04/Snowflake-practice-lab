
-- Data Unload

-- STEP 1 — Make Sure You Have Data
SELECT * FROM employees;

-- STEP 2 — Create a Stage (Storage Location)
CREATE OR REPLACE STAGE my_unload_stage;


-- Creation of  File Format for Unload
CREATE OR REPLACE FILE FORMAT ff_unload_csv
TYPE = CSV
FIELD_DELIMITER = ','
FIELD_OPTIONALLY_ENCLOSED_BY = '"'
NULL_IF = ('NULL', 'null')
EMPTY_FIELD_AS_NULL = TRUE
COMPRESSION = NONE


-- STEP 3 — Unload Data Using COPY INTO
COPY INTO @my_unload_stage/employees_export
FROM employees
FILE_FORMAT = ff_unload_csv
OVERWRITE = TRUE;


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


-- 🧪 Step 4 — Download File (Optional)
/*
Go to Data → Stages
Open MY_UNLOAD_STAGE
Select the file
Click Download */


-- View data directly from unloaded stage
SELECT $1, $2, $3, $4, $5, 
FROM @my_unload_stage/employees_export_0_0_0.csv
LIMIT 10;


