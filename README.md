🎯 SumUp Promo Cohort Analysis

SQL + Tableau analysis measuring the impact and quality of a reduced-fee promotion targeted at new merchants — cohort quality, weekly engagement, and product adoption.

Show Image Show Image Show Image

📌 Project Overview

This project analyzes a reduced-fee promotion aimed at activating new merchants, using transaction data from June–September 2025. The goal is to measure whether the promo cohort's contribution to GMV is proportional to its size, how consistently new merchants engage week over week, and how their product usage compares to established merchants — using SQL for data preparation and Tableau for visual analytics.

All data is synthetically generated and does not represent any real individuals or companies.

📊 Tableau Dashboard

Answers the question: "Is the reduced-fee promo bringing in merchants who actually stick around and contribute value — or just cheap volume?"

Sheets included:

📈 GMV Trend: New vs Established — daily bar chart, 01 Aug – 29 Sep
🟦 Promo Cohort Contribution — share of total merchants vs. share of total GMV
📊 GMV Share by Product (New) — card_reader / online_store / payment_links, new vs established
📶 Products Success Rate by Merchants — new vs established
🏆 Top 5 Merchants — by month (August / September)
🎛️ Filters — Product, Date Range, Merchant Cohort

KPI Cards:

KPI	Value
Cohort Quality Index	0.47
Weekly Coverage	85.8%
Newly Activated Merchants	120
Net Revenue Contribution (New)	€1,557.6
Discount Amount	€389.2
Multi-Product Usage (New)	97.5%
💡 Key Insights
⚖️ Cohort Quality Index: 0.47 — new merchants make up 47.8% of all active merchants but generate only 22.5% of total GMV. Expected in an early ramp-up phase, but worth tracking monthly to confirm the gap closes.
📅 Weekly coverage of 85.8% — promo merchants transact on ~6 of 7 weekdays on average, a sign of genuine early engagement rather than one-off trial usage.
🔀 97.5% of new merchants use more than one product — strong adoption signal, not just single-transaction discount-chasing.
💳 Product mix differs by cohort — new merchants lean heavily on card_reader (€70.3K) over online_store/payment_links (~€67K each), while established merchants are evenly split — the promo appears to land best with card-present use cases.
✅ New merchants show a higher product success rate (88.1%) than established (84.5%) — despite lower volume, promo merchants convert reliably across product types.
💰 ~4:1 revenue-to-discount ratio — €1,557.6 in net revenue contribution against €389.2 given in discounts so far.
🔍 Sanity check on established merchants — average transaction value pre- vs. post-promo launch shows no meaningful shift, ruling out cannibalization of existing merchant spend.
❓ Business Questions Answered
#	Question	SQL Query
Q1	How many merchants transacted with reduced fees in August 2025?	How_many_merchants_made_transactions_with_the_reduced_fees_in_August_2025.sql
Q2	How does new-merchant GMV share compare to their headcount share?	Promo_Cohort_Index.sql
Q3	How consistently do promo merchants transact across the week?	weekly_coverage.sql
Q4	What is the average transaction value for new vs. established merchants?	Merchant_GPV_Quality.sql / Established_Merchants_GPV_Quality.sql
Q5	Which merchant used the reduced fee the most?	Which_merchant_had_the_highest_number_of_reduced_fee_transactions.sql
Q6	Did the promo affect established merchants' spending behavior?	Sanity_check.sql
🔍 SQL Highlights
tableau_export — Cohort Tagging (Table Build)
sql
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
            SELECT DISTINCT merchant_id FROM "Home_Challenge_-_Transactions_2025_clean" 
            WHERE fee_type = 'reduced_fee_promo'
        ) THEN 'New (Promo Cohort)'
        ELSE 'Established'
    END AS merchant_cohort
FROM "Home_Challenge_-_Transactions_2025_clean";
Promo Cohort Quality Index (CTE)
sql
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
Weekly Coverage
sql
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
🛠️ Tools Used
Tool	Purpose
SQLite / DB Browser	Data querying and transformation
Tableau Public	Data visualisation and dashboard
VS Code	SQL file editing
GitHub	Version control and portfolio hosting
📁 Repository Structure
SumUp-Promo-project/
│
├── data/                                                        # Source data
│   └── tableau_export.xlsx
│
├── sql/                                                         # SQL queries
│   ├── Home_Challenge_-_Transactions_2025_clean.sql
│   ├── tableau_export.sql
│   ├── Promo_Cohort_Index.sql
│   ├── weekly_coverage.sql
│   ├── Merchant_GPV_Quality.sql
│   ├── Established_Merchants_GPV_Quality.sql
│   ├── New_Merchants_based_on_promo_fee.sql
│   ├── How_many_merchants_made_transactions_with_the_reduced_fees_in_August_2025.sql
│   ├── Which_merchant_had_the_highest_number_of_reduced_fee_transactions.sql
│   └── Sanity_check.sql
│
├── screenshots/                                                 # Dashboard screenshot
│   └── dashboard.png
│
└── README.md
🔗 Live Dashboard

📌 View the interactive Tableau dashboard on Tableau Public:

[[Add your Tableau Public link here](https://public.tableau.com/app/profile/viktor.dimitrov/viz/SumUpInterview_17878383508450/Dashboard1?publish=yes)]

👤 Author

Viktor Dimitrov
Data & BI Analyst | SQL • Tableau • Power BI
GitHub
