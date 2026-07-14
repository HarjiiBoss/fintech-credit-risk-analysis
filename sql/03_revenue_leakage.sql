/*============================================================
 Project : Fintech Credit Risk Analysis
 Phase   : 03 — Revenue Leakage
 File    : 03_revenue_leakage.sql
 Author  : HarjiiBoss
 Purpose : Identify financially overexposed borrower
           segments and estimate relative financial
           exposure across the lending portfolio.
 Status  : COMPLETE
============================================================*/

USE fintech_credit_risk;

-- Query 1: Credit utilization vs. income — flag borrowers exceeding a
-- defined repayment-capacity threshold. Using utilization > 0.8 (80%) as
-- the threshold, a common industry convention for "elevated risk" —
-- documented here as an explicit assumption, not a discovered fact.
SELECT
    CASE
        WHEN RevolvingUtilizationOfUnsecuredLines > 1 THEN 'Invalid (>100%, flagged separately)'
        WHEN RevolvingUtilizationOfUnsecuredLines >= 0.8 THEN 'High (80-100%)'
        WHEN RevolvingUtilizationOfUnsecuredLines >= 0.5 THEN 'Elevated (50-80%)'
        WHEN RevolvingUtilizationOfUnsecuredLines >= 0.3 THEN 'Moderate (30-50%)'
        ELSE 'Low (<30%)'
    END AS utilization_band,
    COUNT(*) AS total_borrowers,
    SUM(SeriousDlqin2yrs) AS delinquent_borrowers,
    ROUND(SUM(SeriousDlqin2yrs) / COUNT(*) * 100, 2) AS delinquency_rate_pct
FROM borrowers
GROUP BY utilization_band
ORDER BY delinquency_rate_pct DESC;

-- Query 2: Debt ratio distribution — identify structurally overexposed
-- segments. Excludes extreme outliers (>10) which are almost certainly
-- data entry errors (a debt ratio of 1000+ is not economically meaningful).
SELECT
    CASE
        WHEN DebtRatio > 10 THEN 'Extreme (>10, likely data error)'
        WHEN DebtRatio >= 1 THEN 'Overexposed (100%+)'
        WHEN DebtRatio >= 0.5 THEN 'High (50-100%)'
        WHEN DebtRatio >= 0.3 THEN 'Moderate (30-50%)'
        ELSE 'Low (<30%)'
    END AS debt_ratio_band,
    COUNT(*) AS total_borrowers,
    SUM(SeriousDlqin2yrs) AS delinquent_borrowers,
    ROUND(SUM(SeriousDlqin2yrs) / COUNT(*) * 100, 2) AS delinquency_rate_pct
FROM borrowers
GROUP BY debt_ratio_band
ORDER BY delinquency_rate_pct DESC;

-- Test: does "extreme" debt ratio overlap with missing income?
SELECT
    CASE WHEN MonthlyIncome IS NULL THEN 'Income Missing' ELSE 'Income Present' END AS income_status,
    COUNT(*) AS total,
    SUM(CASE WHEN DebtRatio > 10 THEN 1 ELSE 0 END) AS extreme_debtratio_count,
    ROUND(SUM(CASE WHEN DebtRatio > 10 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS pct_extreme
FROM borrowers
GROUP BY income_status;

-- Query 3: Revolving credit line usage patterns
SELECT
    CASE
        WHEN NumberOfOpenCreditLinesAndLoans = 0 THEN '0 lines'
        WHEN NumberOfOpenCreditLinesAndLoans <= 3 THEN '1-3 lines'
        WHEN NumberOfOpenCreditLinesAndLoans <= 7 THEN '4-7 lines'
        WHEN NumberOfOpenCreditLinesAndLoans <= 15 THEN '8-15 lines'
        ELSE '16+ lines'
    END AS credit_lines_band,
    COUNT(*) AS total_borrowers,
    ROUND(AVG(CASE WHEN RevolvingUtilizationOfUnsecuredLines <= 1 THEN RevolvingUtilizationOfUnsecuredLines END), 3) AS avg_utilization_excl_outliers,
    SUM(SeriousDlqin2yrs) AS delinquent_borrowers,
    ROUND(SUM(SeriousDlqin2yrs) / COUNT(*) * 100, 2) AS delinquency_rate_pct
FROM borrowers
GROUP BY credit_lines_band
ORDER BY MIN(NumberOfOpenCreditLinesAndLoans);

-- Query 4: Sanity check — borrowers with 0 open credit lines showed avg
-- utilization of exactly 1.00, which is illogical (no open lines means
-- nothing to utilize). Investigating whether this is a clustered
-- placeholder/default value rather than genuine utilization behavior.
SELECT RevolvingUtilizationOfUnsecuredLines, COUNT(*)
FROM borrowers
WHERE NumberOfOpenCreditLinesAndLoans = 0
GROUP BY RevolvingUtilizationOfUnsecuredLines
ORDER BY COUNT(*) DESC
LIMIT 5;
