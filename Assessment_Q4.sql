-- Question 4

-- creating the CTEs, aimed and improving the runtime
WITH 
transaction_summary AS (
    SELECT 
        owner_id,
        COUNT(*) AS total_transactions,
        ROUND(SUM(confirmed_amount/100), 2) AS total_amount,
        ROUND(AVG(0.001 * (confirmed_amount/100)), 2) AS avg_profit
    FROM savings_savingsaccount
    GROUP BY owner_id
),
tenure_data AS (
    SELECT 
        id AS customer_id,
        CONCAT(first_name, ' ', last_name) AS name,
        TIMESTAMPDIFF(MONTH, date_joined, CURRENT_DATE)  AS tenure_months
    FROM users_customuser
),
clv_calc AS (
    SELECT 
        t.customer_id,
        t.name,
        t.tenure_months,
        ts.total_transactions,
        ROUND(
            (
                ts.total_transactions / t.tenure_months
            ) * 12 * ts.avg_profit , 2
        ) AS estimated_clv
    FROM tenure_data t
    JOIN transaction_summary ts 
		ON t.customer_id = ts.owner_id
)
SELECT *
FROM clv_calc
ORDER BY estimated_clv DESC;
