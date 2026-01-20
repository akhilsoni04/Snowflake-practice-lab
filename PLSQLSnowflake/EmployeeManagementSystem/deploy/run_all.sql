-- ===============================
-- RUN ALL SCRIPT (DEPLOY PROJECT)
-- ===============================
SET SERVEROUTPUT ON;

PROMPT ===============================
PROMPT 1) Creating Tables
PROMPT ===============================
@../01_schema/01_tables/tbl_departments.sql
@../01_schema/01_tables/tbl_employees.sql
@../01_schema/01_tables/tbl_salary_history.sql

PROMPT ===============================
PROMPT 2) Creating Sequence
PROMPT ===============================
@../01_schema/02_sequences/seq_salary_history.sql

PROMPT ===============================
PROMPT 3) Creating Package
PROMPT ===============================
@../02_programs/01_packages/pkg_emp_management_spec.sql
@../02_programs/01_packages/pkg_emp_management_body.sql

PROMPT ===============================
PROMPT 4) Creating Triggers
PROMPT ===============================
@../03_triggers/trg_emp_salary_audit.sql
@../03_triggers/trg_emp_hire_date_check.sql

PROMPT ===============================
PROMPT 5) Creating Indexes
PROMPT ===============================
@../01_schema/03_indexes/idx_emp_dept.sql
@../01_schema/03_indexes/idx_emp_salary.sql
@../01_schema/03_indexes/idx_emp_lastname_upper.sql

PROMPT ===============================
PROMPT 6) Seeding Data
PROMPT ===============================
@../05_tests/seed_departments.sql
@../05_tests/seed_employees.sql
@../05_tests/seed_salary_updates.sql

PROMPT ===============================
PROMPT 7) Running Tests
PROMPT ===============================
@../05_tests/test_run_all.sql

PROMPT ✅ DEPLOYMENT COMPLETE
