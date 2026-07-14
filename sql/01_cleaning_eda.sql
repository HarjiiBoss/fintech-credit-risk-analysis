/*============================================================
 Project : Fintech Credit Risk Analysis
 Phase   : 01 — Data Cleaning & Exploratory Data Analysis
 File    : 01_cleaning_eda.sql
 Author  : Taofeek Salami
 Purpose : Assess data quality, identify missing values,
           detect duplicates and outliers, and establish
           the baseline dataset before analysis.
 Status  : COMPLETE
============================================================*/

USE fintech_credit_risk;


/*============================================================
SECTION 1 — MISSING VALUE AUDIT

Purpose:
Identify columns containing missing values before
cleaning and feature engineering.

Expected:
MonthlyIncome         → Missing values
NumberOfDependents   → Missing values
============================================================*/

SELECT
    SUM(CASE WHEN MonthlyIncome IS NULL THEN 1 ELSE 0 END) AS null_income,
    SUM(CASE WHEN NumberOfDependents IS NULL THEN 1 ELSE 0 END) AS null_dependents
FROM borrowers;


/*============================================================
SECTION 2 — DUPLICATE RECORD CHECK

Purpose:
Verify that each borrower ID is unique.

Expected:
No duplicate records returned.
============================================================*/

SELECT
    id,
    COUNT(*) AS occurrences
FROM borrowers
GROUP BY id
HAVING COUNT(*) > 1;


/*============================================================
SECTION 3 — TARGET VARIABLE DISTRIBUTION

Purpose:
Assess class balance for the target variable
(SeriousDlqin2yrs).

Expected:
Class imbalance between default and non-default borrowers.
============================================================*/

SELECT
    SeriousDlqin2yrs,
    COUNT(*) AS total,
    ROUND(
        COUNT(*) /
        (SELECT COUNT(*) FROM borrowers) * 100,
        2
    ) AS percentage
FROM borrowers
GROUP BY SeriousDlqin2yrs;


/*============================================================
SECTION 4 — AGE VALIDATION

Purpose:
Identify impossible age values.

Expected:
One borrower with age = 0.
============================================================*/

SELECT COUNT(*) AS invalid_age_records
FROM borrowers
WHERE age = 0;


/*============================================================
SECTION 5 — CREDIT UTILIZATION OUTLIERS

Purpose:
Identify borrowers whose revolving utilization
exceeds 100%.

These observations are retained and later evaluated
as potential behavioral risk indicators rather than
removed during cleaning.

Expected:
3,321 records.
============================================================*/

SELECT COUNT(*) AS extreme_utilization_records
FROM borrowers
WHERE RevolvingUtilizationOfUnsecuredLines > 1;


/*============================================================
PHASE SUMMARY

Data Quality Checks Completed

✓ Missing value audit
✓ Duplicate record validation
✓ Target class distribution assessed
✓ Invalid age records identified
✓ Extreme utilization values identified

Key Findings

• MonthlyIncome contains substantial missing values.
• NumberOfDependents contains minor missing values.
• No duplicate borrower IDs detected.
• Dataset is highly imbalanced toward non-default borrowers.
• One invalid age record exists (age = 0).
• Extreme credit utilization values were retained for
  behavioral risk analysis rather than removed.

Status : COMPLETE
============================================================*/
