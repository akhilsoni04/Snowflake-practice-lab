# Employees Management System 
Major Portions / Phases of Building Any Project:

a) Problem Understanding
    Read problem statement carefully
    Identify inputs, outputs, constraints
    Clarify assumptions and edge cases
    Understand evaluation / success criteria

b) Planning of Scope
    Define MVP (Must-have) features
    List Optional / Bonus features
    Decide time allocation per module
    Freeze scope to avoid feature creep

c) Requirement Analysis
    Functional requirements (what system should do)
    Non-functional requirements (performance, security, scalability)
    Identify business rules and validations

d) System Design / Architecture
    Choose modules and workflow
    Decide database layers (OLTP / Analytics)
    Define how components interact

e) Database Design (ERD + Schema)
    Tables, attributes, relationships
    Primary key / foreign key design
    Constraints and normalization

f) Implementation (Development Phase)
    Create schema (DDL scripts)
    Insert sample data (DML scripts)
    Implement logic (procedures/functions/triggers)
    Implement error handling and validations

g) Testing & Validation
    Test each module independently
    Test edge cases and invalid inputs
    Verify output correctness
    Performance testing where needed

h) Reporting / Analytics
    Prepare required reports and dashboards
    Query optimization (window functions, CTEs, clustering)
    Ensure business insights are accurate

i) Documentation
    README (setup steps + usage)
    Project flow explanation
    Folder structure + scripts guide
    Sample outputs / screenshots

j) Deployment / Submission
    Push clean code to GitHub
    Final run demonstration
    Deliverable checklist verification


# Test Plan – Employee Management System (PL/SQL)

## Goal
Validate all operations and ensure business rules + triggers work correctly.

## Test Cases
1. Insert departments using seed script
2. Hire employees using emp_management.hire_employee
3. Update salary using emp_management.update_salary
4. Verify trigger inserts into salary_history
5. Calculate bonus using emp_management.calculate_bonus
6. Terminate employee using emp_management.terminate_employee
7. Run reporting queries (avg salary, ranking)

## Expected Result
- All procedures run without errors
- salary_history captures updates
- invalid inputs are blocked with custom errors



# AKhil's POV FROM HERE
FOLDER structure 

Employee_Management_PLSQL_Project/
│
├── 00_docs/
│   ├── scope.md
│   ├── business_rules.md
│   ├── assumptions.md
│   ├── test_plan.md
│   └── README.md
│
├── 01_schema/
│   ├── 01_tables/
│   │   ├── tbl_departments.sql
│   │   ├── tbl_employees.sql          -- includes STATUS column
│   │   └── tbl_salary_history.sql
│   │
│   ├── 02_sequences/
│   │   └── seq_salary_history.sql
│   │
│   └── 03_indexes/
│       ├── idx_emp_dept.sql
│       ├── idx_emp_salary.sql
│       └── idx_emp_lastname_upper.sql
│
├── 02_programs/
│   └── 01_packages/
│       ├── pkg_emp_management_spec.sql
│       └── pkg_emp_management_body.sql
│
├── 03_triggers/
│   ├── trg_emp_salary_audit.sql
│   └── trg_emp_hire_date_check.sql
│
├── 04_queries/
│   ├── q_employees_above_dept_avg.sql
│   ├── q_rank_salary_within_dept.sql
│   └── q_top3_salary_each_dept.sql
│
├── 05_tests/
│   ├── seed_departments.sql
│   ├── seed_employees.sql
│   ├── seed_salary_updates.sql
│   ├── test_run_all.sql
│   └── expected_output.md
│
├── 06_deploy/
│   ├── run_all.sql
│   └── drop_all.sql
│
└── README.md
