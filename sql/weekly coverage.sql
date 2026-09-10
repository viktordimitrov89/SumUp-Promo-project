WITH merchant_coverage AS (
    SELECT
        merchant_id,
        COUNT(DISTINCT CASE 
            WHEN transaction_status = 'successful' 
            THEN strftime('%w', created_at_clean)
        END) / 7.0 AS weekly_coverage
    FROM tableau_export
    WHERE created_at_clean >= '2025-08-01' 
      AND created_at_clean < '2025-09-30'
      AND fee_type = 'reduced_fee_promo'
    GROUP BY merchant_id
)
SELECT
    COUNT(*) AS total_merchants,
    ROUND(AVG(weekly_coverage), 3) AS avg_weekly_coverage
FROM merchant_coverage;