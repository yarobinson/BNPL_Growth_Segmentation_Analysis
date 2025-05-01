/*   
File: customer_loyalty_analysis.sql
Purpose: Analyze repeat usage patterns by merchant industry and age group and by target insdustry (Music) and age group (25-34, 35-44)
*/

-- Repeat users by industry and age group
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


user_loan_counts AS (
 SELECT
   l.user_id,
   m.category AS industry,
   a.age_bracket,
   COUNT(DISTINCT l.checkout_id) AS loans_per_user,
   SUM(l.loan_amount) AS total_user_loan_amount,
   MIN(l.checkout_date) AS first_loan_date,
   MAX(l.checkout_date) AS last_loan_date
 FROM loans AS l
 JOIN merchants AS m
 ON l.merchant_id = m.merchant_id
 JOIN age_groups AS a
 ON l.user_id = a.user_id
 WHERE l.user_id != '0' AND l.user_id IS NOT NULL
 GROUP BY l.user_id, m.category, a.age_bracket
)


SELECT
 industry,
 age_bracket,
 COUNT(DISTINCT user_id) AS total_users,
 SUM(CASE WHEN loans_per_user > 1 THEN 1 ELSE 0 END) AS repeat_users,
 ROUND((SUM(CASE WHEN loans_per_user > 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT user_id)),2) AS repeat_user_percentage,
 ROUND(AVG(loans_per_user),2) AS avg_loans_per_user,
 ROUND(AVG(total_user_loan_amount),2) AS avg_total_loan_amount,
 ROUND(SUM(total_user_loan_amount),2) AS segment_total_value
FROM user_loan_counts
GROUP BY industry, age_bracket
ORDER BY repeat_user_percentage DESC, segment_total_value DESC;

-- Customer loyalty in the Music industry
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


user_loan_counts AS (
 SELECT
   l.user_id,
   m.category AS industry,
   a.age_bracket,
   COUNT(DISTINCT l.checkout_id) AS loans_per_user,
   SUM(l.loan_amount) AS total_user_loan_amount,
   MIN(l.checkout_date) AS first_loan_date,
   MAX(l.checkout_date) AS last_loan_date
 FROM loans AS l
 JOIN merchants AS m
 ON l.merchant_id = m.merchant_id
 JOIN age_groups AS a
 ON l.user_id = a.user_id
 WHERE l.user_id != '0' 
 AND l.user_id IS NOT NULL
 AND m.category = 'Music'
 AND a.age_bracket IN ('25-34', '35-44')
 GROUP BY l.user_id, m.category, a.age_bracket
)

SELECT
 industry,
 age_bracket,
 COUNT(DISTINCT user_id) AS total_users,
 SUM(CASE WHEN loans_per_user > 1 THEN 1 ELSE 0 END) AS repeat_users,
 ROUND((SUM(CASE WHEN loans_per_user > 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT user_id)),2) AS repeat_user_percentage,
 ROUND(AVG(loans_per_user),2) AS avg_loans_per_user,
 ROUND(AVG(total_user_loan_amount),2) AS avg_total_loan_amount,
 ROUND(SUM(total_user_loan_amount),2) AS segment_total_value
FROM user_loan_counts
GROUP BY industry, age_bracket
ORDER BY repeat_user_percentage DESC, segment_total_value DESC;