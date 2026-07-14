# Phase 0 — Project Setup & Data Ingestion

**Date:** 2026-07-13  
**Implementation Summary**

## Objective

Establish the analytical environment, ingest the raw dataset into MySQL, validate data integrity, and prepare the project infrastructure for exploratory analysis.

## Steps Completed
1. GitHub repo `fintech-credit-risk-analysis` created with folder structure
   (data/, sql/, notebooks/, excel/, tableau/, outputs/, docs/)
2. Dataset acquired: Kaggle "Give Me Some Credit" (`cs-training.csv`, 150,000
   rows) → `data/raw/`
3. MySQL schema `fintech_credit_risk` created; `borrowers` table created
   matching the 11 dataset columns + target (`sql/00_setup.sql`)
4. Schema fix applied mid-load: `RevolvingUtilizationOfUnsecuredLines`
   widened from `DECIMAL(10,6)` to `DOUBLE` — initial load failed with
   "Out of range value" because raw data contains extreme outlier values
   (max found: 50,708), which exceeded the original column precision.
5. Data loaded via Python/Pandas ETL (SQLAlchemy + mysql-connector-python)
   in `notebooks/01_cleaning_eda.ipynb` — Workbench's Table Data Import
   Wizard was attempted first but was too slow for 150,000 rows.
6. Data Integrity Check
   Expected rows: 150,000
   Loaded rows: 150,000
   Status: Passed ✅

## Implementation Challenges
- `MySQLInterfaceError: Out of range value` at row 3670 — root cause was
  column precision, not code. Resolved via Step 4 above.
- `IntegrityError: Duplicate entry '1' for PRIMARY key` — caused by
  re-running `to_sql(..., if_exists='append')` after a partial prior load.
  Resolved with `TRUNCATE TABLE borrowers` before a clean single reload.

## Security Note
DB credentials were initially hardcoded in the notebook. Fixed in Phase 1 —
see docs/security_notes.md for full detail.
