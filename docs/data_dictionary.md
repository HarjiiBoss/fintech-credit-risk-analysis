# Data Dictionary — Fintech Credit Risk Analysis

**Project:** Fintech Credit Risk Analysis  
**Dataset:** Kaggle — *Give Me Some Credit* (`cs-training.csv`)  
**Author:** Taofeek Salami  
**Current Dataset Version:** `cs_training_exposure_scored.csv`

---

# Overview

This document defines every variable used throughout the project, including the original dataset fields and the engineered features created during analysis.

Although the source dataset originates from a U.S. consumer credit dataset, this project applies its **behavior-based lending signals**—such as credit utilization, delinquency history, debt burden, and income—as a **bureau-independent proof of concept** for Nigeria's digital lending ecosystem.

---

# Methodological Note

Monetary variables (such as `MonthlyIncome`) are denominated in **U.S. dollars** because they originate from the original Kaggle dataset.

This project does **not** interpret these values as Nigerian income levels. Instead, the analysis focuses on **behavioral relationships** that are transferable across lending markets regardless of currency.

---

# Original Dataset Variables

| Column | Data Type | Business Meaning | Project Notes |
|----------|-----------|-----------------|---------------|
| `id` | INT | Unique borrower identifier | Renamed from the unnamed index column in the raw dataset. Used only as a unique key. |
| `SeriousDlqin2yrs` | TINYINT | Indicates whether the borrower became **90+ days delinquent within the following two years** | Binary target variable (0 = No, 1 = Yes). Positive class represents **6.68%** of the dataset. |
| `RevolvingUtilizationOfUnsecuredLines` | DOUBLE | Percentage of available revolving unsecured credit currently being used | Values above 1 (>100%) were retained and flagged because they proved highly predictive of default. |
| `age` | INT | Borrower's age in years | One invalid record (`age = 0`) removed during Phase 1. |
| `NumberOfTime30_59DaysPastDueNotWorse` | INT | Number of occasions borrower became **30–59 days past due** | Used as one component of behavioral risk scoring. |
| `DebtRatio` | DECIMAL | Monthly debt obligations divided by monthly gross income | Extreme values were primarily caused by missing income rather than excessive leverage. |
| `MonthlyIncome` | DECIMAL (Nullable) | Borrower's reported monthly income | 19.82% missing. Preserved using a missing-value indicator instead of imputation. |
| `NumberOfOpenCreditLinesAndLoans` | INT | Number of active credit lines and loans | Used to evaluate borrower credit exposure. |
| `NumberOfTimes90DaysLate` | INT | Number of occasions borrower became **90+ days delinquent** | Strongest historical delinquency indicator. |
| `NumberRealEstateLoansOrLines` | INT | Number of mortgage or real estate loans | Represents secured lending exposure. |
| `NumberOfTime60_89DaysPastDueNotWorse` | INT | Number of occasions borrower became **60–89 days delinquent** | Combined with other delinquency variables for behavioral scoring. |
| `NumberOfDependents` | INT (Nullable) | Number of financial dependents supported by the borrower | 2.62% missing. Imputed using the mode (0). |

---

# Engineered Variables

The following variables were created during the analytical workflow and exist only in the processed datasets.

| Variable | Type | Description |
|-----------|------|-------------|
| `income_missing` | Boolean | Indicates whether MonthlyIncome was missing in the original dataset. |
| `utilization_extreme_flag` | Boolean | Flags utilization values greater than 100%; identified as a strong early-warning signal. |
| `delinquency_data_error_flag` | Boolean | Flags known placeholder values (96 and 98) in delinquency fields. |
| `frequency_score` | Integer (0–3) | Frequency of historical delinquency events across all delinquency variables. |
| `recency_proxy_score` | Integer (0–3) | Proxy for repayment recency using the most severe delinquency bucket reached. |
| `severity_score` | Integer (0–3) | Financial stress score derived from Debt Ratio quartiles. |
| `behavioral_risk_score` | Integer | Composite behavioral credit risk score. |
| `risk_tier` | Category | Final behavioral borrower classification (Low, Medium, High, Critical). |
| `utilization_score` | Integer (0–3) | Exposure score derived from revolving credit utilization. |
| `debt_ratio_score` | Integer (0–3) | Exposure score derived from Debt Ratio for borrowers with valid income only. |
| `exposure_index` | Integer | Composite financial exposure score ranging from 0–6. |
| `exposure_tier` | Category | Final exposure classification (Low, Moderate, High, Critical, Indeterminate). |

---

# Data Quality Summary

| Data Quality Issue | Treatment |
|--------------------|-----------|
| Invalid age (`age = 0`) | Removed |
| Missing MonthlyIncome | Preserved using `income_missing`; no imputation performed |
| Missing NumberOfDependents | Imputed using mode (0) |
| Utilization greater than 100% | Retained and flagged |
| Extreme DebtRatio values | Investigated and linked primarily to missing income |
| Placeholder delinquency values (96 & 98) | Flagged and excluded from behavioral scoring |

---

# Data Lineage

The analytical dataset evolves through four major processing stages.

| Dataset | Generated During | Description |
|----------|------------------|-------------|
| `cs-training.csv` | Phase 0 | Original Kaggle dataset |
| `cs_training_cleaned.csv` | Phase 1 | Cleaned dataset after quality checks and preprocessing |
| `cs_training_risk_scored.csv` | Phase 2 | Behavioral risk scoring added |
| `cs_training_exposure_scored.csv` | Phase 3 | Final analytical dataset used for Tableau dashboards |

---

# Dataset Versions

| Version | Phase | Primary Purpose |
|----------|-------|-----------------|
| Raw Dataset | Phase 0 | Original source data |
| Cleaned Dataset | Phase 1 | Data cleaning and exploratory analysis |
| Risk-Scored Dataset | Phase 2 | Borrower behavioral segmentation |
| Exposure-Scored Dataset | Phase 3 | Portfolio exposure analysis and dashboard source |

---

# Primary Dataset for Reporting

The Tableau dashboards use **one master analytical dataset**:

```
data/processed/cs_training_exposure_scored.csv
```

This dataset contains all original variables, engineered features, behavioral risk scores, exposure metrics, and classification tiers required for reporting.
