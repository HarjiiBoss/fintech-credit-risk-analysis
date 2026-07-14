# Data Dictionary — Fintech Credit Risk Analysis

**Project:** Fintech Credit Risk Analysis  
**Dataset:** Kaggle — *Give Me Some Credit* (`cs-training.csv`)  
**Rows:** 149,999 (after Phase 1 cleaning)  
**Author:** Taofeek Salami

---

## Overview

This document describes every variable used throughout the project, including both the original dataset fields and the engineered features created during analysis.

Although the source dataset originates from a U.S. consumer credit dataset, this project applies its **behavior-based lending signals** (credit utilization, delinquency history, debt burden, and income) as a **bureau-independent proof of concept** for Nigeria's digital lending ecosystem.

> **Methodological Note**
>
> Monetary values (such as `MonthlyIncome`) are denominated in U.S. dollars because they originate from the Kaggle dataset. The project does **not** interpret these figures as Nigerian income levels. Instead, the analysis focuses on behavioral relationships that are transferable across lending markets.

---

# Original Dataset Variables

| Column | Data Type | Business Meaning | Project Notes |
|----------|-----------|-----------------|---------------|
| `id` | INT | Unique borrower identifier | Renamed from the unnamed index column in the raw dataset. Used only as a unique key. |
| `SeriousDlqin2yrs` | TINYINT | Target variable indicating whether the borrower became **90+ days delinquent within the following two years** | Binary outcome (0 = No, 1 = Yes). Positive class represents **6.68%** of the dataset. |
| `RevolvingUtilizationOfUnsecuredLines` | DOUBLE | Percentage of available revolving unsecured credit currently being used | Values normally range from 0–1. Extreme values (>1) were retained and flagged rather than removed because they proved highly predictive of default. |
| `age` | INT | Borrower's age (years) | One invalid record (`age = 0`) removed during cleaning. |
| `NumberOfTime30_59DaysPastDueNotWorse` | INT | Number of occasions the borrower was between **30–59 days past due** | One of three delinquency history variables used in behavioral risk scoring. |
| `DebtRatio` | DECIMAL | Monthly debt obligations divided by monthly gross income | Extremely high values largely resulted from missing income rather than true leverage. Treated cautiously in Phase 3. |
| `MonthlyIncome` | DECIMAL (Nullable) | Reported monthly income | 19.82% missing. Missingness preserved via a Boolean flag rather than imputation. |
| `NumberOfOpenCreditLinesAndLoans` | INT | Total active credit accounts (credit cards, personal loans, etc.) | Used to assess borrower credit exposure and portfolio complexity. |
| `NumberOfTimes90DaysLate` | INT | Number of occasions borrower became **90+ days delinquent** | Strongest historical delinquency indicator. |
| `NumberRealEstateLoansOrLines` | INT | Number of mortgage or real estate loan accounts | Represents secured lending exposure. |
| `NumberOfTime60_89DaysPastDueNotWorse` | INT | Number of occasions borrower was **60–89 days delinquent** | Combined with other delinquency variables for behavioral scoring. |
| `NumberOfDependents` | INT (Nullable) | Number of financial dependents supported by the borrower | 2.62% missing. Imputed using the mode (0). |

---

# Engineered Variables

The following variables were created during analysis and exist only in the processed datasets.

| Variable | Type | Purpose |
|-----------|------|---------|
| `income_missing` | Boolean | Indicates whether `MonthlyIncome` was originally missing. Preserved to avoid introducing artificial income values. |
| `utilization_extreme_flag` | Boolean | Flags borrowers with utilization greater than 100%. Identified as a major early-warning signal (37.25% default rate). |
| `delinquency_data_error_flag` | Boolean | Flags records containing known placeholder values (96 or 98) across delinquency variables. These were excluded from behavioral scoring and automatically classified as Critical risk. |
| `frequency_score` | Integer (0–3) | Measures frequency of historical delinquency events across all delinquency variables. |
| `recency_proxy_score` | Integer (0–3) | Proxy for recent repayment behavior based on the most severe delinquency bucket reached. |
| `severity_score` | Integer (0–3) | Represents financial stress using Debt Ratio quartiles. |
| `behavioral_risk_score` | Integer | Composite borrower risk score combining frequency, recency proxy, and severity. |
| `risk_tier` | Category | Final behavioral classification: Low, Medium, High, Critical. |
| `utilization_score` | Integer (0–3) | Exposure score derived from revolving credit utilization. |
| `debt_ratio_score` | Integer (0–3) | Exposure score derived from Debt Ratio (valid income only). |
| `exposure_index` | Integer | Relative financial exposure score (0–6). |
| `exposure_tier` | Category | Final exposure classification: Low, Moderate, High, Critical, or Indeterminate. |

