-- We will practice Basic SQL Core in this part

USE CUSTOMER_DATABASE; -- use costomer_database
-- Follow the questions one by one

-- Q1. Show all rows from customer
SELECT * FROM CUSTOMERS;

-- Q2. Show all rows from orders
SELECT * FROM ORDERS;

-- Q3. Show customer_name and city from customers
SELECT CUSTOMER_NAME,CITY FROM CUSTOMERS;

-- Q4. Show product_name and amount from orders
SELECT PRODUCT_NAME, AMOUNT FROM ORDERS;

-- Q5. Rename customer_name as name.
SELECT CUSTOMER_NAME AS NAME FROM CUSTOMERS; -- AS KEYWORD CREATES THE ALIAS FOR THE COLUMN

-- Q6. Rename amount as total_amount.
SELECT AMOUNT AS TOTAL_AMOUNT FROM ORDERS;

-- Q7. Show unique cities from customers. 
SELECT DISTINCT(CITY) FROM CUSTOMERS; -- DISTINCT GIVE UNIQUE RECORDS

-- Q8. Show unique product names from orders.
SELECT DISTINCT(PRODUCT_NAME) FROM ORDERS;

-- Q9. Sort customers by age ascending.
SELECT * FROM CUSTOMERS ORDER BY AGE;  -- ORDER BY IS USED TO SORT THE ROWS BASED ON ORDER BY COLUMN NAME, BY DEFAULT ORDER BY HAS ASCENDING SORT

-- Q10. Sort customers by age descending.
SELECT * FROM CUSTOMERS ORDER BY AGE DESC;

-- Q11. Sort orders by amount descending.
SELECT * FROM ORDERS ORDER BY AMOUNT DESC;

-- Q12. Show first 5 customers.
SELECT * FROM CUSTOMERS LIMIT 5;

-- Q13. Show first 10 orders.
SELECT * FROM ORDERS LIMIT 10;

-- Q14. Show top 3 highest order amounts.
SELECT AMOUNT FROM ORDERS ORDER BY AMOUNT DESC LIMIT 3;  -- ORDER BY WITH LIMIT GIVE n NUMBER OF SORTED RECS

-- Q15. Show customer names alphabetically and city reverse alphabetically.
SELECT * FROM CUSTOMERS ORDER BY CUSTOMER_NAME ASC, CITY DESC;  -- MULTIPLE COLUMN ORDER BY 

-- Q16. Show latest 7 orders.
SELECT * FROM ORDERS ORDER BY ORDER_DATE DESC LIMIT 7;

-- Q17. Show oldest 5 signed-up customers.
SELECT CUSTOMER_NAME FROM CUSTOMERS ORDER BY SIGNUP_DATE LIMIT 5; -- SINCE EACH OF THE CUSTOMER IS UNIQUE IN THE TABLE, SO WE HAVEN'T USED DISTINCT

-- Q18. Show distinct city count with aliases.
SELECT COUNT(DISTINCT(CITY)) AS UNIQUE_CITY FROM CUSTOMERS; -- WE CAN USE FUNCTION CALLING ANOTHER FUNCTION ON A COLUMN

-- Q19. Show customers ordered by signup year and age.
SELECT * FROM CUSTOMERS ORDER BY SIGNUP_DATE,AGE;

-- Q20. Show top 10 customers ordered by name length
SELECT CUSTOMER_NAME FROM CUSTOMERS ORDER BY length(CUSTOMER_NAME) DESC LIMIT 10; 
-- IT WILL SORT IN THE ORDER OF DESCENDING NAME LENGTH AND THEN ALPHABETICALLY IS THE NAMES ARE OF SAME LENGTH