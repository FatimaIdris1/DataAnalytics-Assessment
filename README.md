# DataAnalytics-Assessment
Repository for Cowrywise Job Application Assessment

This repository showcases my SQL-based analysis projects focused on customer financial behaviors using the `adashi_staging` database. Across these four assessments, I aimed to derive practical insights around user engagement, account activity, and customer value, leveraging thoughtful queries and clean aggregation techniques.
With each script reflecting a real-world use case where business decisions can be informed through SQL analysis.

---

## Assessment 1: High-Value Customers with Multiple Products

**Scenario:** The business wants to identify customers who have both a savings and an investment plan (cross-selling opportunity).

### My Approach:
- Focused on savings accounts with non-zero balances to ensure we’re only considering engaged users.
- Counted unique savings accounts and summed up confirmed deposits for each user.
- For investments, filtered only plans marked as actual funds (`is_a_fund = 1`) to avoid inflating engagement.
- Combined the savings and investment summaries using user IDs as a common key.
- Handled missing values using `COALESCE`, ensuring all users are included even if they have only one product type.
- Sorted users by total confirmed deposits to highlight the most valuable customers first.

---

## Assessment 2: Customer Transaction Frequency Categorization

**Scenario:** The finance team wants to analyze how often customers transact to segment them (e.g., frequent vs. occasional users).

### My Approach:
- Extracted monthly transaction counts per user to measure consistency over time.
- Calculated total number of transactions and the number of months a user was active.
- Computed each user's average monthly transaction frequency.
- Joined with user details to create a complete profile per user.
- Classified users into High (≥10), Medium (3–9), and Low (≤2) frequency categories for easy interpretation.
- Summarized the results by category to see how many users fell into each group and their average behavior.

---

## Assessment 3: Inactive Accounts Identification

**Scenario:** The ops team wants to flag accounts with no inflow transactions for over one year.

### My Approach:
- Pulled the latest transaction dates from savings and last charge dates from investment plans.
- Calculated how many days had passed since each account’s last recorded activity.
- Used `HAVING` clauses to isolate accounts that have been inactive for more than 365 days.
- Tagged account types explicitly as either "Savings" or "Investment" for clarity in the final output.
- Merged both results using `UNION` to get a consolidated view of all inactive accounts.
- Sorted by owner_id to help stakeholders quickly scan through the list.

---

## Assessment 4: Customer Lifetime Value (CLV) Estimation

**Scenario:** Marketing wants to estimate CLV based on account tenure and transaction volume (simplified model).

### My Approach:
- Used account creation date to compute each user’s tenure in months.
- Counted all confirmed transactions per user and averaged transaction amounts.
- Assumed a conservative profit margin (0.1%) per transaction to estimate CLV in a simplified but scalable way.
- Annualized the transaction rate based on tenure to standardize the calculation across users.
- Used `NULLIF` to safely handle edge cases like new users with zero-month tenure.
- Ordered results by estimated CLV to easily spot the most valuable customers.

---

 **Author:** Fatima Idris  
 **Email:** fatimaidris388@gmail.com
