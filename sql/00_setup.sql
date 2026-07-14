/*============================================================
 Project : Fintech Credit Risk Analysis
 Phase   : 00 — Project Setup & Data Ingestion
 File    : 00_setup.sql
 Author  : HarjiiBoss
 Purpose : Create the project database and prepare the
           borrower dataset for analysis.
 Status  : COMPLETE
============================================================*/

/*============================================================
STEP 1 — CREATE DATABASE
============================================================*/

CREATE SCHEMA fintech_credit_risk;


/*============================================================
STEP 2 — SELECT DATABASE
============================================================*/

USE fintech_credit_risk;


/*============================================================
STEP 3 — CREATE BORROWERS TABLE

Creates the primary table containing all 11 dataset
features plus the target variable (SeriousDlqin2yrs).
============================================================*/

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


/*============================================================
STEP 4 — MODIFY COLUMN TYPE

Reason:
The initial data load failed because the raw dataset
contains extreme outlier values (maximum = 50,708),
which exceed the precision supported by DECIMAL(10,6).

The column is widened to DOUBLE so the original values
are preserved during ingestion.

Outlier detection and treatment are performed later
during Phase 1 (Data Cleaning & EDA).
============================================================*/

ALTER TABLE borrowers
MODIFY COLUMN RevolvingUtilizationOfUnsecuredLines DOUBLE;


/*============================================================
STEP 5 — LOAD DATA

The dataset was loaded using a Python ETL pipeline
(SQLAlchemy + mysql-connector-python) from the notebook:

    notebooks/01_cleaning_eda.ipynb

Reason:
MySQL Workbench's Table Data Import Wizard proved too
slow for the 150,000-row dataset, so a Python-based
pipeline was used instead for faster, reproducible
data ingestion.
============================================================*/


/*============================================================
STEP 6 — VERIFY DATA LOAD

Expected Result:
150,000 records successfully imported.
============================================================*/

SELECT COUNT(*) AS total_rows
FROM borrowers;


/*============================================================
Expected Output

+------------+
| total_rows |
+------------+
|     150000 |
+------------+
============================================================*/


/*============================================================
PHASE SUMMARY

✓ GitHub repository initialized
✓ Dataset downloaded from Kaggle
✓ Database schema created
✓ Borrowers table created
✓ Column datatype adjusted for outlier handling
✓ Dataset successfully loaded
✓ Row count verified (150,000)

Status : COMPLETE
============================================================*/
