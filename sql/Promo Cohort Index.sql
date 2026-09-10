WITH combined_summary AS (
    SELECT
        COUNT(DISTINCT merchant_id) AS total_merchants,
        COUNT(DISTINCT CASE 
            WHEN merchant_cohort = 'New (Promo Cohort)' THEN merchant_id 
        END) AS new_merchants,
        SUM(CASE WHEN transaction_status = 'successful' THEN transaction_amount_eur ELSE 0 END) AS total_gmv,
        SUM(CASE 
            WHEN transaction_status = 'successful' AND merchant_cohort = 'New (Promo Cohort)' 
            THEN transaction_amount_eur ELSE 0 
        END) AS new_gmv
    FROM tableau_export
    WHERE year_month IN ('2025-08', '2025-09')
)

SELECT
    total_merchants,
    new_merchants,
    ROUND(100.0 * new_merchants / NULLIF(total_merchants, 0), 2) AS pct_new_merchants,
    ROUND(total_gmv, 2) AS total_gmv,
    ROUND(new_gmv, 2) AS new_gmv,
    ROUND(100.0 * new_gmv / NULLIF(total_gmv, 0), 2) AS pct_new_gmv,
    ROUND(
        (100.0 * new_gmv / NULLIF(total_gmv, 0))
        / NULLIF((100.0 * new_merchants / NULLIF(total_merchants, 0)), 0)
    , 3) AS promo_cohort_quality_index
FROM combined_summary;