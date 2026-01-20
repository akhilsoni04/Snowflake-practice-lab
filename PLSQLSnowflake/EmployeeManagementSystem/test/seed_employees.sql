SET SERVEROUTPUT ON;

BEGIN
  -- IT Department (10)
  emp_management.hire_employee(101, 'John',   'Doe',     'john.doe@gmail.com',     50000, 10);
  emp_management.hire_employee(102, 'Akhil',  'Soni',    'akhil.soni@gmail.com',   75000, 10);
  emp_management.hire_employee(103, 'Ravi',   'Patel',   'ravi.patel@gmail.com',   60000, 10);

  -- HR Department (20)
  emp_management.hire_employee(201, 'Neha',   'Sharma',  'neha.sharma@gmail.com',  45000, 20);
  emp_management.hire_employee(202, 'Pooja',  'Verma',   'pooja.verma@gmail.com',  55000, 20);

  -- FINANCE Department (30)
  emp_management.hire_employee(301, 'Rahul',  'Mehta',   'rahul.mehta@gmail.com',  80000, 30);
  emp_management.hire_employee(302, 'Simran', 'Kaur',    'simran.kaur@gmail.com',  65000, 30);

  -- SALES Department (40)
  emp_management.hire_employee(401, 'Aman',   'Singh',   'aman.singh@gmail.com',   40000, 40);
  emp_management.hire_employee(402, 'Isha',   'Jain',    'isha.jain@gmail.com',    90000, 40);

  DBMS_OUTPUT.PUT_LINE('✅ Seed employees inserted successfully.');
END;
/
