# Phase 1 — Data Cleaning & Exploratory Data Analysis (EDA)

**Date:** 2026-07-13  
**Status:** ✅ Complete  
**Dataset after cleaning:** **149,999 rows × 14 columns**  
**Output:** `data/processed/cs_training_cleaned.csv`

---

## Overview

This phase established the data quality baseline for the project by auditing missing values, validating data integrity, identifying outliers, and documenting all preprocessing decisions. Rather than aggressively removing anomalous observations, potentially meaningful behavioral signals were retained where appropriate to support downstream credit risk analysis.

---

## Data Quality Assessment

| Check | Result |
|:---|:---|
| Total records (raw) | 150,000 |
| Total records (cleaned) | 149,999 |
| Missing `MonthlyIncome` | 29,731 (19.82%) |
| Missing `NumberOfDependents` | 3,924 (2.62%) |
| Duplicate borrower IDs | 0 |
| Target balance (`SeriousDlqin2yrs`) | Non-default: **93.32%** • Default: **6.68%** |
| Invalid age (`age = 0`) | 1 record |
| Utilization > 100% | 3,321 (2.21%) |
| Maximum utilization observed | 50,708 |

---

## Data Cleaning Decisions

### 1. Invalid Age

- Removed the single record where `age = 0`.
- **Reason:** Confirmed data-entry error.

---

### 2. Missing Monthly Income

- Created an `income_missing` indicator.
- Missing values were intentionally **not imputed**.

**Rationale**

Approximately 20% of borrowers lack income information. Imputing such a large proportion of a core financial variable would introduce substantial uncertainty and potentially distort analyses related to borrower affordability and revenue exposure.

---

### 3. Missing Number of Dependents

- Missing values replaced with **0** (mode).

**Rationale**

Only 2.62% of observations were affected, making mode imputation unlikely to materially influence subsequent analyses.

---

### 4. Extreme Credit Utilization

- Created a `utilization_extreme_flag`.
- Extreme utilization values were **retained**, not capped or removed.

**Rationale**

Rather than treating these observations as noise, they were preserved as potential behavioral indicators of financial distress for later borrower risk segmentation.

---

## Key Findings

### 1. Extreme Utilization is a Strong Early Risk Signal

Borrowers flagged with `utilization_extreme_flag = True` exhibited a **37.25% default rate**, compared with **5.99%** among all other borrowers.

This represents a default rate more than **six times higher** than the overall portfolio baseline (**6.68%**) and emerged as one of the strongest early indicators of borrower risk.

---

### 2. Delinquency Variables Measure the Same Underlying Behavior

The three delinquency variables—

- 30–59 days past due
- 60–89 days past due
- 90+ days past due

show pairwise correlations ranging from **0.98 to 0.99**.

These variables should therefore be interpreted as highly related behavioral indicators rather than independent predictors, informing the composite behavioral risk score developed in Phase 2.

---

### 3. Raw Utilization Alone is Misleading

Although extreme utilization strongly predicts default, the raw utilization variable exhibits almost **no linear correlation** with default (**≈ 0.00**).

This occurs because a relatively small number of extremely large values distort Pearson correlation, supporting the decision to analyze utilization using behavioral flags and segmentation rather than relying solely on the raw numeric feature.

---

### 4. Limited Relationship Between Age and Dependents

Age and number of dependents show only a mild negative correlation (**−0.22**), indicating relatively weak linear association between the two variables.

---

## Outputs Generated

- `data/processed/cs_training_cleaned.csv`
- `outputs/eda_distributions.png`
- `outputs/eda_correlation.png`
- `outputs/eda_target_balance.png`

---

## Phase Summary

**Objectives Completed**

- ✅ Assessed overall data quality
- ✅ Audited missing values
- ✅ Verified data integrity
- ✅ Identified anomalous observations
- ✅ Documented all preprocessing decisions
- ✅ Produced cleaned analytical dataset
- ✅ Generated exploratory visualizations
- ✅ Established baseline findings for Phase 2

