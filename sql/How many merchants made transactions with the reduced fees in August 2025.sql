SELECT 
    COUNT(DISTINCT merchant_id) AS num_merchants_reduced_fee
FROM "Home_Challenge_-_Transactions_2025_clean"
WHERE fee_type = 'reduced_fee_promo'
  AND transaction_status = 'successful'  
  AND created_at_clean >= '2025-08-01' 
  AND created_at_clean < '2025-09-01';