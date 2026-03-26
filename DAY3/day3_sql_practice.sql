USE DAY3;
-- WE WILL EXPLORE FIRST GET THE NAME OF COLUMNS IN OUR TABLE IN DAY3
SELECT GROUP_CONCAT(COLUMN_NAME) FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA='DAY3' AND TABLE_NAME='CUSTOMERS'; -- CITY,CUSTOMER_ID,CUSTOMER_NAME,SIGNUP_DATE
SELECT GROUP_CONCAT(COLUMN_NAME) FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA='DAY3' AND TABLE_NAME='ORDERS'; -- AMOUNT,CUSTOMER_ID,ORDER_DATE,ORDER_ID

-- DAY3 QUESTIONS***************************

-- Q1. Assign a unique sequential number to each order in the dataset.
SELECT *,ROW_NUMBER() OVER (ORDER BY ORDER_ID) AS RN FROM ORDERS;

-- Q2. For each customer, assign a sequence number to their orders based on order date.
SELECT *, ROW_NUMBER() OVER (PARTITION BY CUSTOMER_ID ORDER BY ORDER_DATE ASC) AS CUSTOMER_ORDER_SEQ FROM ORDERS;

-- Q3. Display orders such that the most recent order of each customer appears first with a sequence number.
SELECT *, ROW_NUMBER() OVER (PARTITION BY CUSTOMER_ID ORDER BY ORDER_DATE DESC) AS CUSTOMER_ORDER_SEQ FROM ORDERS;

-- Q4. Rank all orders based on amount, ensuring that ties result in gaps in ranking. --> SINCE WE NEED GAP AS A RESULT OF TIES IN RANKING, WE NEED TO USE RANK()
SELECT * ,RANK() OVER(ORDER BY AMOUNT DESC) AS RANK_BY_AMOUNT FROM ORDERS;

-- Just to check those values where we have ties- we can construct a table that will have rank_by_amount, and can use it to see where count>1
SELECT * FROM 
(
	SELECT * ,RANK() OVER(ORDER BY AMOUNT DESC) AS RANK_BY_AMOUNT FROM ORDERS
) O1 WHERE O1.RANK_BY_AMOUNT IN 
(
	SELECT RANK_BY_AMOUNT FROM 
	(
		SELECT * ,RANK() OVER(ORDER BY AMOUNT DESC) AS RANK_BY_AMOUNT FROM ORDERS
	) X
    GROUP BY RANK_BY_AMOUNT
    HAVING COUNT(*)>1
);

-- Q5. Rank orders for each customer based on amount without skipping rank numbers for ties.
SELECT * ,DENSE_RANK() OVER(ORDER BY AMOUNT DESC) AS RANK_BY_AMOUNT FROM ORDERS;

-- Q6. Identify the top 3 highest value orders in the entire dataset.
SELECT * FROM
(
	SELECT *,ROW_NUMBER() OVER(ORDER BY AMOUNT DESC) AS RN FROM ORDERS
) T WHERE T.RN<=3;

-- Q7. Identify the top 3 highest value orders for each customer.
SELECT * FROM
(
	SELECT *,ROW_NUMBER() OVER(PARTITION BY CUSTOMER_ID ORDER BY AMOUNT DESC) AS RN FROM ORDERS
) T WHERE T.RN<=3;

-- Q8. Detect duplicate records in the orders table and assign a sequence to each duplicate group.
SELECT * FROM
(
	SELECT *,ROW_NUMBER() OVER(PARTITION BY CUSTOMER_ID ORDER BY AMOUNT DESC) AS RN FROM ORDERS
) T WHERE T.RN>1;

-- Q9. Assign a sequence to orders sorted by date and identify the exact position of each order in timeline.
SELECT *,ROW_NUMBER() OVER(ORDER BY ORDER_DATE DESC) AS DESC_ROW_ORDER_DATE_SEQ FROM ORDERS;

