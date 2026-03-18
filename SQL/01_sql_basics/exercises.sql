SELECT * 
FROM parks_and_recreation.employee_demographics;

SELECT first_name,
last_name,
birth_date,
age,
(age + 10) * 10 + 10
FROM parks_and_recreation.employee_demographics;
# PEMDAS

SELECT DISTINCT first_name,gender
FROM parks_and_recreation.employee_demographics;

SELECT * 
FROM employee_salary
WHERE first_name = 'Leslie'
;

SELECT * 
FROM employee_salary
WHERE salary <= 50000
;

SELECT * 
FROM employee_demographics
WHERE gender != 'Female'
;

SELECT * 
FROM employee_demographics
WHERE birth_date > '1985-01-01'
;
-- AND OR NOT -- Logical Operators

SELECT * 
FROM employee_demographics
WHERE birth_date > '1985-01-01'
AND gender = 'Male'
;
SELECT * 
FROM employee_demographics
WHERE birth_date > '1985-01-01'
OR NOT gender = 'Male'
;

SELECT * 
FROM employee_demographics
WHERE (first_name = 'Leslie' AND age = 44) OR age > 55
;

-- LIKE Statement 
-- % and _
SELECT * 
FROM employee_demographics
WHERE first_name LIKE 'Jer%'
;
SELECT * 
FROM employee_demographics
WHERE first_name LIKE '%a%'
;
SELECT * 
FROM employee_demographics
WHERE first_name LIKE 'a___%'
;
SELECT * 
FROM employee_demographics
WHERE birth_date LIKE '1989%'
;

-- Group by
SELECT * 
FROM employee_demographics
;
SELECT gender
FROM employee_demographics
GROUP BY gender
;
SELECT first_name             # doesnt work bc select ... and group by ... have to match like ^ with gender - gender (or when using AVG it will work)
FROM employee_demographics
GROUP BY gender
;
SELECT gender, AVG (age) #means average
FROM employee_demographics
GROUP BY gender
;
SELECT occupation
FROM employee_salary
GROUP BY occupation
;
SELECT occupation, salary
FROM employee_salary
GROUP BY occupation, salary
;
SELECT gender, AVG(age), MAX(age), MIN(age), COUNT(age)
FROM employee_demographics
GROUP BY gender
;

-- ORDER BY
SELECT *
FROM employee_demographics
ORDER BY first_name        #smallest to largest ( a-z )
;
SELECT *
FROM employee_demographics
ORDER BY first_name ASC       #ascending order
;
SELECT *
FROM employee_demographics
ORDER BY first_name DESC       #descending order
;
SELECT *
FROM employee_demographics
ORDER BY gender, age DESC
;                           # ^ exact same bc: gender position is 5th- and age position is 4th-position
SELECT *
FROM employee_demographics
ORDER BY 5, 4 DESC
;

-- Having vs Where
SELECT gender, AVG(age)
FROM employee_demographics  # ERROR CODE: invalid use of function
WHERE AVG(age) > 40
GROUP BY gender
;
SELECT gender, AVG(age)
FROM employee_demographics 
GROUP BY gender             # NOW works
HAVING AVG(age) > 40
;

SELECT occupation, AVG(salary)
FROM employee_salary
WHERE occupation LIKE '%manager%'
GROUP BY occupation
HAVING AVG(salary) > 75000
;

-- Limit

SELECT *
FROM employee_demographics
ORDER BY age DESC
LIMIT 2, 1      # means: its gonna start at position 2 and its gonna go 1 row after it
;
-- Aliasing (to change the name of the column)
SELECT gender, AVG(age) AS avg_age
FROM employee_demographics
GROUP BY gender
HAVING AVG(age) > 40
;                                     # it actually implies the 'AS' so it works without it 
SELECT gender, AVG(age)avg_age
FROM employee_demographics
GROUP BY gender
HAVING AVG(age) > 40
;

-- Joins
SELECT *
FROM employee_demographics;
SELECT *
FROM employee_salary;

SELECT *
FROM employee_demographics
INNER JOIN employee_salary
  ON employee_demographics.employee_id = employee_salary.employee_id
;                                         # the same just shorter by using aliasing:
SELECT *
FROM employee_demographics AS dem
INNER JOIN employee_salary AS sal
  ON dem.employee_id = sal.employee_id
;
   # now one step further:
SELECT dem.employee_id, age, occupation
FROM employee_demographics AS dem
INNER JOIN employee_salary AS sal
  ON dem.employee_id = sal.employee_id
;

-- Outer Joins (LEFT AND RIGHT JOINS)
SELECT dem.employee_id, age, occupation 
FROM employee_demographics AS dem       # actually Left Table
LEFT JOIN employee_salary AS sal        # and Right Table
  ON dem.employee_id = sal.employee_id
;
SELECT dem.employee_id, age, occupation 
FROM employee_demographics dem      
RIGHT JOIN employee_salary sal       
  ON dem.employee_id = sal.employee_id
