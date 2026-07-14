-- Project 08: Fintech Credit Risk Analysis
-- Phase 2: Pillar 1 — Borrower Default Risk
-- Purpose: Identify which borrowers show the highest risk of default
USE fintech_credit_risk;

-- Query 1: Delinquency rate by age band
SELECT
    CASE
        WHEN age BETWEEN 20 AND 29 THEN '20s'
        WHEN age BETWEEN 30 AND 39 THEN '30s'
        WHEN age BETWEEN 40 AND 49 THEN '40s'
        WHEN age BETWEEN 50 AND 59 THEN '50s'
        ELSE '60+'
    END AS age_band,
    COUNT(*) AS total_borrowers,
    SUM(SeriousDlqin2yrs) AS delinquent_borrowers,
    ROUND(SUM(SeriousDlqin2yrs) / COUNT(*) * 100, 2) AS delinquency_rate_pct
FROM borrowers
GROUP BY age_band
ORDER BY delinquency_rate_pct DESC;

-- Query 2: Delinquency rate by income quartile (excludes NULL income)
WITH income_quartiles AS (
    SELECT
        id,
        SeriousDlqin2yrs,
        MonthlyIncome,
        NTILE(4) OVER (ORDER BY MonthlyIncome) AS income_quartile
    FROM borrowers
    WHERE MonthlyIncome IS NOT NULL
)
SELECT
    income_quartile,
    COUNT(*) AS total_borrowers,
    ROUND(MIN(MonthlyIncome), 2) AS min_income,
    ROUND(MAX(MonthlyIncome), 2) AS max_income,
    SUM(SeriousDlqin2yrs) AS delinquent_borrowers,
    ROUND(SUM(SeriousDlqin2yrs) / COUNT(*) * 100, 2) AS delinquency_rate_pct
FROM income_quartiles
GROUP BY income_quartile
ORDER BY income_quartile;

-- Query 3: High-risk borrower profile (age + income combined)
-- Purpose: Test whether young + low-income compounds into a sharper risk segment
SELECT
    CASE
        WHEN age BETWEEN 20 AND 29 THEN '20s'
        WHEN age BETWEEN 30 AND 39 THEN '30s'
        WHEN age BETWEEN 40 AND 49 THEN '40s'
        WHEN age BETWEEN 50 AND 59 THEN '50s'
        ELSE '60+'
    END AS age_band,
    CASE
        WHEN MonthlyIncome <= 3400 THEN 'Q1 (lowest)'
        WHEN MonthlyIncome <= 5400 THEN 'Q2'
        WHEN MonthlyIncome <= 8249 THEN 'Q3'
        ELSE 'Q4 (highest)'
    END AS income_quartile,
    COUNT(*) AS total_borrowers,
    SUM(SeriousDlqin2yrs) AS delinquent_borrowers,
    ROUND(SUM(SeriousDlqin2yrs) / COUNT(*) * 100, 2) AS delinquency_rate_pct
FROM borrowers
WHERE MonthlyIncome IS NOT NULL
GROUP BY age_band, income_quartile
ORDER BY delinquency_rate_pct DESC;

-- Query 4: Delinquency Progression Analysis
-- Purpose: Among borrowers with 30-59 day delinquencies, what proportion
-- also show 90+ day delinquencies?
-- Note: This is an inferred cross-sectional relationship, not a true
-- time-based progression — the dataset contains no event timestamps.
SELECT
    COUNT(*) AS borrowers_with_30_59_dpd,
    SUM(CASE WHEN NumberOfTimes90DaysLate > 0 THEN 1 ELSE 0 END) AS also_90_plus_dpd,
    ROUND(
        SUM(CASE WHEN NumberOfTimes90DaysLate > 0 THEN 1 ELSE 0 END) / COUNT(*) * 100,
        2
    ) AS progression_rate_pct
FROM borrowers
WHERE NumberOfTime30_59DaysPastDueNotWorse > 0;

