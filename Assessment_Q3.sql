/* 
===============================================================================
Script Name      : Inactive Accounts Identification
Author           : Fatima Idris
Created Date     : 2025-05-17
Description      : 
    This script identifies all savings and investment accounts that have 
    had no confirmed inflow (transaction or charge) for more than 365 days. 
    It returns the account ID, owner ID, type of account, last transaction 
    date, and number of days since the last activity.
===============================================================================
*/

USE adashi_staging;

-- ====================================================================================
-- Identify savings accounts that have had no inflow in the past year
-- ====================================================================================
SELECT 
    sa.savings_id AS plan_id,                         -- Unique ID for savings plan
    sa.owner_id,                                      -- ID of the user who owns the plan
    'Savings' AS type,                                -- Hardcoded account type
    MAX(sa.transaction_date) AS last_transaction_date, -- Latest recorded transaction date
    DATEDIFF(CURDATE(), MAX(sa.transaction_date)) AS inactivity_days  -- Days since last transaction
FROM savings_savingsaccount sa
GROUP BY sa.savings_id, sa.owner_id
HAVING inactivity_days <= 365

UNION

-- ====================================================================================
-- Identify investment plans that haven't been charged in the past year
-- ====================================================================================
SELECT 
    pl.id AS plan_id,                                 -- Unique ID for investment plan
    pl.owner_id,                                      -- ID of the user who owns the plan
    'Investment' AS type,                             -- Hardcoded account type
    MAX(pl.last_charge_date) AS last_transaction_date, -- Latest recorded charge date
    DATEDIFF(CURDATE(), MAX(pl.last_charge_date)) AS inactivity_days  -- Days since last charge
FROM plans_plan pl
GROUP BY pl.id, pl.owner_id
HAVING inactivity_days <= 365

-- Sort the combined results by owner ID in descending order for readability
ORDER BY owner_id DESC;
