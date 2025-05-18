-- Savings accounts with no transactions in the last 365 days
SELECT 
    s.id AS plan_id,
    s.owner_id,
    'Savings' AS type,
    MAX(s.created_on) AS last_transaction_date,
    DATEDIFF(CURDATE(), MAX(s.created_on)) AS inactivity_days
FROM savings_savingsaccount s
WHERE s.confirmed_amount > 0
GROUP BY s.id, s.owner_id
HAVING MAX(s.created_on) < CURDATE() - INTERVAL 365 DAY

UNION ALL

-- Investment plans with no transactions in the last 365 days
SELECT 
    p.id AS plan_id,
    p.owner_id,
    'Investment' AS type,
    MAX(p.created_on) AS last_transaction_date,
    DATEDIFF(CURDATE(), MAX(p.created_on)) AS inactivity_days
FROM clean_plans_plan p
WHERE p.plan_type_id = 2
  AND p.is_deleted = 0
GROUP BY p.id, p.owner_id
HAVING MAX(p.created_on) < CURDATE() - INTERVAL 365 DAY;
