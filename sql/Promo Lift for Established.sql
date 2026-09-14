WITH established AS (
    SELECT DISTINCT merchant_id 
    FROM "tableau_export"
    WHERE merchant_id NOT IN (
        SELECT DISTINCT merchant_id 
        FROM "tableau_export" 
        WHERE fee_type = 'reduced_fee_promo'
    )
),

pre AS (
    SELECT 
        merchant_id, 
        AVG(transaction_amount_eur) AS avg_gpv_pre,
        SUM(transaction_amount_eur) AS total_gmv_pre,
        COUNT(*) AS txn_count_pre
    FROM "tableau_export"
    WHERE strftime('%Y-%m', created_at_clean) IN ('2025-06','2025-07')
      AND transaction_status = 'successful'
      AND merchant_id IN (SELECT merchant_id FROM established)
    GROUP BY merchant_id
),

post AS (
    SELECT 
        merchant_id, 
        AVG(transaction_amount_eur) AS avg_gpv_post,
        SUM(transaction_amount_eur) AS total_gmv_post,
        COUNT(*) AS txn_count_post
    FROM "tableau_export"
    WHERE strftime('%Y-%m', created_at_clean) IN ('2025-08','2025-09')
      AND transaction_status = 'successful'
      AND merchant_id IN (SELECT merchant_id FROM established)
    GROUP BY merchant_id
),

combined AS (
    SELECT 
        pre.merchant_id,
        pre.avg_gpv_pre,
        post.avg_gpv_post,
        pre.total_gmv_pre,
        post.total_gmv_post,
        pre.txn_count_pre,
        post.txn_count_post
    FROM pre
    JOIN post ON pre.merchant_id = post.merchant_id
)

SELECT 
    COUNT(*) AS established_merchants_analyzed,
    ROUND(AVG(avg_gpv_pre), 2) AS avg_gpv_established_pre,
    ROUND(AVG(avg_gpv_post), 2) AS avg_gpv_established_post,
    ROUND(
        100.0 * (AVG(avg_gpv_post) - AVG(avg_gpv_pre)) / NULLIF(AVG(avg_gpv_pre), 0)
    , 2) AS pct_change_avg_gpv,
    ROUND(AVG(total_gmv_pre), 2) AS avg_total_gmv_pre_per_merchant,
    ROUND(AVG(total_gmv_post), 2) AS avg_total_gmv_post_per_merchant,
    ROUND(
        100.0 * (AVG(total_gmv_post) - AVG(total_gmv_pre)) / NULLIF(AVG(total_gmv_pre), 0)
    , 2) AS pct_change_total_gmv,
    ROUND(AVG(txn_count_pre), 2) AS avg_txn_count_pre,
    ROUND(AVG(txn_count_post), 2) AS avg_txn_count_post,
    ROUND(
        100.0 * (AVG(txn_count_post) - AVG(txn_count_pre)) / NULLIF(AVG(txn_count_pre), 0)
    , 2) AS pct_change_txn_count
FROM combined;