# Phase 1 — Data Cleaning & EDA

**Date:** 2026-07-13
**Status:** Complete
**Dataset after cleaning:** 149,999 rows × 14 columns → saved to
`data/processed/cs_training_cleaned.csv`

## Data Quality Baseline (sql/01a_exploration.sql)
| Check | Result |
|---|---|
| Null `MonthlyIncome` | 29,731 (19.82%) |
| Null `NumberOfDependents` | 3,924 (2.62%) |
| Duplicate `id` | 0 |
| Target balance (`SeriousDlqin2yrs`) | 0 = 93.32% · 1 = 6.68% (imbalanced) |
| `age = 0` | 1 record |
| `RevolvingUtilizationOfUnsecuredLines > 1` | 3,321 (2.21%), max = 50,708 |

## Cleaning Decisions
1. **age = 0 (1 record):** Dropped — confirmed data entry error.
2. **MonthlyIncome nulls (19.82%):** Flagged via `income_missing` boolean,
   not imputed. Rationale: imputing ~20% of a core Pillar 2 feature would
   fabricate a large share of income-based findings.
3. **NumberOfDependents nulls (2.62%):** Imputed with 0 (mode). Rationale:
   low missingness, low distortion risk vs. income.
4. **Utilization > 1 (2.21%):** Flagged via `utilization_extreme_flag`,
   not capped or dropped. Rationale: treated as a potential behavioral
   risk signal rather than noise.

## Key Findings
- **Extreme utilization correlates strongly with default:** borrowers
  flagged `utilization_extreme_flag = True` show a **37.25%** default
  rate vs. **5.99%** for others — over 6x the population baseline (6.68%).
  Candidate headline finding for Pillar 1 (early warning signal).
- **Severe multicollinearity** among the three delinquency-count fields
  (30-59, 60-89, 90+ days past due): pairwise correlation 0.98–0.99.
  These move together as one behavioral cluster, not independent signals
  — relevant to how the Phase 2 composite risk score is interpreted.
- **Raw utilization shows ~0 linear correlation with default (-0.00)**
  despite the strong signal found via flagging — Pearson correlation
  missed this because extreme outliers swamp the linear relationship.
  Supports flagging/bucketing over using the raw feature directly.
- Mild negative correlation between age and NumberOfDependents (-0.22).

## Outputs Saved
- `outputs/eda_distributions.png`
- `outputs/eda_correlation.png`
- `outputs/eda_target_balance.png`