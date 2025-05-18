WITH monthly_txns AS (
  SELECT 
    owner_id,
    DATE_FORMAT(created_on, '%Y-%m-01') AS txn_month,
    COUNT(*) AS monthly_txn_count
  FROM savings_savingsaccount
  GROUP BY owner_id, txn_month
),
avg_txns AS (
  SELECT 
    owner_id,
    AVG(monthly_txn_count) AS avg_txns_per_month
  FROM monthly_txns
  GROUP BY owner_id
),
categorized AS (
  SELECT 
    CASE 
      WHEN avg_txns_per_month >= 10 THEN 'High Frequency'
      WHEN avg_txns_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
      ELSE 'Low Frequency'
    END AS frequency_category
  FROM avg_txns
)
SELECT 
  frequency_category,
  COUNT(*) AS customer_count,
  ROUND(AVG(avg_txns_per_month), 1) AS avg_transactions_per_month
FROM (
  SELECT 
    owner_id,
    AVG(monthly_txn_count) AS avg_txns_per_month
  FROM monthly_txns
  GROUP BY owner_id
) avg_txns
JOIN (
  SELECT 
    owner_id,
    CASE 
      WHEN AVG(monthly_txn_count) >= 10 THEN 'High Frequency'
      WHEN AVG(monthly_txn_count) BETWEEN 3 AND 9 THEN 'Medium Frequency'
      ELSE 'Low Frequency'
    END AS frequency_category
  FROM monthly_txns
  GROUP BY owner_id
) categorized ON avg_txns.owner_id = categorized.owner_id
GROUP BY frequency_category
ORDER BY FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');

