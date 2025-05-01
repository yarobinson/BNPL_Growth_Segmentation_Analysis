/*File: data_exploration.sql
Purpose: Initial data exploration and analysis
*/

--Standardizing the date column in funnel table
ALTER TABLE funnel ADD COLUMN action_date_ts TIMESTAMPTZ;

SET datestyle = 'MDY';

UPDATE funnel
SET action_date_ts = action_date::TIMESTAMP;

ALTER TABLE funnel DROP COLUMN action_date;
ALTER TABLE funnel RENAME COLUMN action_date_ts TO action_date;

--Standardizing the date column in loans table
ALTER TABLE loans ADD COLUMN checkout_date_ts TIMESTAMPTZ;

SET datestyle = 'MDY';

UPDATE loans
SET checkout_date_ts = checkout_date::TIMESTAMP;

ALTER TABLE loans DROP COLUMN checkout_date;
ALTER TABLE loans RENAME COLUMN checkout_date_ts TO action_date;


--Counting the number of records in the dataset
SELECT COUNT(*) AS total_records
FROM funnel; 

SELECT COUNT(*) AS total_loans 
FROM loans;

SELECT COUNT(DISTINCT merchant_id) AS unique_merchants
FROM merchants; 

--Checking for null values
SELECT COUNT(*) AS total_loans,
    COUNT(CASE WHEN user_id IS NULL THEN 1 END) AS null_user_ids,
    COUNT(CASE WHEN merchant_id IS NULL THEN 1 END) AS null_merchant_ids,
    COUNT (CASE WHEN checkout_id IS NULL THEN 1 END) AS null_checkout_ids
FROM funnel; 

SELECT COUNT (*) AS  total_loans, 
    COUNT(CASE WHEN loan_amount IS NULL THEN 1 END) AS null_loan_amount
FROM loans;

--Checking data length
SELECT MIN(checkout_date) AS earliest_date,
    MAX(checkout_date) AS latest_date
FROM loans;

