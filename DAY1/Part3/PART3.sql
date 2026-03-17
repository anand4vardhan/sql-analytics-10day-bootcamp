USE CUSTOMER_DATABASE;

-- Q . Count total customers.
SELECT COUNT(DISTINCT(CUSTOMER_NAME)) FROM CUSTOMERS; -- > COUNT ON DISTINCT GIVES THE COUNT OF UNIQUES CUSTOMER_NAME

-- Q . Count total orders.
SELECT COUNT(*) FROM ORDERS; -- > NO NEED TO USE DISTINCT AS EACH ROW IS ANOTHER ORDER
 
-- Q . Sum total revenue.
SELECT SUM(AMOUNT) AS TOTAL_REVENUE FROM ORDERS;

-- Q . Average customer age.
SELECT AVG(AGE) AS AVERAGE_AGE FROM CUSTOMERS;

-- Q . Minimum age.
SELECT MIN(AGE) AS MINIMUM_AGE FROM CUSTOMERS;

-- Q . Maximum age.
SELECT MAX(AGE) AS MAXIMUM_AGE FROM CUSTOMERS;

-- Q . Minimum order amount.
SELECT MIN(AMOUNT) FROM ORDERS;

-- Q . Maximum order amount.
SELECT MAX(AMOUNT) FROM ORDERS;

-- Q . Count distinct cities.
SELECT COUNT(DISTINCT(CITY)) AS UNIQUE_CITY FROM CUSTOMERS;

-- Q . Count distinct products.
SELECT COUNT(DISTINCT(PRODUCT_NAME)) FROM ORDERS;

-- Q . Sum all laptop sales.
SELECT SUM(AMOUNT) FROM ORDERS WHERE UPPER(PRODUCT_NAME)='LAPTOP';

-- Q . Average phone order value.
SELECT AVG(AMOUNT) AS AVG_PHONE_AMOUNT FROM ORDERS WHERE UPPER(PRODUCT_NAME)='PHONE';

-- Q . Count orders above 10000.
SELECT COUNT(*) FROM ORDERS WHERE AMOUNT>10000;

-- Q . Sum orders above 20000.
SELECT SUM(AMOUNT) AS TOTOL_REV_OVER_20K FROM ORDERS WHERE AMOUNT>20000;

-- Q . Average amount excluding laptops.
SELECT AVG(AMOUNT) AS AVG_AMOUNT_EXCEPT_LAPTOP FROM ORDERS WHERE UPPER(PRODUCT_NAME)<>'LAPTOP';

-- Q . Count customers age above average age.
SELECT COUNT(AGE) FROM CUSTOMERS WHERE AGE>(SELECT AVG(AGE) FROM CUSTOMERS);
-- We are using subquery- it is basically another SQL query that can fetch us the matching criteria or VALUES

-- Q . Sum top 10 highest orders.
SELECT SUM(AMOUNT) FROM ORDERS ORDER BY AMOUNT DESC LIMIT 10;  -- It will first sort the amount in descending order and create a table with first 10 rows after sort

-- Q . Find difference between max and min amount.
SELECT MAX(AMOUNT)-MIN(AMOUNT) AS MIN_MAX_AMOUNT_DIFF FROM ORDERS; -- We can perform arithmatic operations in a sql query

-- Q . Count customers signed up after average signup date.
SELECT COUNT(*) FROM CUSTOMERS WHERE SIGNUP_DATE >(SELECT AVG(SIGNUP_DATE) FROM CUSTOMERS);

-- Q . Find median-like midpoint using aggregate logic.
-- For median, we need to find middle row number after sorting, since our customers table has 100 data points, so median will be the average of two values.
-- Best way is to use Common Table Expression along with window function ROWNUMBER
-- Let's work the hard way by not using the CTE or WINDOWS FUNCTIONS
SET @RN = 0;
SELECT AVG(age) AS median_age
FROM (
    SELECT age, @RN := @RN + 1 AS rn
    FROM customers, (SELECT @RN := 0) r
    ORDER BY age
) x
WHERE rn IN (
    (SELECT (COUNT(*) + 1) DIV 2 FROM customers),
    (SELECT (COUNT(*) + 2) DIV 2 FROM customers)
);

-- in the above, we are first creating a row number as per sorted age value.
-- then from this query we are selecting avg of age after applying condition on RN
-- SELECT of SELECT works like- inner select creates a temporary table for outer select, we will use this more in advanced queries.