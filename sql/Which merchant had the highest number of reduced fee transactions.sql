SELECT 
    merchant_id,
    COUNT(*) AS reduced_fee_transaction_count
FROM "Home_Challenge_-_Transactions_2025_clean"
WHERE fee_type = 'reduced_fee_promo'
  AND transaction_status = 'successful' 
GROUP BY merchant_id
ORDER BY reduced_fee_transaction_count DESC
LIMIT 1;