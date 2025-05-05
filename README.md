## BNPL Growth Segmentation Analysis

# Project Background
A leading Buy Now, Pay Later (BNPL) platform wants to identify business development opportunities across merchant industries and user demographics. The analysis evaluates segments based on conversion rates, customer loyalty, loan performance and risk metrics to determine which segments offer the highest growth potential while maintaining responsible lending practices. 

This analysis uses transaction data spanning 3 months (January-March 2016) across multiple merchant categories including Music, Apparel, Furniture and Jewelry. 

# Data Structure
The project uses three primary datasets: 

1. Funnel Table
    - merchant_id: Unique identifier for merchants (links to merchants table)
    - user_id: Unique identifier for users
    - checkout_id: Unique identifier for given checkout (links to loans table)
    - action: Name of the event (Checkout Loaded = checkout page was loaded, Loan Terms Run: user applied for a loan, Loan Terma Approved = User was approved for a loan, Checkout Completes = User took the loan for which they were approved)
    - action_date: Date when the event happened

2. Loans Table
    - merchant_id: Unique identifier for merchants
    - user_id: Unique identifier for users
    - checkout_id: Unique identifier for given checkout
    - checkout_date: Date when checkout was completed
    - loan_amount: Total amount of the loan
    - down_payment_amount: Total down payment amount
    - user_first_capture: First date the user took out a loan with Affirm
    - user_dob_year: Year the user was born
    - loan_length_months: Length of the loan in months
    - mdr: Merchant discount rate
    - apr: Annual percentage rate
    - fico_score: Score that measures a user's risk, higher score means less risk
    - loan_return_percentage: The return the business saw on the loan

3. Merchants Table
    - merchant_id: Unique identifier for merchants
    - merchant_name: Name of the merchant
    - category: The merchant's industry

# Executive Summary
Analysis revealed that the Music industry for ages 25-44 represents the highest-value opportunity for business development focus. This segments shows: 

- Balanced Performance: Combination of strong conversion rates (5.13% for ages 25-34) and exceptional customer loyalty (approx 20% returning users)
- Lower Risk Profile: Above-average loan return percentages (almost 7% for ages-34) and healthy FICO scores in the Near Prime category
- Growth Potential: Combined loan volume of approx 5,700 loans with room for expansion

Analysis also identified and resolved data quality issues. For further information on data quality issues, please see here. 

# Recommendations
1. Implement Staggered Business Development Approach
    - Phase 1: Focus on Music Industry ages 25-34 to capitalize on the 5.13% conversion rate
    - Phase 2: Expand to ages 35-44 to leverage superior loyalty (20.68% returning users)
    - Apply learnings from the first phase to optimize approach for the second phase

2. Execute Targeted Experimentation
    - Ages 25-34: Test extended loan teams (12-14 months) to increase average order value
    - Ages 35-44: Test reduced APR offerings (10-20%) to improve conversion rates
    - Maintain risk controls through down payment requirements 
    - Determine experiment duration based on expertise and business goals

3. Establish Measurement Framework
    - Primary metrics: Average order volume (ages 25-34), conversion rate (ages 35-44)
    - Secondary metrics: Return rates, repeat usage patterns, FICO score distribution
    - Cross-functional collaboration across Product, Marketing and Risk teams

4. Monitoring and Optimization
    - Track segment performance relative to others
    - Adjust strategy based on performance data
    - Consider expansion to similar segments after validation
