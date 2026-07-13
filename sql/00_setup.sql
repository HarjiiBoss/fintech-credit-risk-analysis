-- Project 08: Fintech Credit Risk Analysis
-- Phase 0: Environment Setup
-- Tool: MySQL Workbench
-- Source: Kaggle "Give Me Some Credit" (cs-training.csv, 150,000 rows)

-- Step 1: Create schema
CREATE SCHEMA fintech_credit_risk;

-- Step 2: Set default schema
USE fintech_credit_risk;

-- Step 3: Create table matching the 11 dataset columns + target
CREATE TABLE borrowers (
    id                                      INT PRIMARY KEY,
    SeriousDlqin2yrs                        TINYINT,
    RevolvingUtilizationOfUnsecuredLines    DECIMAL(10,6),
    age                                     INT,
    NumberOfTime30_59DaysPastDueNotWorse    INT,
    DebtRatio                               DECIMAL(12,6),
    MonthlyIncome                           DECIMAL(12,2) NULL,
    NumberOfOpenCreditLinesAndLoans         INT,
    NumberOfTimes90DaysLate                 INT,
    NumberRealEstateLoansOrLines            INT,
    NumberOfTime60_89DaysPastDueNotWorse    INT,
    NumberOfDependents                      INT NULL
);

-- Step 4: Widen RevolvingUtilizationOfUnsecuredLines to DOUBLE
-- Reason: initial load failed with "Out of range value" — the raw dataset
-- contains extreme outlier values (max found: 50,708) that exceed
-- DECIMAL(10,6) precision. Loading raw values as-is rather than rejecting
-- them at insert time; outliers are handled explicitly in Phase 1 cleaning.
ALTER TABLE borrowers
MODIFY COLUMN RevolvingUtilizationOfUnsecuredLines DOUBLE;

-- Step 5: Load data
-- Loaded via Python/Pandas ETL pipeline (SQLAlchemy + mysql-connector-python)
-- in notebooks/01_cleaning_eda.ipynb — see that notebook for the load script.
-- (Table Data Import Wizard was attempted first but was too slow for
-- 150,000 rows; switched to Python ETL, consistent with Project 07.)

-- Step 6: Verify row count (should return 150000)
SELECT COUNT(*) FROM borrowers;