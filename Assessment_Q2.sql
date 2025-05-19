-- Question 2

WITH 
customer_transactions AS (
    SELECT 
        u.id,
        COUNT(*) AS total_transactions,
        
        -- calculate the total number of months client has been active
        timestampdiff(MONTH, MIN(transaction_date),  MAX(transaction_date)) AS months_active
    FROM savings_savingsaccount s
    JOIN users_customuser u
		ON s.owner_id = u.id
    GROUP BY u.id
),
customer_frequency AS (
    SELECT
        id,
        total_transactions,
        months_active,
        ROUND(total_transactions / 
				months_active) AS transactions_per_month
    FROM customer_transactions
),
categorized_customers AS (
    SELECT
        id,
        transactions_per_month,
        CASE 
            WHEN transactions_per_month <=2 THEN 'Low Frequency'
            WHEN transactions_per_month >=3 AND transactions_per_month <10 THEN 'Medium Frequency'
            ELSE 'High Frequency'
        END AS frequency_category
    FROM customer_frequency
)

SELECT
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(transactions_per_month), 1) AS avg_transactions_per_month
FROM categorized_customers
GROUP BY frequency_category
ORDER BY FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');
