/*============================================================
 Project : Fintech Credit Risk Analysis
 Phase   : 02 — Borrower Default Risk
 File    : 02_borrower_default_risk.sql
 Author  : Taofeek Salami
 Purpose : Segment borrowers by default risk using
           demographic and behavioral indicators to
           identify high-risk borrower profiles and
           early warning signals.
 Status  : COMPLETE
============================================================*/

USE fintech_credit_risk;


/*============================================================
SECTION 1 — DELINQUENCY RATE BY AGE BAND

Purpose:
Evaluate whether borrower age is associated with
higher default risk.

Expected:
Younger borrowers exhibit higher delinquency rates.
============================================================*/

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
    ROUND(
        SUM(SeriousDlqin2yrs) / COUNT(*) * 100,
        2
    ) AS delinquency_rate_pct
FROM borrowers
GROUP BY age_band
ORDER BY delinquency_rate_pct DESC;


/*============================================================
SECTION 2 — DELINQUENCY RATE BY INCOME QUARTILE

Purpose:
Assess the relationship between borrower income
and default risk.

Note:
Borrowers with missing income values are excluded.
============================================================*/

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
    ROUND(MIN(MonthlyIncome),2) AS min_income,
    ROUND(MAX(MonthlyIncome),2) AS max_income,
    SUM(SeriousDlqin2yrs) AS delinquent_borrowers,
    ROUND(
        SUM(SeriousDlqin2yrs) / COUNT(*) * 100,
        2
    ) AS delinquency_rate_pct
FROM income_quartiles
GROUP BY income_quartile
ORDER BY income_quartile;


/*============================================================
SECTION 3 — HIGH-RISK BORROWER PROFILE

Purpose:
Determine whether age and income jointly identify
higher-risk borrower segments.

Expected:
Young, lower-income borrowers are likely to exhibit
the highest default rates.
============================================================*/

SELECT
    CASE
        WHEN age BETWEEN 20 AND 29 THEN '20s'
        WHEN age BETWEEN 30 AND 39 THEN '30s'
        WHEN age BETWEEN 40 AND 49 THEN '40s'
        WHEN age BETWEEN 50 AND 59 THEN '50s'
        ELSE '60+'
    END AS age_band,

    CASE
        WHEN MonthlyIncome <= 3400 THEN 'Q1 (Lowest)'
        WHEN MonthlyIncome <= 5400 THEN 'Q2'
        WHEN MonthlyIncome <= 8249 THEN 'Q3'
        ELSE 'Q4 (Highest)'
    END AS income_quartile,

    COUNT(*) AS total_borrowers,
    SUM(SeriousDlqin2yrs) AS delinquent_borrowers,

    ROUND(
        SUM(SeriousDlqin2yrs) / COUNT(*) * 100,
        2
    ) AS delinquency_rate_pct

FROM borrowers
WHERE MonthlyIncome IS NOT NULL

GROUP BY
    age_band,
    income_quartile

ORDER BY delinquency_rate_pct DESC;


/*============================================================
SECTION 4 — DELINQUENCY PROGRESSION ANALYSIS

Purpose:
Estimate the proportion of borrowers with
30–59 day delinquencies who also exhibit
90+ day delinquencies.

Methodological Note:
This represents an inferred behavioral relationship
using cross-sectional data and should not be
interpreted as a true longitudinal cohort analysis.
============================================================*/

SELECT
    COUNT(*) AS borrowers_with_30_59_dpd,

    SUM(
        CASE
            WHEN NumberOfTimes90DaysLate > 0
            THEN 1
            ELSE 0
        END
    ) AS also_90_plus_dpd,

    ROUND(
        SUM(
            CASE
                WHEN NumberOfTimes90DaysLate > 0
                THEN 1
                ELSE 0
            END
        ) / COUNT(*) * 100,
        2
    ) AS progression_rate_pct

FROM borrowers

WHERE NumberOfTime30_59DaysPastDueNotWorse > 0;


/*============================================================
SECTION 5 — BASELINE COMPARISON

Purpose:
Compare the prevalence of 90+ day delinquency among
borrowers with no prior 30–59 day delinquency.

Used as a benchmark for Section 4.
============================================================*/

SELECT
    COUNT(*) AS borrowers_with_no_30_59_dpd,

    SUM(
        CASE
            WHEN NumberOfTimes90DaysLate > 0
            THEN 1
            ELSE 0
        END
    ) AS has_90_plus_dpd,

    ROUND(
        SUM(
            CASE
                WHEN NumberOfTimes90DaysLate > 0
                THEN 1
                ELSE 0
            END
        ) / COUNT(*) * 100,
        2
    ) AS rate_pct

FROM borrowers

WHERE NumberOfTime30_59DaysPastDueNotWorse = 0;


/*============================================================
PHASE SUMMARY

Borrower Risk Analyses Completed

✓ Age-based delinquency segmentation
✓ Income-based delinquency segmentation
✓ High-risk borrower profiling
✓ Delinquency progression analysis
✓ Baseline comparison

Key Outputs

• Delinquency rate by age band
• Delinquency rate by income quartile
• Highest-risk borrower segment
• Delinquency progression rate
• Baseline progression comparison

Status : COMPLETE
============================================================*/
