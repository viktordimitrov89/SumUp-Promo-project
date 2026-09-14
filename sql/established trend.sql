WITH established AS (
    SELECT DISTINCT merchant_id 
    FROM "tableau_export"
    WHERE merchant_id NOT IN (
        SELECT DISTINCT merchant_id 
        FROM "tableau_export" 
        WHERE fee_type = 'reduced_fee_promo'
    )
),

monthly AS (
    SELECT
        strftime('%Y-%m', created_at_clean) AS year_month,
        COUNT(DISTINCT merchant_id) AS active_merchants,
        SUM(transaction_amount_eur) AS total_gmv,
        COUNT(*) AS total_transactions,
        AVG(transaction_amount_eur) AS avg_gpv
    FROM "tableau_export"
    WHERE transaction_status = 'successful'
      AND merchant_id IN (SELECT merchant_id FROM established)
      AND strftime('%Y-%m', created_at_clean) IN ('2025-06','2025-07','2025-08','2025-09')
    GROUP BY strftime('%Y-%m', created_at_clean)
)

SELECT
    year_month,
    active_merchants,
    ROUND(total_gmv, 2) AS total_gmv,
    ROUND(total_gmv / active_merchants, 2) AS avg_gmv_per_merchant,
    total_transactions,
    ROUND(avg_gpv, 2) AS avg_gpv,
    ROUND(
        100.0 * (total_gmv - LAG(total_gmv) OVER (ORDER BY year_month)) 
        / NULLIF(LAG(total_gmv) OVER (ORDER BY year_month), 0)
    , 2) AS mom_gmv_growth_pct
FROM monthly
ORDER BY year_month;