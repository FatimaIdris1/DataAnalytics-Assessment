/*
===============================================================================
Script Name      : Customer Transaction Frequency Categorization
Author           : Fatima Idris
Created Date     : 2025-05-17
Description      : 
    This script calculates the average number of transactions per customer
    per month and categorizes users into:
      - High Frequency   (≥10 transactions/month)
      - Medium Frequency (3–9 transactions/month)
      - Low Frequency    (≤2 transactions/month)
    The output shows how many customers fall into each category along with 
    the average number of transactions for that group.
===============================================================================
*/

USE adashi_staging;

-- ====================================================================================
-- Step 1: Get the number of transactions each user made per month
-- ====================================================================================
WITH monthly_txns AS (
    SELECT 
        owner_id,
        DATE_FORMAT(transaction_date, '%Y-%m') AS transaction_month,   -- Format date to month
        COUNT(*) AS txn_count                                          -- Count of transactions in that month
    FROM savings_savingsaccount
    GROUP BY owner_id, transaction_month
),

-- ====================================================================================
-- Step 2: For each user, compute total transactions and how many months they were active
-- ====================================================================================
user_txn_summary AS (
    SELECT 
        owner_id,
        SUM(txn_count) AS num_transact,                                -- Total transactions across months
        COUNT(DISTINCT transaction_month) AS num_months                -- Total number of active months
    FROM monthly_txns
    GROUP BY owner_id
),

-- ====================================================================================
-- Step 3: Join with user table, calculate average monthly transactions, and categorize
-- ====================================================================================
categorized_users AS (
    SELECT 
        uc.id AS user_id,
        uc.first_name,
        uc.last_name,
        sa.num_transact,
        sa.num_months,
        ROUND(sa.num_transact / sa.num_months, 2) AS avg_transaction,  -- Average transactions per month
        CASE 
            WHEN (sa.num_transact / sa.num_months) >= 10 THEN 'High Frequency'
            WHEN (sa.num_transact / sa.num_months) BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM users_customuser uc
)

-- ====================================================================================
-- Step 4: Aggregate by frequency category to get total customers and average txns
-- ====================================================================================
SELECT 
    frequency_category,                                                 -- User segment
    COUNT(*) AS customer_count,                                         -- Total users in category
    ROUND(AVG(avg_transaction), 1) AS avg_transactions_per_month       -- Average txns in group
FROM categorized_users
GROUP BY frequency_category
ORDER BY customer_count ASC;
