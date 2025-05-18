SELECT 
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS customer_name,
    COUNT(DISTINCT s.id) AS savings_count,
    COUNT(DISTINCT p.id) AS investment_count,
    SUM(s.confirmed_amount) AS total_deposits
FROM users_customer u
JOIN savings_savingsaccount s
    ON u.id = s.owner_id
    AND s.confirmed_amount > 0
JOIN clean_plans_plan p
    ON u.id = p.owner_id
    AND p.plan_type_id = 2        -- Assuming 2 = investment
    AND p.is_deleted = 0          -- Ignore deleted plans
WHERE u.is_active = 1             -- Only active users
GROUP BY u.id, u.username, u.first_name, u.last_name
HAVING COUNT(DISTINCT s.id) > 0 AND COUNT(DISTINCT p.id) > 0
ORDER BY total_deposits DESC;

