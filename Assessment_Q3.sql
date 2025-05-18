-- Question 3

WITH latest_transactions AS (
    SELECT 
        plan_id,
        MAX(transaction_date) AS last_transaction_date
    FROM savings_savingsaccount
    GROUP BY plan_id
)
SELECT 
    p.id AS plan_id,
    p.owner_id,
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'None'
    END AS type,
    lt.last_transaction_date,
    timestampdiff(DAY, lt.last_transaction_date,  CURRENT_DATE) AS inactivity_days
FROM plans_plan p
JOIN latest_transactions lt 
	ON p.id = lt.plan_id
WHERE (p.is_regular_savings = 1 OR p.is_a_fund = 1)
  AND lt.last_transaction_date <= CURRENT_DATE - INTERVAL 365 DAY
ORDER BY inactivity_days DESC;
