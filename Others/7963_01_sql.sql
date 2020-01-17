# Module - 1
# Basic Statements

#1
CREATE DATABASE IF NOT EXISTS training;
USE training;

#2
CREATE TABLE demography (
    CustID INT AUTO_INCREMENT,
    Name VARCHAR(50),
    Age INT,
    Gender VARCHAR(1),
PRIMARY KEY (CustID)
);

#3
INSERT INTO demography
	(Name,Age,Gender) 
values
	('John',25,'M');

#4
INSERT INTO demography
	(Name,Age,Gender)
values
	('Pawan',26,'M'),
	('Hema',31,'F');

#5
INSERT INTO demography
	(Name,Gender)
values
	('Rekha','F');

#6
SELECT 
    *
FROM
    demography;

#7
UPDATE demography 
SET 
    Age = NULL
WHERE
    Name = 'John';

#8
SELECT 
    *
FROM
    demography
WHERE
    Age IS NULL;

#9
TRUNCATE demography;

#10
DROP TABLE demography;

# Module - 2
# WHERE Clause

#1
SELECT 
    account_id, cust_id, avail_balance
FROM
    account
WHERE
    status = 'ACTIVE'
        AND avail_balance > 2500;

#2
SELECT 
    *
FROM
    account
WHERE
    open_date BETWEEN '2000-01-01' AND '2000-12-31';
SELECT 
    *
FROM
    account
WHERE
    open_date LIKE '2000%';

#3
SELECT 
    account_id, avail_balance, pending_balance
FROM
    account
WHERE
    avail_balance != pending_balance;

#4
SELECT 
    account_id, product_cd
FROM
    account
WHERE
    account_id IN (1 , 10, 23, 27);
    
#5
SELECT 
    account_id, avail_balance
FROM
    account
WHERE
    avail_balance BETWEEN 100 AND 200;
    
# Module - 3
# Operators and Functions

#1
SELECT 
    COUNT(*) AS no_of_rows
FROM
    account;

#2
SELECT 
    *
FROM
    account
LIMIT 2;

#3
SELECT 
    *
FROM
    account
LIMIT 2 , 2;

#4
SELECT 
    YEAR(birth_date) AS Year,
    MONTH(birth_date) AS Month,
    DAY(birth_date) AS Day,
    WEEKDAY(birth_date) AS Weekday
FROM
    individual;

#5    
SELECT 
    SUBSTRING('Please find the substring in this string',17,9) AS Substring;

#6
SELECT SIGN(25.76823) AS Sign;
SELECT ROUND(25.76823) AS Round;

#7
SELECT DATE_ADD(CURDATE(), INTERVAL 30 DAY);

#8
SELECT 
    LEFT(fname, 3) AS first_three, RIGHT(lname, 3) AS last_three
FROM
    individual;

#9
SELECT 
    UPPER(fname) AS fname
FROM
    individual
WHERE
    LENGTH(fname) = 5;

#10    
SELECT 
    MAX(avail_balance) AS Maximum, AVG(avail_balance) AS Average
FROM
    account
WHERE
    cust_id = 1;

# Module - 4
# Group by

#1
SELECT 
    cust_id, COUNT(account_id) AS account_count
FROM
    account
GROUP BY cust_id;

#2
SELECT 
    cust_id, COUNT(account_id) AS account_count
FROM
    account
GROUP BY cust_id
HAVING account_count > 2;

#3
SELECT 
    fname, birth_date
FROM
    individual
ORDER BY birth_date DESC;

#4
SELECT 
    YEAR(open_date) AS Year, AVG(avail_balance) AS Average
FROM
    account
GROUP BY Year
HAVING Average > 200
ORDER BY Year;

#5
SELECT 
    product_cd, MAX(pending_balance) AS Maximum
FROM
    account
WHERE
    product_cd IN ('CHK' , 'SAV', 'CD')
GROUP BY product_cd;


# Module - 5
# Joins and Sub query

#1
SELECT 
    e.fname, e.title, d.name
FROM
    employee e
        JOIN
    department d ON e.dept_id = d.dept_id;

#2
SELECT 
    pt.name AS Produt_type_name, p.name AS Product_name
FROM
    product_type pt
        LEFT JOIN
    product p ON pt.product_type_cd = p.product_type_cd;

#3
SELECT 
    CONCAT(e.fname, ' ', e.lname) AS Employee_name,
    CONCAT(s.fname, ' ', s.lname) AS Superior_name
FROM
    employee e
        JOIN
    employee s ON e.superior_emp_id = s.emp_id;

#4
SELECT 
    fname, lname
FROM
    employee
WHERE
    superior_emp_id = (SELECT 
            emp_id
        FROM
            employee
        WHERE
            fname = 'Susan' AND lname = 'Hawthorne');

#5
SELECT 
    fname, lname
FROM
    employee
WHERE
    emp_id IN (SELECT 
            superior_emp_id
        FROM
            employee
        WHERE
            dept_id = 1);
