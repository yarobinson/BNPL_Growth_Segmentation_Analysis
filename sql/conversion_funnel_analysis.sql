/*File: conversion_funnel_analysis.sql
Purpose: Analyze conversion rates from checkout to loan by industry and age group then by music industry
*/
-- Conversion funnel analysis by industry and age group
-- Age bracket segmentation
WITH age_groups AS (
   SELECT user_id,
     CASE
       WHEN (2016 - user_dob_year) BETWEEN 18 AND 24 THEN '18-24'
       WHEN (2016 - user_dob_year) BETWEEN 25 AND 34 THEN '25-34'
       WHEN (2016 - user_dob_year) BETWEEN 35 AND 44 THEN '35-44'
       WHEN (2016 - user_dob_year) BETWEEN 45 AND 54 THEN '45-54'
       WHEN (2016 - user_dob_year) BETWEEN 55 AND 64 THEN '55-64'
       WHEN (2016 - user_dob_year) >= 65 THEN 'Over 65'
     END AS age_bracket
   FROM loans
   WHERE user_id != '0' AND user_id IS NOT NULL
),


-- Unique checkouts loaded
checkout_counts AS (
   SELECT m.category AS industry,
     COUNT(DISTINCT f.checkout_id) AS checkout_count
   FROM funnel AS f
     JOIN merchants AS m
     ON f.merchant_id = m.merchant_id
   WHERE f.action = 'Checkout Loaded'
    AND f.user_id != '0' AND f.user_id IS NOT NULL
   GROUP BY m.category
),

-- Unique loan count
loan_counts AS (
   SELECT m.category AS industry,
     a.age_bracket,
     COUNT(DISTINCT l.checkout_id) AS loan_count,
     SUM(l.loan_amount) AS total_loan_amount
   FROM loans AS l
     JOIN merchants AS m
     ON l.merchant_id = m.merchant_id
     JOIN age_groups AS a
     ON l.user_id = a.user_id
   WHERE l.user_id != '0' AND l.user_id IS NOT NULL
   GROUP BY m.category, a.age_bracket
)


SELECT l.industry,
 l.age_bracket,
 l.loan_count,
 l.total_loan_amount,
 c.checkout_count,
 CASE
   WHEN c.checkout_count > 0
   THEN ROUND((l.loan_count * 100.0 / c.checkout_count),2)
   ELSE 0
 END AS conversion_rate
FROM loan_counts AS l
JOIN checkout_counts AS c
ON l.industry = c.industry
ORDER BY conversion_rate DESC, total_loan_amount DESC;

-- Analysis for just the Music industry
WITH age_groups AS (
   SELECT user_id,
     CASE
       WHEN (2016 - user_dob_year) BETWEEN 25 AND 34 THEN '25-34'
       WHEN (2016 - user_dob_year) BETWEEN 35 AND 44 THEN '35-44'
       ELSE 'Other'
     END AS age_bracket
   FROM loans
   WHERE user_id != '0' AND user_id IS NOT NULL
),


-- Unique checkouts loaded for music industry
checkout_counts AS (
   SELECT m.category AS industry,
     COUNT(DISTINCT f.checkout_id) AS checkout_count
   FROM funnel AS f
     JOIN merchants AS m
     ON f.merchant_id = m.merchant_id
   WHERE f.action = 'Checkout Loaded'
    AND f.user_id != '0' AND f.user_id IS NOT NULL
    AND m.category = 'Music'
   GROUP BY m.category
),

-- Unique loan count for music industry
loan_counts AS (
   SELECT m.category AS industry,
     a.age_bracket,
     COUNT(DISTINCT l.checkout_id) AS loan_count,
     SUM(l.loan_amount) AS total_loan_amount
   FROM loans AS l
     JOIN merchants AS m
     ON l.merchant_id = m.merchant_id
     JOIN age_groups AS a
     ON l.user_id = a.user_id
   WHERE l.user_id != '0' AND l.user_id IS NOT NULL
    AND m.category = 'Music'
    AND a.age_bracket IN ('25-34', '35-44')
   GROUP BY m.category, a.age_bracket
)

SELECT l.industry, 
  l.age_bracket,
  l.loan_count,
  l.total_loan_amount,
  c.checkout_count,
  CASE
    WHEN c.checkout_count > 0
    THEN ROUND((l.loan_count * 100.0 / c.checkout_count),2)
    ELSE 0
  END AS conversion_rate
FROM loan_counts AS l
JOIN checkout_counts AS c
ON l.industry = c.industry
ORDER BY conversion_rate DESC, total_loan_amount DESC;