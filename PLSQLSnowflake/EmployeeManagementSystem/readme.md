# Employee Management System using SQL + PL/SQL (Hackathon Project)

## 📌 Project Overview
This project is a **comprehensive Employee Management System** built using **Oracle SQL and PL/SQL**, designed to demonstrate strong fundamentals in:

✅ SQL (DDL + DML + Joins + Subqueries + Analytics)  
✅ PL/SQL (Procedures, Functions, Exception Handling)  
✅ Packages (Reusability + Clean Architecture)  
✅ Triggers (Audit trail + Validation)  
✅ Constraints (Data Integrity)  
✅ Performance Optimization (Indexes)  
✅ Testing & Validation (Seed + Test scripts)  

This system can manage employee records and provide payroll-related calculations like salary updates and bonus calculations along with automated salary audit tracking.

---

## 🎯 Key Features

### 1) Employee Operations (PL/SQL Package)
Using package `EMP_MANAGEMENT`, the system supports:

- **Hire Employee**
  - Inserts employee details into `EMPLOYEES` table
  - Validates salary
  - Validates department existence

- **Update Salary**
  - Updates employee salary
  - Automatically inserts old/new salary into salary audit table using trigger

- **Calculate Bonus**
  - Returns computed bonus = salary × bonus_percent

- **Terminate Employee**
  - Updates employee `STATUS` column to `TERMINATED`

---

### 2) Automated Audit Trail (Triggers)
- Salary update automatically creates record in `SALARY_HISTORY`
- Ensures audit tracking without manual insertion

---

### 3) Validation Triggers
- Prevents future hire date entry
- Enforces business rule inside database

---

### 4) Advanced SQL Reports
Includes powerful HR reports:

- Employees earning above department average
- Salary ranking within department
- Top 3 highest paid employees in each department

---

### 5) Performance Enhancements
Indexes created on frequently filtered/searchable columns:
- Department
- Salary
- Uppercase last name search

---

## 🏗️ Database Objects Used

### Tables
| Table Name        | Purpose |
|------------------|---------|
| `DEPARTMENTS`     | Stores department master data |
| `EMPLOYEES`       | Stores employee details and department mapping |
| `SALARY_HISTORY`  | Stores audit trail of salary changes |

---

### Constraints Implemented
✅ Primary Key  
✅ Foreign Key  
✅ Unique constraint on email  
✅ Check constraint on salary  
✅ Default hire_date with SYSDATE  
✅ Status allowed values check  

These constraints ensure **high data integrity** and prevent invalid input at database level.

---

## 📦 Folder Structure

Employee_Management_PLSQL_Project/
│
├── 00_docs/
│ ├── scope.md
│ ├── business_rules.md
│ ├── assumptions.md
│ ├── test_plan.md
│ └── README.md
│
├── 01_schema/
│ ├── 01_tables/
│ │ ├── tbl_departments.sql
│ │ ├── tbl_employees.sql
│ │ └── tbl_salary_history.sql
│ │
│ ├── 02_sequences/
│ │ └── seq_salary_history.sql
│ │
│ └── 03_indexes/
│ ├── idx_emp_dept.sql
│ ├── idx_emp_salary.sql
│ └── idx_emp_lastname_upper.sql
│
├── 02_programs/
│ └── 01_packages/
│ ├── pkg_emp_management_spec.sql
│ └── pkg_emp_management_body.sql
│
├── 03_triggers/
│ ├── trg_emp_salary_audit.sql
│ └── trg_emp_hire_date_check.sql
│
├── 04_queries/
│ ├── q_employees_above_dept_avg.sql
│ ├── q_rank_salary_within_dept.sql
│ └── q_top3_salary_each_dept.sql
│
├── 05_tests/
│ ├── seed_departments.sql
│ ├── seed_employees.sql
│ ├── seed_salary_updates.sql
│ ├── test_run_all.sql
│ └── expected_output.md
│
├── 06_deploy/
│ ├── run_all.sql
│ └── drop_all.sql
│
└── README.md



