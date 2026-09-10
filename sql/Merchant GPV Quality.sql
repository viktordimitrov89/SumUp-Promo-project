SELECT 
    ROUND(AVG(transaction_amount_eur),2) AS avg_gpv_new_merchant
FROM "Home_Challenge_-_Transactions_2025_clean" hc
WHERE strftime('%Y-%m', created_at_clean) IN ('2025-08','2025-09')
  AND transaction_status = 'successful'
  AND merchant_id IN (
      SELECT DISTINCT merchant_id FROM "Home_Challenge_-_Transactions_2025_clean" hc WHERE fee_type = 'reduced_fee_promo'
  );