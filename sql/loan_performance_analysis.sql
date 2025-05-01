/*  
File: loan_performance_analysis.sql
Purpose: Analyze loan performance metrics by merchant industry and age group
*/

--Revenue and retun by industry and age group
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
)

SELECT m.category AS industry, a.age_bracket,

 -- Volume
 COUNT(l.checkout_id) AS loan_count,
 ROUND(AVG(l.loan_amount),2) AS avg_loan_amount,
 SUM(l.loan_amount) AS total_loan_volume,
  -- Performance
 ROUND(AVG(l.loan_return_percentage),2) AS avg_return_percentage,
  -- Revenue
 ROUND(AVG((l.mdr + l.loan_return_percentage) * l.loan_amount),2) AS avg_revenue_per_loan,
 ROUND(SUM((l.mdr + l.loan_return_percentage) * l.loan_amount),2) AS total_revenue
FROM loans AS l
JOIN merchants AS m
ON l.merchant_id = m.merchant_id
JOIN age_groups AS a
ON l.user_id = a.user_id
WHERE l.user_id != '0' AND l.user_id IS NOT NULL
GROUP BY m.category, a.age_bracket
ORDER BY total_revenue DESC;

-- FICO score analysis by industry and age group
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
)


SELECT m.category AS industry, a.age_bracket,
--Average FICO
AVG(CASE WHEN l.fico_score > 0 THEN l.fico_score ELSE NULL END) as avg_fico,
COUNT(*) AS total_loans,
SUM(CASE WHEN l.fico_score = 0 THEN 1 ELSE 0 END) AS zero_fico_count,
(SUM(CASE WHEN l.fico_score = 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS zero_fico_percentage


FROM loans AS l
JOIN merchants AS m
ON l.merchant_id = m.merchant_id
JOIN age_groups AS a
ON l.user_id = a.user_id
WHERE l.user_id != '0' AND l.user_id IS NOT null
GROUP BY m.category, a.age_bracket
ORDER BY avg_fico;

-- Analysis of loan terms, APR, down payment, and loan amount by industry and age group
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
)

SELECT m.category AS industry, a.age_bracket,
--Average Loan Terms
AVG(l.loan_length_months) AS avg_loan_terms,
--Average APR
ROUND(AVG(l.apr) * 100, 2) AS avg_apr,
--Average down payment
AVG(l.down_payment_amount) AS avg_downpayment,
--Average loan amount
ROUND(AVG(l.loan_amount)) AS avg_loan_amount,
--Average merchant discount rate
ROUND(AVG(l.mdr) * 100, 2) AS avg_mdr

FROM loans AS l
JOIN merchants AS m
ON l.merchant_id = m.merchant_id
JOIN age_groups AS a
ON l.user_id = a.user_id
WHERE l.user_id != '0' AND l.user_id IS NOT null
GROUP BY m.category, a.age_bracket
ORDER BY industry, age_bracket;


-- Additional analysis of APRs
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
  COUNT(*) AS loan_count, 
  -- Avg, min and max APR
  ROUND(AVG(l.apr) * 100, 2) AS avg_apr,
  ROUND(MIN(l.apr) * 100, 2) AS min_apr,
  ROUND(MAX(l.apr) * 100, 2) AS max_apr,
  -- APR distribution
  COUNT(CASE WHEN l.apr <= 0.10 THEN 1 END) AS apr_under_10pct, 
  COUNT(CASE WHEN l.apr > 0.10 AND l.apr <= 0.20 THEN 1 END) AS apr_10_to_20pct, 
  COUNT(CASE WHEN l.apr > 0.20 AND l.apr <= 0.30 THEN 1 END) AS apr_20_to_30pct,
  COUNT(CASE WHEN l.apr > 0.30 THEN 1 END) AS apr_over_30pct
FROM loans AS l
JOIN merchants AS m
ON l.merchant_id = m.merchant_id
JOIN age_groups AS a
ON l.user_id = a.user_id
WHERE l.user_id != '0' 
  AND l.user_id IS NOT null
  AND l.apr != 0
  AND m.category = 'Music'
  AND a.age_bracket IN ('25-34', '35-44')
GROUP BY m.category, a.age_bracket
ORDER BY m.category, a.age_bracket;