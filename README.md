# DataAnalytics-Assessment

## Question 1

### Approach

* I created two Common Table Expressions (CTEs) to break down the solution logic and improve error debugging:

  * funded_savings: Identifies customers with at least one savings plan (is_regular_savings = 1) and confirmed deposits (confirmed_amount > 0).
  * funded_investments: Identifies customers with at least one investment plan (is_a_fund = 1) and confirmed deposits.

* Each CTE ensures that the associated plans are funded**, by checking confirmed_amount > 0.

* Both CTEs were joined using owner_id with the users_customuser table to retrieve customer information.

* Only customers who appear in both CTEs were included, confirming that they hold both a savings and an investment plan.

* The full customer name was constructed by concatenating first_name and last_name, rather than relying on a single name column.

* The total deposit amount was converted from kobo to naira by dividing by 100 for accuracy and presentation.

* Final results were ordered in descending order of total deposits to highlight the most valuable customers.

---

## Question 2

### Approach

* I created three CTEs to track the logical flow of the solution:

  * customer_transactions: Calculates the total number of transactions for each client and the number of months the client has been active using TIMESTAMPDIFF`.

  * customer_frequency: Computes the average number of transactions per month using values from the first CTE and retains key identifiers like owner_id, total_transactions, and months_active.

  * categorized_customers: Segments customers into three frequency categories using a CASE statement:

    * Low Frequency: ≤ 2 transactions/month
    * Medium Frequency: 3–9 transactions/month
    * High Frequency: ≥ 10 transactions/month

* I ensured that the owner_id in the savings_savingsaccount table matched only valid users by joining it with the users_customuser table on owner_id = id.

* The final query returned each frequency category, total customer count per category, and the average number of transactions per month.

* The results were grouped by frequency_category and sorted from High Frequency to Low Frequency using the FIELD() function for custom ordering.

---

## Question 3

### Approach

* I used a single CTE to isolate the core logic for clarity and ease of debugging:

  * latest_transactions: Retrieves the most recent transaction date (MAX(transaction_date)) for each plan from the savings_savingsaccount table, grouped by plan_id.

* I joined the CTE with the plans_plan table to filter only active savings and investment plans, using the conditions is_regular_savings = 1 or is_a_fund = 1.

* I calculated the number of days since the last transaction using TIMESTAMPDIFF(DAY, last_transaction_date, CURRENT_DATE).

* Records were filtered to return only those with at least 365 days of inactivity, indicating no inflow in over a year.

* The final output included:

  * plan_id
  * owner_id
  * Plan type (Savings or Investment)
  * last_transaction_date
  * inactivity_days

* Results were sorted in descending order of inactivity.

---

## Question 4

### Approach

* I broke the solution into three CTEs to clarify the logic and streamline debugging:

  * transaction_summary: Calculated the total number of transactions, the sum of confirmed_amount (converted from kobo to naira), and the average profit per transaction, assuming a 0.1% profit rate.

  * tenure_data: Calculated the number of months each customer has been on the platform using TIMESTAMPDIFF and CURRENT_DATE, and built the full name using CONCAT(first_name, last_name).

  * clv_calc: Merged both CTEs and applied the simplified CLV formula:

    $$
    \text{CLV} = \left(\frac{\text{total\_transactions}}{\text{tenure\_months}}\right) \times 12 \times \text{avg\_profit}
    $$

* The final output included:

  * customer_id
  * Full name
  * tenure_months
  * total_transactions
  * estimated_clv

* Results were sorted in descending order of estimated_clv.

---

## Challenges

* The .sql file was too large for some GUI interfaces to process efficiently. I had to load them through cli to avoid timeout and rendering issues.

* All financial values were stored in kobo. I converted them to naira by dividing by 100 before any aggregation or presentation to ensure business relevance.

* To avoid performance bottlenecks, I avoided repeating heavy joins and opted for CTEs, which improved both readability and execution performance.

