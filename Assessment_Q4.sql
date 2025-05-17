/*
===============================================================================
Script Name      : Customer Lifetime Value (CLV) Estimation
Author           : Fatima Idris
Created Date     : 2025-05-17
Description      : 
    This script calculates a simplified Customer Lifetime Value (CLV) estimate
    for each user based on:
      - Tenure (months since account creation)
      - Total transaction count
      - Average transaction value
    Assumes that profit per transaction is 0.1% (0.001) of the transaction value.
===============================================================================
*/

USE adashi_staging;

-- ====================================================================================
-- Estimate CLV for each customer based on transaction volume and tenure
-- ====================================================================================
SELECT 
    uc.id AS customer_id,                                                -- Unique user ID
    CONCAT(uc.first_name, ' ', uc.last_name) AS name,                    -- Full name
    TIMESTAMPDIFF(MONTH, uc.date_joined, CURDATE()) AS tenure_months,   -- Months since account creation
    COUNT(sa.id) AS total_transactions,                                  -- Total number of transactions
    ROUND(
        (COUNT(sa.id) / NULLIF(TIMESTAMPDIFF(MONTH, uc.date_joined, CURDATE()), 0)) 
        * 12                                                             -- Annualized frequency
        * (0.001 * AVG(sa.confirmed_amount)),                            -- Estimated profit per transaction
        2
    ) AS estimated_clv                                                   -- Final estimated CLV
FROM users_customuser uc
JOIN savings_savingsaccount sa ON uc.id = sa.owner_id                   -- Match each transaction to the user
GROUP BY uc.id, name, tenure_months                                     -- Group by user to compute aggregates
ORDER BY estimated_clv DESC;                                            -- Sort users by CLV in descending order
