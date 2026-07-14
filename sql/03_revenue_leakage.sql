/*============================================================
 Project : Fintech Credit Risk Analysis
 Phase   : 03 — Revenue Leakage
 File    : 03_revenue_leakage.sql
 Author  : Taofeek Salami
 Purpose : Identify financially overexposed borrower
           segments and estimate relative financial
           exposure across the lending portfolio.
 Status  : COMPLETE
============================================================*/

USE fintech_credit_risk;

-- ============================================================
-- Query 1: Credit Utilization Analysis
-- Objective:
-- Segment borrowers by revolving credit utilization to identify
-- repayment-capacity risk and potential revenue leakage.
--
-- Assumption:
-- Utilization >= 80% is treated as elevated risk based on
-- common lending industry practice. This threshold is an
-- analytical assumption, not a property of the dataset.
-- ============================================================

SELECT
    CASE
        WHEN RevolvingUtilizationOfUnsecuredLines > 1
            THEN 'Invalid (>100%, flagged separately)'
        WHEN RevolvingUtilizationOfUnsecuredLines >= 0.8
            THEN 'High (80–100%)'
        WHEN RevolvingUtilizationOfUnsecuredLines >= 0.5
            THEN 'Elevated (50–80%)'
        WHEN RevolvingUtilizationOfUnsecuredLines >= 0.3
            THEN 'Moderate (30–50%)'
        ELSE 'Low (<30%)'
    END AS utilization_band,
    COUNT(*) AS total_borrowers,
    SUM(SeriousDlqin2yrs) AS delinquent_borrowers,
    ROUND(SUM(SeriousDlqin2yrs) / COUNT(*) * 100, 2)
        AS delinquency_rate_pct
FROM borrowers
GROUP BY utilization_band
ORDER BY delinquency_rate_pct DESC;

-- ============================================================
-- Query 2: Debt Ratio Distribution
-- Objective:
-- Identify structurally overexposed borrower segments using
-- debt-to-income ratio.
--
-- Note:
-- DebtRatio > 10 is treated as a probable data-quality issue
-- and isolated for investigation rather than interpreted as
-- genuine financial behaviour.
-- ============================================================

SELECT
    CASE
        WHEN DebtRatio > 10
            THEN 'Extreme (>10, likely data error)'
        WHEN DebtRatio >= 1
            THEN 'Overexposed (100%+)'
        WHEN DebtRatio >= 0.5
            THEN 'High (50–100%)'
        WHEN DebtRatio >= 0.3
            THEN 'Moderate (30–50%)'
        ELSE 'Low (<30%)'
    END AS debt_ratio_band,
    COUNT(*) AS total_borrowers,
    SUM(SeriousDlqin2yrs) AS delinquent_borrowers,
    ROUND(SUM(SeriousDlqin2yrs) / COUNT(*) * 100, 2)
        AS delinquency_rate_pct
FROM borrowers
GROUP BY debt_ratio_band
ORDER BY delinquency_rate_pct DESC;

-- ============================================================
-- Validation Query
-- Objective:
-- Determine whether extreme DebtRatio values are primarily
-- associated with missing MonthlyIncome.
-- ============================================================

SELECT
    CASE
        WHEN MonthlyIncome IS NULL
            THEN 'Income Missing'
        ELSE 'Income Present'
    END AS income_status,
    COUNT(*) AS total_borrowers,
    SUM(CASE WHEN DebtRatio > 10 THEN 1 ELSE 0 END)
        AS extreme_debtratio_count,
    ROUND(
        SUM(CASE WHEN DebtRatio > 10 THEN 1 ELSE 0 END)
        / COUNT(*) * 100,
        2
    ) AS pct_extreme
FROM borrowers
GROUP BY income_status;

-- ============================================================
-- Query 3: Open Credit Line Analysis
-- Objective:
-- Examine whether the number of active credit lines relates
-- to utilization behaviour and borrower default risk.
-- ============================================================

SELECT
    CASE
        WHEN NumberOfOpenCreditLinesAndLoans = 0
            THEN '0 lines'
        WHEN NumberOfOpenCreditLinesAndLoans <= 3
            THEN '1–3 lines'
        WHEN NumberOfOpenCreditLinesAndLoans <= 7
            THEN '4–7 lines'
        WHEN NumberOfOpenCreditLinesAndLoans <= 15
            THEN '8–15 lines'
        ELSE '16+ lines'
    END AS credit_lines_band,
    COUNT(*) AS total_borrowers,
    ROUND(
        AVG(
            CASE
                WHEN RevolvingUtilizationOfUnsecuredLines <= 1
                THEN RevolvingUtilizationOfUnsecuredLines
            END
        ),
        3
    ) AS avg_utilization_excl_outliers,
    SUM(SeriousDlqin2yrs) AS delinquent_borrowers,
    ROUND(SUM(SeriousDlqin2yrs) / COUNT(*) * 100, 2)
        AS delinquency_rate_pct
FROM borrowers
GROUP BY credit_lines_band
ORDER BY MIN(NumberOfOpenCreditLinesAndLoans);

-- ============================================================
-- Validation Query
-- Objective:
-- Investigate an unexpected pattern where borrowers with
-- zero open credit lines reported utilization values of 1.00.
--
-- Purpose:
-- Assess whether this reflects placeholder/default values or
-- a genuine characteristic of the source dataset.
-- ============================================================

SELECT
    RevolvingUtilizationOfUnsecuredLines,
    COUNT(*) AS occurrences
FROM borrowers
WHERE NumberOfOpenCreditLinesAndLoans = 0
GROUP BY RevolvingUtilizationOfUnsecuredLines
ORDER BY occurrences DESC
LIMIT 5;

-- ============================================================
-- End of Phase 03
-- Revenue Leakage
--
-- Completion Checklist
-- [✓] Credit utilization segmentation
-- [✓] Debt ratio distribution analysis
-- [✓] Missing-income validation
-- [✓] Credit line usage analysis
-- [✓] Data-quality validation completed
--
-- Output:
-- Revenue leakage segmentation and financial exposure
-- indicators prepared for Phase 03 documentation,
-- Excel dashboard, and Tableau visualization.
-- ============================================================