-- Q10. For each order, display the amount of the immediately previous order in the dataset.
SELECT ORDER_ID,ORDER_DATE,AMOUNT AS CURRENT_AMOUNT,LAG(AMOUNT) OVER(ORDER BY ORDER_DATE) AS PREVIOUS_ORDER_AMOUNT FROM ORDERS;

-- Q11. For each customer, show the amount of their previous order.
SELECT CUSTOMER_ID,ORDER_DATE,AMOUNT AS CURRENT_AMOUNT, LAG(AMOUNT) OVER(PARTITION BY CUSTOMER_ID ORDER BY ORDER_DATE) AS PREV_ORDER_AMOUNT_PER_CUSTOMER FROM ORDERS;

-- Q12. For each order, display the amount of the next order placed by the same customer.
SELECT CUSTOMER_ID,ORDER_DATE,AMOUNT AS CURRENT_AMOUNT, LEAD(AMOUNT) OVER(PARTITION BY CUSTOMER_ID ORDER BY ORDER_DATE) AS NEXT_ORDER_AMOUNT_PER_CUSTOMER FROM ORDERS;

-- Q13. Calculate the difference between the current order amount and the previous order amount for each customer.
SELECT CUSTOMER_ID,ORDER_DATE,AMOUNT AS CURRENT_AMOUNT,
AMOUNT-LAG(AMOUNT) OVER(PARTITION BY CUSTOMER_ID ORDER BY ORDER_DATE) AS CURRENT_TO_PREV_ORDER_AMOUNT_PER_CUSTOMER_DIFFERENCE FROM ORDERS;

-- Q14. Identify the first order placed by each customer.
SELECT * FROM
(
	SELECT *,ROW_NUMBER() OVER(PARTITION BY CUSTOMER_ID ORDER BY ORDER_DATE) AS RN FROM ORDERS
) X WHERE X.RN=1;

-- Q15. Identify the most recent (last) order placed by each customer.
SELECT * FROM
(
	SELECT *,ROW_NUMBER() OVER(PARTITION BY CUSTOMER_ID ORDER BY ORDER_DATE DESC) AS RN FROM ORDERS
) X WHERE X.RN=1;

-- Q16. Calculate a running total of order amounts across the entire dataset ordered by date.
SELECT ORDER_ID,ORDER_DATE,AMOUNT,SUM(AMOUNT) OVER(ORDER BY ORDER_DATE) AS RUNNING_TOTAL FROM ORDERS;

-- Q17. Calculate a running total of order amounts separately for each customer.
SELECT CUSTOMER_ID,ORDER_ID,ORDER_DATE,AMOUNT,SUM(AMOUNT) OVER(PARTITION BY CUSTOMER_ID ORDER BY ORDER_DATE) AS RUNNING_TOTAL_PER_CUSTOMER FROM ORDERS;

