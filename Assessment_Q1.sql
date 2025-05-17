/*
===============================================================================
Script Name      : User Portfolio Overview
Author           : Fatima Idris
Created Date     : 2025-05-17
Description      : 
    This query summarizes each user's financial engagement on the platform by 
    combining savings and investment plan data. It calculates:
      - Number of unique savings accounts
      - Total confirmed deposits
      - Number of investment plans
    The result is ordered by total deposit in descending order.
===============================================================================
*/

USE adashi_staging;

-- ====================================================================================
-- Step 1: Aggregate savings data - count of unique savings plans and total deposits
-- ====================================================================================
WITH savings_agg AS (
    SELECT 
        owner_id, 
        COUNT(DISTINCT savings_id) AS savings_count,
        SUM(confirmed_amount) AS total_deposit
    FROM savings_savingsaccount
    WHERE savings_id > 0
    GROUP BY owner_id
),

-- ====================================================================================
-- Step 2: Aggregate investment data - count of unique investment plans
-- ====================================================================================
plans_agg AS (
    SELECT 
        owner_id, 
        COUNT(DISTINCT id) AS investment_count
    FROM plans_plan
    WHERE id > 0
    GROUP BY owner_id
)

-- ====================================================================================
-- Step 3: Combine user data with aggregated savings and investment metrics
-- ====================================================================================
SELECT 
    u.id, 
    CONCAT(u.first_name, ' ', u.last_name) AS Name,                        -- Full name of the user
    COALESCE(s.savings_count, 0) AS savings_count,                        -- Default to 0 if no savings
    COALESCE(p.investment_count, 0) AS investment_count,                  -- Default to 0 if no plans
    COALESCE(s.total_deposit, 0) AS total_deposit                         -- Default to 0 if no deposit
FROM users_customuser u
LEFT JOIN savings_agg s ON u.id = s.owner_id
LEFT JOIN plans_agg p ON u.id = p.owner_id
ORDER BY total_deposit DESC;
