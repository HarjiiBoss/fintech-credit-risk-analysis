/*============================================================
 Project : Fintech Credit Risk Analysis
 Phase   : 04 — Operational Inefficiency
 File    : 04_operational_inefficiency.sql
 Author  : HarjiiBoss
 Purpose : Evaluate operational risk indicators and
           identify lending process inefficiencies that
           contribute to higher default rates.
 Status  : COMPLETE
============================================================*/

USE fintech_credit_risk;

-- Query 1: Dependency ratio vs. income — identify borrowers who, in
-- hindsight, carried elevated approval risk. Dependency ratio proxied
-- as NumberOfDependents relative to income band (more dependents on
-- lower income = higher household financial strain).
SELECT
    CASE
        WHEN NumberOfDependents = 0 THEN '0 dependents'
        WHEN NumberOfDependents <= 2 THEN '1-2 dependents'
        WHEN NumberOfDependents <= 4 THEN '3-4 dependents'
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
    ROUND(SUM(SeriousDlqin2yrs) / COUNT(*) * 100, 2) AS delinquency_rate_pct
FROM borrowers
GROUP BY dependents_band, income_quartile
ORDER BY delinquency_rate_pct DESC
LIMIT 10;

-- Query 2: Credit line proliferation vs. delinquency — does having many
-- open lines/loans signal portfolio management inefficiency? Reuses the
-- validated bands from Pillar 2, cross-referenced with real estate loans
-- specifically (a distinct exposure type from revolving credit).
SELECT
    CASE
        WHEN NumberOfOpenCreditLinesAndLoans = 0 THEN '0 lines'
        WHEN NumberOfOpenCreditLinesAndLoans <= 3 THEN '1-3 lines'
        WHEN NumberOfOpenCreditLinesAndLoans <= 7 THEN '4-7 lines'
        WHEN NumberOfOpenCreditLinesAndLoans <= 15 THEN '8-15 lines'
        ELSE '16+ lines'
    END AS credit_lines_band,
    ROUND(AVG(NumberRealEstateLoansOrLines), 2) AS avg_real_estate_loans,
    COUNT(*) AS total_borrowers,
    SUM(SeriousDlqin2yrs) AS delinquent_borrowers,
    ROUND(SUM(SeriousDlqin2yrs) / COUNT(*) * 100, 2) AS delinquency_rate_pct
FROM borrowers
GROUP BY credit_lines_band
ORDER BY MIN(NumberOfOpenCreditLinesAndLoans);

-- Query 3: Approval calibration check — age and income distribution of
-- defaulters vs. non-defaulters. Are there approval-criteria gaps
-- visible in the data?
SELECT
    SeriousDlqin2yrs,
    ROUND(AVG(age), 1) AS avg_age,
    ROUND(AVG(MonthlyIncome), 2) AS avg_income,
    ROUND(AVG(NumberOfOpenCreditLinesAndLoans), 2) AS avg_open_lines,
    ROUND(AVG(NumberOfDependents), 2) AS avg_dependents
FROM borrowers
WHERE MonthlyIncome IS NOT NULL
GROUP BY SeriousDlqin2yrs;
