# Phase 2 — Pillar 1: Borrower Default Risk

**Date:** 2026-07-14
**Status:** Complete
**Core question:** Which borrowers show the highest risk of default or
delinquency — and what are the earliest warning signals?
**Output dataset:** `data/processed/cs_training_risk_scored.csv`
(149,999 rows × 21 columns)

## SQL Segmentation (sql/01b_default_risk.sql)

### Delinquency rate by age band
| Age Band | Total | Delinquent | Rate |
|---|---|---|---|
| 20s | 8,820 | 1,035 | 11.73% |
| 30s | 23,183 | 2,335 | 10.07% |
| 40s | 34,377 | 2,878 | 8.37% |
| 50s | 35,301 | 2,278 | 6.45% |
| 60+ | 48,319 | 1,500 | 3.10% |

Risk decreases monotonically with age — 20s borrowers default at ~3.8x
the rate of 60+ borrowers.

### Delinquency rate by income quartile (excl. null income, n=120,269)
| Quartile | Income Range | Rate |
|---|---|---|
| Q1 (lowest) | $0–$3,400 | 9.21% |
| Q2 | $3,400–$5,400 | 7.89% |
| Q3 | $5,400–$8,249 | 6.08% |
| Q4 (highest) | $8,249–$3,008,750* | 4.63% |

*Q4 max is a likely data entry error (~$36M/year); does not affect the
rate calculation.

### High-risk borrower profile (age × income combined)
**Borrowers in their 30s, income Q1 (≤$3,400/month): 12.49% delinquency
rate** — the highest of any segment, nearly double the population
baseline (6.68%). 20s+Q1 follows closely (12.07%).

One segment (20s + Q4, n=162) showed an anomalous 9.26% rate — not
treated as reliable due to small sample size.

### Delinquency progression analysis
| Group | 90+ Day Rate |
|---|---|
| Had a 30-59 day incident | 18.13% |
| No 30-59 day incident | 3.17% |

A first 30-59 day delinquency is associated with a ~5.7x increase in
likelihood of reaching 90+ days late — one of the clearest early-warning
signals in the dataset. (Cross-sectional inference; dataset has no event
timestamps, so this is not a true time-based cohort analysis.)

## Behavioral Risk Scoring (notebooks/02_risk_scoring.ipynb)

Composite score built from three components (methodology note: proxies
used in place of true RFM due to lack of timestamps):
- **Frequency:** sum of late-payment incidents across all three
  delinquency fields, manually binned 0-3 (zero-inflated distribution
  made quartile binning invalid)
- **Recency (proxy):** severity tier of worst delinquency bucket reached
  (0-3)
- **Severity:** debt ratio, quartile-binned (0-3)

### Data quality finding: delinquency placeholder codes
269 borrowers (0.18%) showed identical values of 96 or 98 across all
three delinquency fields — a known placeholder/error code in this
dataset, not genuine counts. Flagged via `delinquency_data_error_flag`
and excluded from the numeric frequency score.

**This flag is the strongest single risk signal found in the project:**
flagged borrowers show a **54.65%** default rate vs. **6.60%** for the
rest of the population (~8.3x). Carried forward as an automatic Critical
tier override.

### Risk tiers (validated against actual default rate)
| Tier | Count | Default Rate |
|---|---|---|
| Low | 60,578 | 2.23% |
| Medium | 66,051 | 3.98% |
| High | 18,014 | 19.56% |
| **Critical** | 5,356 | **47.11%** |

Clean monotonic increase across tiers — Critical borrowers default at
~21x the rate of Low tier borrowers, and ~7x the population baseline.

## Key Outputs (per execution guide)
1. ✅ Default rate by segment — age band and income quartile
2. ✅ High-risk borrower profile — 30s + Q1 (12.49%)
3. ✅ Delinquency progression — 18.13% vs 3.17%
4. ✅ Early warning signals — extreme utilization flag (37.25% vs 5.99%),
   delinquency placeholder flag (54.65% vs 6.60%), first 30-59 day
   incident (18.13% vs 3.17%)

## Exported Files
- outputs/sql_p1_delinquency_by_age.csv
- outputs/sql_p1_delinquency_by_income.csv
- outputs/sql_p1_high_risk_profile.csv
- outputs/sql_p1_delinquency_progression.csv
- outputs/sql_p1_delinquency_progression_baseline.csv
- data/processed/cs_training_risk_scored.csv