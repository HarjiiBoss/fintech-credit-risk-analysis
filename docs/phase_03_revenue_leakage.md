# Phase 3 — Revenue Leakage

**Date:** 2026-07-14  
**Status:** Complete  
**Core Question:** Where is the business failing to capture or protect revenue it should have earned?  
**Output Dataset:** `data/processed/cs_training_exposure_scored.csv` (149,999 rows × 26 columns)

---

# SQL Segmentation (`sql/03_revenue_leakage.sql`)

## Credit Utilization Analysis

| Utilization Band | Borrowers | Delinquent | Default Rate |
|---|---:|---:|---:|
| Invalid (>100%) | 3,321 | 1,237 | **37.25%** |
| High (80–100%) | 21,812 | 4,061 | **18.62%** |
| Elevated (50–80%) | 16,155 | 1,741 | **10.78%** |
| Moderate (30–50%) | 15,830 | 926 | **5.85%** |
| Low (<30%) | 92,882 | 2,061 | **2.22%** |

### Key Finding

A clear monotonic relationship exists between revolving credit utilization and default risk. Higher utilization consistently corresponds to higher delinquency rates, reinforcing utilization as one of the strongest financial early-warning indicators identified in the project.

---

## Debt Ratio Analysis

### Data Quality Investigation

Initial segmentation produced an unexpected result:

> Borrowers with **DebtRatio > 10** appeared to have the **lowest default rate (5.57%)**.

Rather than accepting this result, the underlying data was investigated.

The investigation showed:

- **90.04%** of borrowers with missing `MonthlyIncome` have **DebtRatio > 10**
- Only **1.75%** of borrowers with valid income exceed the same threshold

Without a valid income denominator, `DebtRatio` no longer behaves as a meaningful financial ratio.

### Decision 6

Debt ratio is treated as **unreliable whenever `income_missing = True`**.

Those observations are excluded from ratio-based analysis and omitted from the Exposure Index rather than assigning potentially misleading values.

---

## Open Credit Line Analysis

### Data Quality Investigation

Borrowers with **zero open credit lines** reported an average utilization of **1.00**, which is logically impossible.

Further investigation showed:

- **1,878 of 1,888 borrowers (99.5%)**
- had a utilization value of exactly **0.9999999**

This strongly indicates a system placeholder rather than genuine borrowing behaviour.

### Decision 7

Utilization values are treated as unreliable whenever:

`NumberOfOpenCreditLinesAndLoans = 0`

Instead, this borrower segment is evaluated using its observed default behaviour.

Although utilization is invalid, this segment still records the **highest portfolio default rate (25.64%)**, suggesting elevated thin-file or credit-access risk.

### Corrected Credit Line Segmentation

| Credit Lines | Average Utilization | Default Rate |
|---|---:|---:|
| 0 lines | n/a (placeholder values) | **25.64%** |
| 1–3 lines | 0.438 | 9.30% |
| 4–7 lines | 0.282 | 5.96% |
| 8–15 lines | 0.268 | 5.82% |
| 16+ lines | 0.259 | 6.91% |

### Key Finding

Default risk follows a **U-shaped relationship**.

Both borrowers with **very few** and **very many** credit lines exhibit higher risk than borrowers in the middle ranges.

---

# Exposure Index (`notebooks/03_exposure_analysis.ipynb`)

## Methodology

Because the dataset contains **no loan balance or credit limit fields**, precise financial exposure cannot be estimated.

Instead, a relative **Exposure Index (0–6)** was developed.

The index combines:

- **Utilization Score (0–3)** using validated utilization bands
- **Debt Ratio Score (0–3)** for borrowers with valid income only

Borrowers with zero credit lines receive the maximum utilization score based on their validated default behaviour rather than the placeholder utilization value.

Borrowers with missing income are intentionally classified as **Indeterminate** rather than assigned fabricated values.

---

## Exposure Index Validation

| Exposure Tier | Borrowers | Default Rate |
|---|---:|---:|
| Low | 63,709 | **2.35%** |
| Indeterminate | 29,731 | **5.61%** |
| Moderate | 40,394 | **9.73%** |
| High | 9,562 | **15.17%** |
| Critical | 6,603 | **22.35%** |

### Key Finding

The Exposure Index demonstrates a clean monotonic separation.

Borrowers in the **Critical** tier default at approximately **9.5×** the rate of those in the **Low** tier.

The **Indeterminate** group naturally falls between Low and Moderate, supporting the decision to preserve missing-income uncertainty rather than fabricate scores.

---

# Combined Risk Analysis

Cross-tabulation with the behavioural **Risk Tier** developed in Pillar 1 shows that Exposure Index contributes independent predictive information.

### Within the "Low" Behavioural Risk Tier

| Exposure Tier | Default Rate |
|---|---:|
| Low | **1.12%** |
| Indeterminate | **2.69%** |
| Moderate | **6.50%** |
| High | **6.89%** |

Even borrowers with identical repayment histories separate by almost **6×** once financial exposure is considered.

This demonstrates that behavioural risk and financial exposure measure complementary dimensions of borrower risk rather than duplicating one another.

---

## Highest Combined-Risk Segment

The highest-risk borrowers in the entire project are those classified as:

**Critical Behavioural Risk + Critical Exposure**

**Observed default rate: 54.97%**

For comparison:

| Segment | Default Rate |
|---|---:|
| Critical Behavioural Risk | 47.11% |
| Critical Exposure | 22.35% |
| Combined Critical + Critical | **54.97%** |

The same separation pattern is observed across every age band, confirming that the Exposure Index captures predictive information beyond borrower age.

---

# Key Outputs

- ✅ Exposure Index validated against observed default outcomes
- ✅ Relative financial exposure segmentation
- ✅ Bad debt risk by borrower profile
- ✅ Behavioural Risk × Exposure Index cross-analysis
- ✅ Age Band × Exposure Index cross-analysis
- ✅ Two major data-quality issues identified, investigated, documented, and corrected before index construction

---

# Exported Files

- `outputs/sql_p2_utilization_bands.csv`
- `outputs/sql_p2_debtratio_bands.csv`
- `outputs/sql_p2_creditlines_bands.csv`
- `data/processed/cs_training_exposure_scored.csv`
