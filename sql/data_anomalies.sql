/*
File: data_anomalies.sql
Purpose: Identify and analyze data anomalies in the loans, funnel, and merchants tables
*/
-- Check for records where user_id = 0
SELECT COUNT (*) AS total_records, 
    COUNT(CASE WHEN user_id = '0' THEN 1 END) AS user_id_zero_count
FROM funnel; 

SELECT COUNT(*) AS total_loans, 
    COUNT(CASE WHEN user_id = '0' THEN 1 END) AS user_id_zero_count
FROM loans;

-- Identify actions associated with user_id = 0
SELECT action, 
    COUNT(*) AS action_count,
    COUNT(DISTINCT checkout_id) AS unique_checkouts
FROM funnel
WHERE user_id = '0'
GROUP BY action
ORDER BY action_count DESC; 

-- Check for invalid FICO scores
SELECT COUNT(*) AS total_loans,
    COUNT(CASE WHEN fico_score = 0 THEN 1 END) AS fico_zero_count,
    COUNT(CASE WHEN fico_score IS NULL THEN 1 END) AS fico_null_count,
    COUNT(CASE WHEN fico_score = 0 THEN 1 END) *100.0 / COUNT(*) AS fico_zero_percentage
FROM loans; 

-- Analyze FICO score distribution
SELECT 
    CASE
        WHEN fico_score = 0 THEN 'Developing Credit'
        WHEN fico_score IS NULL THEN 'Null'
        WHEN fico_score BETWEEN 1 AND 579 THEN 'Deep Subprime'
        WHEN fico_score BETWEEN 580 AND 619 THEN 'Subprime'
        WHEN fico_score BETWEEN 620 AND 659 THEN 'Near Prime'
        WHEN fico_score BETWEEN 660 AND 729 THEN 'Prime'
        WHEN fico_score >= 730 THEN 'Superprime'
    ELSE 'Unknown'
    END AS fico_range,
    COUNT(*) AS count, 
    (COUNT(*) * 100.0 / (SELECT COUNT (*) FROM loans)) AS percentage
FROM loans
GROUP BY fico_range;

-- Check for users with unrealistic ages
SELECT (2016 - user_dob_year) AS calculated_age,
    COUNT(*) AS user_count 
FROM loans
WHERE user_id != '0' AND user_id IS NOT NULL
GROUP BY calculated_age
ORDER BY calculated_age DESC;

-- Check FICO scores for Music industry
WITH age_groups AS (
  SELECT user_id,
    CASE
      WHEN (2016 - user_dob_year) BETWEEN 25 AND 34 THEN '25-34'
      WHEN (2016 - user_dob_year) BETWEEN 35 AND 44 THEN '35-44'
      ELSE 'Other'
    END AS age_bracket
  FROM loans
  WHERE user_id != '0' AND user_id IS NOT NULL
)

SELECT m.category AS industry, 
    a.age_bracket, 
    COUNT(*) AS total_loans, 
    COUNT(CASE WHEN l.fico_score = 0 THEN 1 END) AS fico_zero_count,
    COUNT(CASE WHEN l.fico_score = 0 THEN 1 END) * 100.0 / COUNT(*) AS fico_zero_percentage
FROM loans AS l
JOIN merchants AS m 
ON l.merchant_id = m.merchant_id
JOIN age_groups AS a
ON l.user_id = a.user_id
WHERE m.category = 'Music' and a.age_bracket IN ('25-34', '35-44')
GROUP BY m.category, a.age_bracket; 

-- Check for duplicate merchant IDs
SELECT merchant_name,
    COUNT(DISTINCT merchant_id) AS distinct_merchant_ids
FROM merchants
GROUP BY merchant_name; 
