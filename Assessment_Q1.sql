SHOW DATABASES;

USE adashi_staging;

-- Question 1
-- Find users with both funded savings plans and funded investment plans
WITH 
funded_savings AS (
    SELECT
        s.owner_id,
        COUNT(DISTINCT s.plan_id) AS savings_count,
        SUM(s.confirmed_amount) AS total_savings
    FROM savings_savingsaccount s
    JOIN plans_plan p 
		ON s.plan_id = p.id
    WHERE p.is_regular_savings = 1 AND s.confirmed_amount > 0
    GROUP BY s.owner_id
),
funded_investments AS (
    SELECT
        s.owner_id,
        COUNT(DISTINCT s.plan_id) AS investment_count
    FROM savings_savingsaccount s
    JOIN plans_plan p 
		ON s.plan_id = p.id
    WHERE p.is_a_fund = 1 AND s.confirmed_amount > 0
    GROUP BY s.owner_id
)

SELECT
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    fs.savings_count,
    fi.investment_count,
    fs.total_savings / 100 AS total_deposits
FROM users_customuser u
JOIN funded_savings fs 
	ON fs.owner_id = u.id
JOIN funded_investments fi 
	ON fi.owner_id = u.id
ORDER BY total_deposits DESC;


