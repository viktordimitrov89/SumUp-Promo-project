CREATE TABLE "Home_Challenge_-_Transactions_2025_clean" AS
SELECT
    transaction_id,
    merchant_id,
    product,
    fee_type,
    fee_amount_eur,
    substr(created_at,7,4) || '-' || substr(created_at,4,2) || '-' || substr(created_at,1,2) || ' ' ||
    printf('%02d:%02d:00',
        CAST(substr(substr(created_at,12), 1, instr(substr(created_at,12), ':') - 1) AS INTEGER),
        CAST(substr(substr(created_at,12), instr(substr(created_at,12), ':') + 1, 2) AS INTEGER)
    ) AS created_at_clean,
    transaction_amount_eur,
    transaction_status
FROM "Home_Challenge_-_Transactions_2025(Home Challenge - Transactions_2)";