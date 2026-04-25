1.Find the top 10 customers who spent the most money?
SELECT id, income, total_spending
FROM customer_data
ORDER BY total_spending DESC
LIMIT 10;

2.Which education group spends the most?
SELECT education,
       AVG(total_spending) AS avg_spending
FROM customer_data
GROUP BY education
ORDER BY avg_spending DESC;

3.Which customer cluster responds most to campaigns?
SELECT cluster,
       AVG(response) AS response_rate
FROM customer_data
GROUP BY cluster
ORDER BY response_rate DESC;

4.Find customers who earn a lot but spend little.
SELECT id, income, total_spending
FROM customer_data
WHERE income > 70000
AND total_spending < 300;

5.Which countries have the most customers?
SELECT country,
       COUNT(*) AS total_customers
FROM customer_data
GROUP BY country
ORDER BY total_customers DESC;

6.How does number of children affect spending?
SELECT total_children,
       AVG(total_spending) AS avg_spending
FROM customer_data
GROUP BY total_children
ORDER BY total_children;

7.Find customers who did not respond.
SELECT *
FROM customer_data
WHERE response = 0;

8.Which age group spends more?
SELECT 
CASE 
    WHEN age < 30 THEN 'Young'
    WHEN age BETWEEN 30 AND 50 THEN 'Middle Age'
    ELSE 'Senior'
END AS age_group,

AVG(total_spending) AS avg_spending

FROM customer_data
GROUP BY age_group
ORDER BY avg_spending DESC;

9.Find customers who visit the website more than 5 times monthly.
SELECT id, numwebvisitsmonth
FROM customer_data
WHERE numwebvisitsmonth > 5;

Get cluster-level customer summary.
SELECT cluster,
       AVG(income) AS avg_income,
       AVG(age) AS avg_age,
       AVG(total_spending) AS avg_spending,
       AVG(total_children) AS avg_children
FROM customer_data
GROUP BY cluster
ORDER BY cluster;

10.Find top spending country per cluster.
SELECT cluster, country,
       SUM(total_spending) AS total_spent
FROM customer_data
GROUP BY cluster, country
ORDER BY cluster, total_spent DESC;

11.Rank customers based on total spending (highest spender gets rank 1).
SELECT 
    id,
    total_spending,
    RANK() OVER (
        ORDER BY total_spending DESC
    ) AS spending_rank
FROM customer_data;

12.Find the top 3 spending customers in each country.
SELECT *
FROM (
    SELECT 
        id,
        country,
        total_spending,
        ROW_NUMBER() OVER (
            PARTITION BY country
            ORDER BY total_spending DESC
        ) AS rn
    FROM customer_data
) t
WHERE rn <= 3;

13.Average Spending by Cluster? 
WITH cluster_avg AS (
    SELECT 
        cluster,
        AVG(total_spending) AS avg_spending
    FROM customer_data
    GROUP BY cluster
)

SELECT *
FROM cluster_avg;



14.High Spending Customers Per Cluster?

WITH cluster_avg AS (
    SELECT 
        cluster,
        AVG(total_spending) AS avg_spending
    FROM customer_data
    GROUP BY cluster
)

SELECT 
    c.id,
    c.cluster,
    c.total_spending
FROM customer_data c
JOIN cluster_avg ca
ON c.cluster = ca.cluster

WHERE c.total_spending > ca.avg_spending;

15.Multi-Level Customer Segmentation?
WITH spending_level AS (

SELECT *,
CASE
    WHEN total_spending > 1000 THEN 'High'
    WHEN total_spending BETWEEN 500 AND 1000 THEN 'Medium'
    ELSE 'Low'
END AS spending_category

FROM customer_data

)

SELECT spending_category,
COUNT(*) AS total_customers

FROM spending_level
GROUP BY spending_category;

16. Cluster Performance Summary?

WITH cluster_summary AS (

SELECT 
    cluster,
    COUNT(*) AS total_customers,
    AVG(income) AS avg_income,
    AVG(total_spending) AS avg_spending

FROM customer_data
GROUP BY cluster

)

SELECT *
FROM cluster_summary
ORDER BY avg_spending DESC;
