# Phase 2 — Borrower Default Risk

**Date:** 2026-07-14  
**Status:** ✅ Complete  
**Core Question:** Which borrowers exhibit the highest risk of default, and what behavioral patterns provide the earliest warning signals?  
**Output Dataset:** `data/processed/cs_training_risk_scored.csv` (**149,999 rows × 21 columns**)

---

## Overview

This phase identified high-risk borrower segments using demographic and behavioral characteristics, developed a composite behavioral risk score, and validated that the resulting risk tiers align with observed default rates.

Because the dataset is cross-sectional rather than longitudinal, behavioral proxies were used where temporal information was unavailable.

---

# SQL Risk Segmentation

## 1. Delinquency Rate by Age Band

| Age Band | Borrowers | Delinquent | Default Rate |
|:---|---:|---:|---:|
| 20s | 8,820 | 1,035 | **11.73%** |
| 30s | 23,183 | 2,335 | **10.07%** |
| 40s | 34,377 | 2,878 | 8.37% |
| 50s | 35,301 | 2,278 | 6.45% |
| 60+ | 48,319 | 1,500 | **3.10%** |

### Finding

Default risk decreases consistently with age.

Borrowers in their **20s default nearly four times more frequently** than borrowers aged **60 and above**, suggesting age is one of the strongest demographic predictors of borrower risk.

---

## 2. Delinquency Rate by Income Quartile

*(Borrowers with missing income excluded; n = 120,269)*

| Income Quartile | Monthly Income | Default Rate |
|:---|:---|---:|
| Q1 | $0–$3,400 | **9.21%** |
| Q2 | $3,400–$5,400 | 7.89% |
| Q3 | $5,400–$8,249 | 6.08% |
| Q4 | $8,249–$3,008,750* | **4.63%** |

\*The maximum income appears to be an obvious data-entry anomaly and does not materially affect quartile-level default rates.

### Finding

Borrower risk decreases steadily as income increases, indicating lower-income borrowers experience substantially higher default rates.

---

## 3. High-Risk Borrower Segmentation

Combining age and income reveals a sharper borrower profile than either variable individually.

### Highest-Risk Segment

| Age | Income | Default Rate |
|:---|:---|---:|
| **30s** | **Q1 (≤ $3,400/month)** | **12.49%** |

This segment defaults at almost **twice the overall portfolio default rate (6.68%)**.

Borrowers in their **20s within the lowest income quartile (12.07%)** follow closely behind.

One segment (20s + Q4) produced an unusually high default rate (9.26%) but contained only **162 borrowers** and was therefore treated as statistically unreliable.

---

## 4. Delinquency Progression Analysis

| Borrower Group | 90+ Day Delinquency Rate |
|:---|---:|
| Previous 30–59 day delinquency | **18.13%** |
| No 30–59 day delinquency | **3.17%** |

### Finding

Borrowers with a recorded **30–59 day delinquency** are approximately **5.7 times more likely** to also exhibit a **90+ day delinquency**.

> **Methodological Note**
>
> Because the dataset contains no event timestamps, this represents an inferred behavioral relationship rather than a true longitudinal cohort analysis.

---

# Behavioral Risk Scoring

A composite borrower risk score was developed using three behavioral dimensions.

| Component | Method |
|:---|:---|
| **Frequency** | Total number of delinquency incidents across all three delinquency fields |
| **Recency (Proxy)** | Highest delinquency bucket reached (behavioral proxy) |
| **Severity** | Debt Ratio (quartile-binned) |

Because the dataset contains no event timestamps, delinquency severity buckets were used as behavioral proxies instead of true temporal recency.

---

## Notable Analytical Discovery

During feature engineering, **269 borrowers (0.18%)** were found to contain identical delinquency values of **96 or 98** across all three delinquency variables.

These values are widely recognized as placeholder/error codes within this dataset rather than genuine delinquency counts.

A new feature—

`delinquency_data_error_flag`

—was created to isolate these observations.

### Finding

This became the strongest single borrower-risk indicator discovered during the project.

| Group | Default Rate |
|:---|---:|
| Flagged borrowers | **54.65%** |
| Remaining borrowers | **6.60%** |

This represents an **8.3× increase** in observed default risk.

Accordingly, flagged borrowers were automatically assigned to the **Critical** risk tier.

---

## Risk Tier Validation

| Risk Tier | Borrowers | Default Rate |
|:---|---:|---:|
| Low | 60,578 | **2.23%** |
| Medium | 66,051 | 3.98% |
| High | 18,014 | 19.56% |
| **Critical** | **5,356** | **47.11%** |

### Validation

Observed default rates increase monotonically across all four risk tiers.

Borrowers classified as **Critical** default at:

- **21×** the rate of Low-risk borrowers
- **7×** the overall portfolio default rate

This validates the behavioral risk scoring methodology.

---

# Key Findings

- ✅ Default risk decreases steadily with both age and income.
- ✅ Borrowers in their **30s with the lowest income** represent the highest-risk demographic segment.
- ✅ A prior **30–59 day delinquency** is one of the strongest behavioral warning signals.
- ✅ Placeholder delinquency codes (96/98) unexpectedly became the single strongest predictor of default.
- ✅ The behavioral risk scoring framework produces well-separated and interpretable risk tiers.

---

# Outputs Generated

### SQL Outputs

- `outputs/sql_p1_delinquency_by_age.csv`
- `outputs/sql_p1_delinquency_by_income.csv`
- `outputs/sql_p1_high_risk_profile.csv`
- `outputs/sql_p1_delinquency_progression.csv`
- `outputs/sql_p1_delinquency_progression_baseline.csv`

### Processed Dataset

- `data/processed/cs_training_risk_scored.csv`

---

# Phase Summary

**Objectives Completed**

- ✅ Borrower risk segmentation
- ✅ Demographic risk analysis
- ✅ Behavioral risk scoring
- ✅ High-risk borrower identification
- ✅ Delinquency progression analysis
- ✅ Risk-tier validation
- ✅ Export of analytical datasets

**Status:** ✅ Complete
