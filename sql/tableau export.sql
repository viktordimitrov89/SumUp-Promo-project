CREATE TABLE tableau_export AS
SELECT
    transaction_id,
    merchant_id,
    product,
    fee_type,
    fee_amount_eur,
    created_at_clean,
    strftime('%Y-%m', created_at_clean) AS year_month,
    transaction_amount_eur,
    transaction_status,
    CASE 
        WHEN merchant_id IN (
            SELECT DISTINCT merchant_id FROM "Home_Challenge_-_Transactions_2025_clean" WHERE fee_type = 'reduced_fee_promo'
        ) THEN 'New (Promo Cohort)'
        ELSE 'Established'
    END AS merchant_cohort
FROM "Home_Challenge_-_Transactions_2025_clean";