USE CUSTOMER_DATABASE;
-- QUESTIONS

-- Q1. Display the name of columns in customer table.
SHOW COLUMNS FROM CUSTOMERS;

-- Q2. Show customers from Delhi.
SELECT * FROM CUSTOMERS WHERE UPPER(CITY)='DELHI';  -- > UPPER change the case from lower to upper

-- Q3. Show customers from Mumbai.
SELECT * FROM CUSTOMERS WHERE LOWER(CITY)='mumbai'; -- > LOWER convers the case to lowercase

-- Q4. Show customers age above 30.
SELECT * FROM CUSTOMERS WHERE AGE>30;

-- Q5. Show orders amount greater than 10000.
SELECT * FROM ORDERS WHERE AMOUNT>30000;

-- Q6. Show customer names starting with A.
SELECT CUSTOMER_NAME FROM CUSTOMERS WHERE CUSTOMER_NAME LIKE 'A%'; -- > LIKE is used to give pattern, A% means the name should start with A.

-- Q7. Show customer names ending with a, make it case sensitive
SELECT CUSTOMER_NAME FROM CUSTOMERS WHERE CUSTOMER_NAME LIKE '%a'; -- > All the results will end with small case 'a'

-- Q8. Show products containing letter 'o'.
SELECT CUSTOMER_NAME FROM CUSTOMERS WHERE CUSTOMER_NAME LIKE '%o%'; -- > Output will have those names which have 'o' anywhere in it.

-- Q9. Show Delhi customers age above 30.
SELECT * FROM CUSTOMERS WHERE UPPER(CITY)='DELHI' AND AGE>30;  -- > MULTIPLE FILTERING

-- Q10. Show Mumbai customers age below 28.
SELECT * FROM CUSTOMERS WHERE UPPER(CITY)='MUMBAI' AND AGE<28; -- > filtering when both the conditions need to be True

-- Q11. Show customers from Delhi OR Pune.
SELECT * FROM CUSTOMERS WHERE UPPER(CITY)='DELHI' OR LOWER(CITY)='pune'; -- > filtering when either of the condition can be true

-- Q12. Show customers NOT from Noida.
SELECT * FROM CUSTOMERS WHERE UPPER(CITY)<>'NOIDA'; -- > '<>' MEANS NOT EQUAL TO

-- Q13. Show customers city IN ('Delhi','Mumbai','Pune').
SELECT * FROM CUSTOMERS WHERE UPPER(CITY) IN ('DELHI','MUMBAI','PUNE'); -- > IN is used when multiple value is in OR for same column

-- Q13. Show orders amount BETWEEN 5000 and 20000.
SELECT * FROM ORDERS WHERE AMOUNT BETWEEN 5000 AND 20000; -- > BETWEEN is used to specify a range, both the values are included in the range

-- Q14. Show orders after March 1, 2024. -- > order_Date format yyyy-mm-dd
SELECT * FROM ORDERS WHERE ORDER_DATE>'2024-03-01';

-- Q15. Show customers not between age 25 and 30
SELECT * FROM CUSTOMERS WHERE AGE NOT BETWEEN 25 AND 30; -- > NOT is used to negate a condition

-- Q16. Show customers whose names do not start with vowels. 
-- ***If we will use LIKE here we will have to give 5 condition to have all the vowels accomodated, so we will use REGEXP meaning regular expression***
SELECT CUSTOMER_NAME FROM CUSTOMERS WHERE CUSTOMER_NAME NOT REGEXP '^[AEIOUaeiou]'; -- ^ start of word, [] -> contains the expression

-- Q17. Show orders excluding laptops and phones.
SELECT * FROM ORDERS WHERE UPPER(PRODUCT_NAME) NOT IN ('LAPTOP','PHONE');

-- Q18. Show customers where city is NULL.
SELECT * FROM CUSTOMERS WHERE CITY IS NULL;

-- Q19. Show customers where city is NOT NULL and age > 28.
SELECT * FROM CUSTOMERS WHERE CITY IS NOT NULL AND AGE>28;

-- Q20. Show expensive orders placed in January only.
SELECT * FROM ORDERS WHERE MONTH(ORDER_DATE)='01';   
-- MONTH(DATE_VAL)- > MONTH FROM DATE, SIMILARLY YEAR() GIVES YEAR AND DAY() GIVE THE DAY NUMBER
