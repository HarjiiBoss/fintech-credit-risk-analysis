-- Project 08: Fintech Credit Risk Analysis
-- Phase 1A: Exploratory Queries
-- Purpose: Understand data quality and baseline metrics before analysis
USE fintech_credit_risk;

-- Query 1: NULL audit — known gaps are MonthlyIncome and NumberOfDependents
SELECT
    SUM(CASE WHEN MonthlyIncome IS NULL THEN 1 ELSE 0 END) AS null_income,
    SUM(CASE WHEN NumberOfDependents IS NULL THEN 1 ELSE 0 END) AS null_dependents
FROM borrowers;

-- Query 2: Duplicate check (should return empty)
SELECT id, COUNT(*) AS occurrences
FROM borrowers
GROUP BY id
HAVING COUNT(*) > 1;

-- Query 3: Target variable balance (SeriousDlqin2yrs)
SELECT
    SeriousDlqin2yrs,
    COUNT(*) AS total,
    ROUND(COUNT(*) / (SELECT COUNT(*) FROM borrowers) * 100, 2) AS pct
FROM borrowers
GROUP BY SeriousDlqin2yrs;

-- Query 4: Outlier scan — age = 0
SELECT COUNT(*) FROM borrowers WHERE age = 0;

-- Query 5: Outlier scan — utilization > 1 (already found 3,321 above, confirming here for the record)
SELECT COUNT(*) FROM borrowers WHERE RevolvingUtilizationOfUnsecuredLines > 1;