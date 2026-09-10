WITH established AS (
    SELECT DISTINCT merchant_id 
    FROM "Home_Challenge_-_Transactions_2025_clean"
    WHERE fee_type = 'reduced_fee_promo'
),
pre AS (
    SELECT merchant_id, AVG(transaction_amount_eur) AS avg_gpv_pre
    FROM "Home_Challenge_-_Transactions_2025_clean"
    WHERE strftime('%Y-%m', created_at_clean) IN ('2025-06','2025-07')
      AND transaction_status = 'successful'
      AND merchant_id NOT IN (SELECT merchant_id FROM established)
    GROUP BY merchant_id
),
post AS (
    SELECT merchant_id, AVG(transaction_amount_eur) AS avg_gpv_post
    FROM "Home_Challenge_-_Transactions_2025_clean"
    WHERE strftime('%Y-%m', created_at_clean) IN ('2025-08','2025-09')
      AND transaction_status = 'successful'
      AND merchant_id NOT IN (SELECT merchant_id FROM established)
    GROUP BY merchant_id
)
SELECT 
    ROUND(AVG(pre.avg_gpv_pre),2) AS avg_gpv_established_pre,
    ROUND(AVG(post.avg_gpv_post),2) AS avg_gpv_established_post
FROM pre
JOIN post ON pre.merchant_id = post.merchant_id;