---

## 📌 Business Rules Implemented

### Employee Hiring Rules
✅ Employee salary must be **greater than 0**  
✅ Employee department must exist  
✅ Hire date cannot be in the future  
✅ Email must be unique  

---

### Salary Update Rules
✅ Salary must be valid (>0)  
✅ Every salary update is recorded automatically in `SALARY_HISTORY`

---

### Termination Rules
✅ Termination does not delete employee record  
✅ Updates `STATUS = 'TERMINATED'` for history retention (best industry practice)

---

## 🔧 Technologies Used
- Oracle SQL
- Oracle PL/SQL
- Oracle Triggers
- Oracle Packages
- Index optimization

Recommended tools:
- Oracle SQL Developer (best)
- SQL*Plus (script-based)
- Oracle Live SQL (online tool)

---

## 🚀 How to Run the Project (Step-by-step)

### ✅ Step 1: Run Schema Scripts
Execute in this order:

1. `01_schema/01_tables/tbl_departments.sql`
2. `01_schema/01_tables/tbl_employees.sql`
3. `01_schema/01_tables/tbl_salary_history.sql`

---

### ✅ Step 2: Run Sequence
4. `01_schema/02_sequences/seq_salary_history.sql`

---

### ✅ Step 3: Compile Package
5. `02_programs/01_packages/pkg_emp_management_spec.sql`  
6. `02_programs/01_packages/pkg_emp_management_body.sql`

---

### ✅ Step 4: Compile Triggers
7. `03_triggers/trg_emp_salary_audit.sql`  
8. `03_triggers/trg_emp_hire_date_check.sql`

---

### ✅ Step 5: Performance Indexes
9. `01_schema/03_indexes/idx_emp_dept.sql`
10. `01_schema/03_indexes/idx_emp_salary.sql`
11. `01_schema/03_indexes/idx_emp_lastname_upper.sql`

---

### ✅ Step 6: Seed Data
12. `05_tests/seed_departments.sql`
13. `05_tests/seed_employees.sql`
14. `05_tests/seed_salary_updates.sql`

---

### ✅ Step 7: Run Full Test Script
15. `05_tests/test_run_all.sql`

---

## ✅ Sample Outputs to Validate

### Check Employees
```sql
SELECT * FROM employees ORDER BY employee_id;


## Check Salary History (Trigger result)
SELECT * FROM salary_history ORDER BY change_date DESC;

## Check Employee Status after Termination
SELECT employee_id, first_name, last_name, status
FROM employees
WHERE employee_id = 401;

---

# 🧪 Testing Coverage

This project includes test scripts to validate:
✅ Hiring employee
✅ Salary updates
✅ Bonus calculation
✅ Trigger audit insertion
✅ Department-level reporting
✅ Termination operation

Test files:

seed_departments.sql
seed_employees.sql
seed_salary_updates.sql
test_run_all.sql

# ⚡ Performance Notes
Indexes added based on frequent query patterns:
Filtering by department
Salary-based reports
Name search with case-insensitivity
Example:
SELECT * FROM employees WHERE UPPER(last_name) = 'SONI';

* This query uses function-based index: idx_emp_name.

---

# 🏆 (What Makes This Project Strong)

✅ Uses complete DB architecture: SQL + PL/SQL + triggers + packages
✅ Enforces business rules at database layer (real-world)
✅ Automated audit tracking (salary history)
✅ Advanced SQL reports included
✅ Clean folder structure and deployable scripts
✅ Strong testing plan + dataset included

---

# 🌱 Future Enhancements (Optional)

These can be added later to extend project:
Leave management
Attendance tracking
Role based access control (RBAC)
More audit logs for INSERT/DELETE
REST API integration (Oracle ORDS)

---

# 👨‍💻 Author

Akhil Soni
Project – Employee Management System (Oracle SQL/PLSQL)


---

If you want, I can also create:
✅ `06_deploy/run_all.sql` (one-click full run script)  
✅ `06_deploy/drop_all.sql` (cleanup script)
