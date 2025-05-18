-- Question 2

WITH customer_transactions AS (
    SELECT 
        owner_id,
        COUNT(*) AS total_transactions,
        timestampdiff(MONTH, MIN(transaction_date),  MAX(transaction_date)) + 1 AS months_active
    FROM savings_savingsaccount
    GROUP BY owner_id
),
customer_frequency AS (
    SELECT
        owner_id,
        total_transactions,
        months_active,
        ROUND(total_transactions / 
				months_active) AS transactions_per_month
    FROM customer_transactions
),
categorized_customers AS (
    SELECT
        owner_id,
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
