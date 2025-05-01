/* 
File: growth_analysis.sql
Purpose: Analyze loan data by age group and month
*/

-- Loan count and volume by month
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


monthly_loans AS (
 SELECT
   m.category AS industry,
   a.age_bracket,
   EXTRACT(MONTH FROM l.checkout_date) AS month,
   COUNT(DISTINCT l.checkout_id) AS loan_count,
   SUM(l.loan_amount) AS loan_volume
 FROM loans AS l
 JOIN merchants AS m
 ON l.merchant_id = m.merchant_id
 JOIN age_groups AS a
 ON l.user_id = a.user_id
 WHERE l.user_id != '0' AND l.user_id IS NOT NULL
 GROUP BY m.category, a.age_bracket, EXTRACT(MONTH FROM l.checkout_date)
)


SELECT
 industry,
 age_bracket,
 month,
 CASE
   WHEN month = 1 THEN 'January'
   WHEN month = 2 THEN 'February'
   WHEN month = 3 THEN 'March'
   WHEN month = 4 THEN 'April'
   WHEN month = 5 THEN 'May'
   WHEN month = 6 THEN 'June'
   WHEN month = 7 THEN 'July'
   WHEN month = 8 THEN 'August'
   WHEN month = 9 THEN 'September'
   WHEN month = 10 THEN 'October'
   WHEN month = 11 THEN 'November'
   WHEN month = 12 THEN 'December'
 END AS month_name,
 loan_count,
 loan_volume
FROM monthly_loans
ORDER BY industry, age_bracket, month;