;

-- Self Join 
SELECT *
FROM employee_salary emp1
JOIN employee_salary emp2
  ON emp1.employee_id + 1 = emp2.employee_id
;   

SELECT 
emp1.employee_id AS emp_santa, 
emp1.first_name AS first_name_santa, 
emp1.last_name AS last_name_santa,
emp2.employee_id AS emp_name, 
emp2.first_name AS first_name_emp, 
emp2.last_name AS last_name_emp
FROM employee_salary emp1
JOIN employee_salary emp2
  ON emp1.employee_id + 1 = emp2.employee_id
;

-- Joining multiple table together
SELECT *
FROM employee_demographics AS dem       
LEFT JOIN employee_salary AS sal        
  ON dem.employee_id = sal.employee_id
INNER JOIN parks_departments pd
  ON sal.dept_id = pd.department_id
  ;
SELECT *
FROM parks_departments  
;

-- Union
SELECT first_name, last_name
FROM employee_demographics
UNION ALL                         # ist UNION DISTICT --> by default.  ALL means: all even duplicates
SELECT first_name, last_name
FROM employee_salary
;

SELECT first_name, last_name, 'Old Man' AS Label
FROM employee_demographics
WHERE age > 40 AND gender = 'Male'
UNION 
SELECT first_name, last_name, 'Old Lady' AS Label
FROM employee_demographics
WHERE age > 40 AND gender = 'Female'
UNION
SELECT first_name, last_name, 'Highly Paid Employee' AS Label
FROM employee_salary
WHERE salary > 70000
ORDER BY first_name, last_name
;

-- String functions

SELECT LENGTH('skyfall')
;
SELECT first_name, LENGTH(first_name)
FROM employee_demographics
ORDER BY 2
;
SELECT UPPER('Sky')
;
SELECT LOWER('Sky')
;
SELECT first_name, UPPER(first_name)
FROM employee_demographics
;
SELECT ('   sky  ');
SELECT TRIM ('   sky  ');
SELECT LTRIM ('   sky  ');
SELECT RTRIM ('   sky  ');

SELECT first_name, 
LEFT(first_name, 4),
RIGHT(first_name, 4),
SUBSTRING(first_name, 3, 2),
birth_date,
SUBSTRING(birth_date, 6, 2) AS birth_month
FROM employee_demographics
;

SELECT first_name, REPLACE(first_name, 'a', 'z')
FROM employee_demographics
;
SELECT LOCATE('v','Selvinaz');

SELECT first_name, LOCATE('An',first_name)
FROM employee_demographics
;
SELECT first_name, last_name,
CONCAT(first_name,' ',last_name) AS full_name
FROM employee_demographics
;

-- Case Statements

SELECT first_name, last_name age,
CASE
    WHEN age <= 30 THEN 'Young'
    WHEN age BETWEEN 31 and 50 THEN 'Old'
	WHEN age >= 50 THEN 'On Deaths Door'
END AS Age_Bracket
FROM employee_demographics;

-- Pay Increase and Bonus 
-- < 50000 = 5%
-- > 50000 = 7%
-- Finance = 10% bonus 
SELECT first_name, last_name, salary,
CASE
	WHEN salary < 50000 THEN salary * 1.05
	WHEN salary > 50000 THEN salary * 1.07
END AS New_Salary,
CASE
	WHEN dept_id = 6 THEN salary * .10
END AS Bonus
FROM employee_salary;

-- Subquerie

SELECT *
FROM employee_demographics
WHERE employee_id IN 
(SELECT employee_id 
FROM employee_salary
WHERE dept_id = 1)
;

SELECT first_name, salary,
(SELECT AVG(salary)
FROM employee_salary)
FROM employee_salary
;

SELECT gender, AVG(age), MAX(age), MIN(age), COUNT(age)
FROM employee_demographics
GROUP BY gender
;

SELECT AVG(max_age), AVG(min_age)
FROM 
(SELECT gender,
 AVG(age) AS avg_age, 
 MAX(age) AS max_age,
 MIN(age) AS min_age, 
 COUNT(age)
FROM employee_demographics
GROUP BY gender)
AS Agg_table
;

-- Window Functions

#Group by
SELECT dem.first_name, dem.last_name, gender, AVG(salary) AS avg_salary
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY dem.first_name, dem.last_name, gender;

# NOW in comparison den Window Function
SELECT dem.first_name, dem.last_name, gender, AVG(salary) OVER(PARTITION BY gender)
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;
    
SELECT dem.first_name, dem.last_name, gender, salary, 
SUM(salary) OVER(PARTITION BY gender ORDER BY dem.employee_id) AS Rolling_total
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;
    
SELECT dem.employee_id, dem.first_name, dem.last_name, gender, salary, 
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC) AS row_num,
RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS rank_num,
DENSE_RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS dense_rank_num
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;
    
-- CTE´s 
    



