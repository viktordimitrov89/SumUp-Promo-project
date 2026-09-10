SumUp Promo Cohort Analysis

SQL + Tableau analysis measuring the impact and quality of a reduced-fee promotion targeted at new merchants, using transaction data from June–September 2025.

What's inside
Home_Challenge_-_Transactions_2025_clean.sql — cleans and standardizes the raw transactions table (date parsing)
tableau_export.sql — builds the analysis table, tagging each merchant as New (Promo Cohort) or Established based on whether they ever used the reduced_fee_promo fee type
Promo_Cohort_Index.sql — core KPI: compares % of new merchants vs. their % share of total GMV
weekly_coverage.sql — measures how many distinct weekdays each promo merchant transacted on (0–1 scale)
Merchant_GPV_Quality.sql / Established_Merchants_GPV_Quality.sql — average transaction value, new vs. established
Sanity_check.sql — checks whether established merchants' average transaction value shifted after the promo launched (control for external/seasonal effects)
New_Merchants_based_on_promo_fee.sql, How_many_merchants_made_transactions_with_the_reduced_fees_in_August_2025.sql, Which_merchant_had_the_highest_number_of_reduced_fee_transactions.sql — supporting merchant-count and ranking queries
Key insights (Aug 1 – Sep 29, 2025)

120 new merchants were activated through the reduced-fee promo — 47.8% of all active merchants in the period, but they generated only 22.5% of total GMV.

Promo Cohort Quality Index: 0.47 — new merchants' GMV contribution is roughly half of what their headcount share would suggest. This is expected early on: new merchants ramp up volume gradually, but it's a metric worth tracking monthly to confirm the gap closes over time.
Weekly coverage: 85.8% — on average, promo merchants transact on ~6 out of 7 weekdays, indicating decent early engagement rather than one-off trial usage.
Multi-product usage: 97.5% of new merchants use more than one product (card reader, online store, payment links) — a strong signal of genuine adoption, not just a single-transaction test of the discount.
Product mix differs sharply by cohort: new merchants lean heavily toward card_reader (€70.3K) over online_store and payment_links (~€67K each), while established merchants are evenly split (~€415K each) — suggesting the promo is landing best with in-person/card-present use cases.
New merchants show a higher product success rate (88.1%) than established (84.5%), meaning promo merchants are converting reliably across product types despite lower absolute volume.
Net revenue contribution from new merchants: €1,557.6, against €389.2 in discounts given — a ~4:1 revenue-to-discount ratio for the cohort so far.
Suggested next steps
Track the Cohort Quality Index monthly to see if new-merchant GMV share catches up to their headcount share (maturation curve)
Segment weekly coverage by product type to see which product drives the most consistent usage
Re-run the sanity check quarterly to rule out promo-driven cannibalization of established merchant spend
