/*============================================================
 Project : Fintech Credit Risk Analysis
 Phase   : 04 — Operational Inefficiency
 File    : 04_operational_inefficiency.sql
 Author  : Taofeek Salami
 Purpose : Evaluate operational risk indicators and
           identify lending process inefficiencies that
           contribute to higher default rates.
 Status  : COMPLETE
============================================================*/

USE fintech_credit_risk;

-- ============================================================
-- Query 1: Dependency Burden Analysis
-- Objective:
-- Evaluate whether household dependency burden, combined with
-- borrower income level, is associated with elevated default
-- risk and potential approval-process weaknesses.
--
-- Note:
-- Dependency burden is approximated using the number of
-- dependents within each income quartile because the dataset
-- contains no household expenditure information.
-- ============================================================

SELECT
    CASE
        WHEN NumberOfDependents = 0 THEN '0 dependents'
        WHEN NumberOfDependents <= 2 THEN '1–2 dependents'
        WHEN NumberOfDependents <= 4 THEN '3–4 dependents'
        ELSE '5+ dependents'
    END AS dependents_band,
    CASE
        WHEN MonthlyIncome IS NULL THEN 'Income Unknown'
        WHEN MonthlyIncome <= 3400 THEN 'Q1 (lowest)'
        WHEN MonthlyIncome <= 5400 THEN 'Q2'
        WHEN MonthlyIncome <= 8249 THEN 'Q3'
        ELSE 'Q4 (highest)'
    END AS income_quartile,
    COUNT(*) AS total_borrowers,
    SUM(SeriousDlqin2yrs) AS delinquent_borrowers,
    ROUND(
        SUM(SeriousDlqin2yrs) / COUNT(*) * 100,
        2
    ) AS delinquency_rate_pct
FROM borrowers
GROUP BY dependents_band, income_quartile
ORDER BY delinquency_rate_pct DESC
LIMIT 10;

-- ============================================================
-- Query 2: Credit Line Proliferation Analysis
-- Objective:
-- Examine whether borrowers with a greater number of open
-- credit facilities exhibit higher default rates.
--
-- Additional Context:
-- Average real estate loans are included to distinguish
-- revolving credit behaviour from longer-term borrowing.
-- ============================================================

SELECT
    CASE
        WHEN NumberOfOpenCreditLinesAndLoans = 0 THEN '0 lines'
        WHEN NumberOfOpenCreditLinesAndLoans <= 3 THEN '1–3 lines'
        WHEN NumberOfOpenCreditLinesAndLoans <= 7 THEN '4–7 lines'
        WHEN NumberOfOpenCreditLinesAndLoans <= 15 THEN '8–15 lines'
        ELSE '16+ lines'
    END AS credit_lines_band,
    ROUND(
        AVG(NumberRealEstateLoansOrLines),
        2
    ) AS avg_real_estate_loans,
    COUNT(*) AS total_borrowers,
    SUM(SeriousDlqin2yrs) AS delinquent_borrowers,
    ROUND(
        SUM(SeriousDlqin2yrs) / COUNT(*) * 100,
        2
    ) AS delinquency_rate_pct
FROM borrowers
GROUP BY credit_lines_band
ORDER BY MIN(NumberOfOpenCreditLinesAndLoans);

-- ============================================================
-- Query 3: Approval Calibration Analysis
-- Objective:
-- Compare average borrower characteristics between
-- defaulters and non-defaulters to identify potential
-- approval-policy gaps.
--
-- Note:
-- Records with missing MonthlyIncome are excluded to ensure
-- meaningful income comparisons.
-- ============================================================

SELECT
    SeriousDlqin2yrs,
    ROUND(AVG(age), 1) AS avg_age,
    ROUND(AVG(MonthlyIncome), 2) AS avg_income,
    ROUND(AVG(NumberOfOpenCreditLinesAndLoans), 2)
        AS avg_open_credit_lines,
    ROUND(AVG(NumberOfDependents), 2)
        AS avg_dependents
FROM borrowers
WHERE MonthlyIncome IS NOT NULL
GROUP BY SeriousDlqin2yrs;

-- ============================================================
-- End of Phase 04
-- Operational Inefficiency
--
-- Completion Checklist
-- [✓] Dependency burden analysis
-- [✓] Credit line proliferation analysis
-- [✓] Approval calibration assessment
-- [✓] Operational risk indicators identified
--
-- Output:
-- Operational risk findings prepared for Phase 04
-- documentation, Excel dashboard, and Tableau
-- visualization.
-- ============================================================