---

# Data Quality Summary

| Issue | Treatment |
|--------|-----------|
| Age equal to 0 | Removed (1 record) |
| Missing Monthly Income | Preserved using `income_missing`; no imputation performed |
| Missing Number of Dependents | Imputed using mode (0) |
| Credit Utilization greater than 100% | Retained and flagged |
| Debt Ratio extreme values | Investigated; linked primarily to missing income |
| Placeholder delinquency values (96 & 98) | Flagged and excluded from behavioral scoring |

---

# Project Glossary

Understanding these terms will help interpret the analyses and findings throughout the project.

| Term | Definition |
|------|------------|
| **Alternative Data** | Non-traditional borrower information used instead of credit bureau history, such as repayment behaviour, transaction activity, or account usage. |
| **Behavioral Risk Scoring** | Risk assessment based on observed borrower behaviour rather than demographic characteristics. |
| **Borrower Segmentation** | Grouping borrowers into meaningful categories according to their risk characteristics. |
| **Credit Bureau** | An organization that collects and maintains borrowers' credit histories for lenders. |
| **Credit Utilization** | Percentage of available revolving credit currently in use. Higher utilization generally indicates greater financial stress. |
| **Cross-Sectional Dataset** | A dataset captured at a single point in time rather than tracking borrowers over multiple periods. |
| **Debt Ratio** | Monthly debt obligations divided by monthly income. Used as an indicator of repayment capacity. |
| **Default** | Failure to meet agreed repayment obligations. In this project, represented by becoming **90+ days past due** within two years. |
| **Delinquency** | A missed or late loan payment. Longer delinquency periods generally indicate higher credit risk. |
| **Early Warning Signal** | A measurable borrower characteristic that predicts future default before it occurs. |
| **Exposure Index** | A custom project metric ranking borrowers according to relative financial exposure when exact loan balances are unavailable. |
| **Exposure Tier** | Categorization of borrowers into Low, Moderate, High, Critical, or Indeterminate financial exposure groups. |
| **Feature Engineering** | Creating new analytical variables from existing data to improve insight or model performance. |
| **Imbalanced Dataset** | A dataset where one outcome class is much more common than the other. Here, only 6.68% of borrowers defaulted. |
| **Open Credit Lines** | Number of active credit accounts currently available to a borrower. |
| **Portfolio Risk** | Aggregate risk carried across all borrowers within a lending portfolio. |
| **Proxy Variable** | A substitute measure used when the desired variable is unavailable (for example, delinquency buckets used as a proxy for repayment recency). |
| **Revolving Credit** | Credit facilities that can be repeatedly borrowed and repaid, such as credit cards or overdrafts. |
| **Risk Tier** | Final behavioral borrower classification produced by the composite risk scoring methodology. |
| **Thin-File Borrower** | A borrower with little or no traditional credit history, making risk assessment more challenging. |
| **Underwriting** | The lender's process of evaluating borrower risk before approving credit. |

---

## Related Documentation

| Resource | Description |
|----------|-------------|
| `README.md` | Project overview, business problem, methodology, findings, and reproduction steps |
| `docs/data_dictionary.md` | Detailed description of all original and engineered variables, plus project glossary |
| `docs/security_notes.md` | Credential management, environment configuration, and security practices |
| `data/raw/` | Original Kaggle dataset used for the project |
| `data/processed/` | Cleaned and feature-engineered datasets generated during analysis |
| `sql/` | SQL scripts used for data exploration, segmentation, and business analysis |
| `notebooks/` | Python notebooks covering ETL, data cleaning, feature engineering, risk scoring, and visualization |
| `excel/` | Executive dashboard workbook designed for business stakeholders |
| `tableau/` | Tableau workbook, dashboard assets, and Tableau Public link |
| `outputs/` | Exported SQL query results, charts, figures, and intermediate analysis outputs |
