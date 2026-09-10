SELECT COUNT(DISTINCT merchant_id) AS active_new_merchants
FROM "Home_Challenge_-_Transactions_2025_clean" hc
WHERE fee_type = 'reduced_fee_promo'
AND transaction_status = 'successful';