-- Q18. For each order, calculate the average of the current and previous two orders.
SELECT CUSTOMER_ID,ORDER_ID,ORDER_DATE,AMOUNT,
AVG(AMOUNT) OVER(PARTITION BY CUSTOMER_ID ORDER BY ORDER_DATE ASC ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS AVG_PER_CUSTOMER_FOR_WITH_LAST_2_ORDER
FROM ORDERS;

-- Q19. For each row, count how many orders have occurred up to that point in time.
SELECT ORDER_ID,AMOUNT,ORDER_DATE, COUNT(*) OVER(ORDER BY ORDER_ID) AS RUNNING_COUNT FROM ORDERS;

-- Q20. Calculate cumulative revenue generated by each customer over time.
SELECT *, SUM(AMOUNT) OVER(PARTITION BY CUSTOMER_ID ORDER BY ORDER_DATE) AS CUMMULATIVE_REV_PER_CUST FROM ORDERS;

-- Q21. Divide all orders into 4 equal groups based on their order amounts.
SELECT *,NTILE(4) OVER(ORDER BY AMOUNT) AS NT FROM ORDERS;

-- Q22. Divide customers into 4 groups based on their total spending.
-- We first need to have total spending per customer and then we need to divide them in 4 group
SELECT CUSTOMER_ID,TOTAL_SPEND, NTILE(4) OVER(ORDER BY TOTAL_SPEND) AS NT FROM
(
	SELECT CUSTOMER_ID,SUM(AMOUNT) AS TOTAL_SPEND FROM ORDERS GROUP BY CUSTOMER_ID
) X;

-- Q23. For each order, calculate its relative ranking as a percentage among all orders.
SELECT *,ROUND(PERCENT_RANK() OVER(ORDER BY AMOUNT),5) AS RELATIVE_PERCENT_RANK FROM ORDERS;

-- Q24. For each order, determine the proportion of orders that have an amount less than or equal to it.
SELECT *,ROUND(CUME_DIST() OVER(ORDER BY AMOUNT),5) AS CUMMULATIVE_DIST FROM ORDERS;

-- Q25. Compare the relative ranking and cumulative distribution of order amounts for each row.
SELECT *,ROUND(PERCENT_RANK() OVER(ORDER BY AMOUNT),5) AS RELATIVE_PERCENT_RANK,
ROUND(CUME_DIST() OVER(ORDER BY AMOUNT),5) AS CUMMULATIVE_DIST
FROM ORDERS;

-- Q26. Identify orders where the current order amount is greater than the previous order amount for the same customer.
SELECT * 
FROM
(
	SELECT *,AMOUNT-LAG(AMOUNT) OVER(PARTITION BY CUSTOMER_ID ORDER BY ORDER_DATE) AS CURRENT_TO_PREV_AMOUNT_DIFF FROM ORDERS
) X WHERE CURRENT_TO_PREV_AMOUNT_DIFF>0;

-- Q27. Calculate the difference in days between consecutive orders for each customer.
SELECT CUSTOMER_ID,ORDER_ID,ORDER_DATE,AMOUNT, 
DATEDIFF(ORDER_DATE,LAG(ORDER_DATE) OVER(PARTITION BY CUSTOMER_ID ORDER BY ORDER_DATE)) AS DIFF_IN_DAYS_FROM_PREV_ORDER
FROM ORDERS;

-- Q28. Determine whether each customer's order trend is increasing or decreasing compared to their previous order.
SELECT CUSTOMER_ID,ORDER_ID,ORDER_DATE,AMOUNT AS CURRENT_AMOUNT,
LAG(AMOUNT) OVER(PARTITION BY CUSTOMER_ID ORDER BY ORDER_DATE) AS PREVIOUS_ORDER_AMOUNT,
CASE
	WHEN AMOUNT>LAG(AMOUNT) OVER(PARTITION BY CUSTOMER_ID ORDER BY ORDER_DATE) THEN 'INCREASING'
    WHEN AMOUNT=LAG(AMOUNT) OVER(PARTITION BY CUSTOMER_ID ORDER BY ORDER_DATE) THEN 'NO CHANGE'
    WHEN AMOUNT<LAG(AMOUNT) OVER(PARTITION BY CUSTOMER_ID ORDER BY ORDER_DATE) THEN 'DECREASING'
    ELSE NULL
END AS RUNNING_TREND
FROM ORDERS;

-- Q29. Identify the top 2 highest value orders for each customer.
SELECT CUSTOMER_ID,ORDER_ID,ORDER_DATE,AMOUNT
FROM
(
	SELECT CUSTOMER_ID,ORDER_ID,ORDER_DATE,AMOUNT,
    ROW_NUMBER() OVER(PARTITION BY CUSTOMER_ID ORDER BY AMOUNT DESC) AS RN FROM ORDERS
) X WHERE X.RN<=2;

-- Q30. For each customer, display both the running total of spending and their rank based on order amount within the same result.
SELECT CUSTOMER_ID,ORDER_ID,ORDER_DATE,AMOUNT AS CURRENT_AMOUNT,
SUM(AMOUNT) OVER(PARTITION BY CUSTOMER_ID ORDER BY ORDER_DATE) AS RUNNING_TOTAL,
RANK() OVER(PARTITION BY CUSTOMER_ID ORDER BY ORDER_DATE) AS ORDER_RANK_PER_CUSTOMER
FROM ORDERS;