# Phase 3 — Pillar 2: Revenue Leakage

**Date:** 2026-07-14
**Status:** Complete
**Core question:** Where is the business failing to capture or protect
revenue it should have earned?
**Output dataset:** `data/processed/cs_training_exposure_scored.csv`
(149,999 rows × 26 columns)

## SQL Segmentation (sql/01c_revenue_leakage.sql)

### Utilization bands
| Band | Total | Delinquent | Rate |
|---|---|---|---|
| Invalid (>100%) | 3,321 | 1,237 | 37.25% |
| High (80-100%) | 21,812 | 4,061 | 18.62% |
| Elevated (50-80%) | 16,155 | 1,741 | 10.78% |
| Moderate (30-50%) | 15,830 | 926 | 5.85% |
| Low (<30%) | 92,882 | 2,061 | 2.22% |

Clean, monotonic gradient — consistent with Phase 1/2 findings.

### Debt ratio bands — data quality finding
Initial banding showed "Extreme (>10)" with the *lowest* default rate
(5.57%) of any band — contrary to expectation. Investigation confirmed
this is a measurement artifact, not a genuine low-risk signal:
**90.04% of borrowers with missing MonthlyIncome show DebtRatio > 10**,
versus only 1.75% of borrowers with valid income. Without a valid income
denominator, DebtRatio does not behave as a true ratio.

**Decision 6:** DebtRatio is treated as unreliable wherever
`income_missing = True`. Excluded from ratio-based debt analysis and
excluded from the Exposure Index (see below) rather than blended in.

### Credit line bands — second data quality finding
Borrowers with 0 open credit lines showed avg. utilization of exactly
1.00 — illogical, since no open lines means nothing to utilize.
Investigation confirmed **1,878 of 1,888 such borrowers (99.5%) show
RevolvingUtilizationOfUnsecuredLines = 0.9999999**, a system placeholder
value, not genuine behavior.

**Decision 7:** Utilization is treated as unreliable wherever
`NumberOfOpenCreditLinesAndLoans = 0`. The underlying risk finding
survives independently — this segment shows a **25.64% default rate**,
the highest of any credit-line band — attributed to having zero open
credit (thin-file risk), not to the placeholder utilization value.

**Corrected credit line bands (utilization outliers excluded from avg):**
| Band | Avg Utilization | Default Rate |
|---|---|---|
| 0 lines | n/a (placeholder) | 25.64% |
| 1-3 lines | 0.438 | 9.30% |
| 4-7 lines | 0.282 | 5.96% |
| 8-15 lines | 0.268 | 5.82% |
| 16+ lines | 0.259 | 6.91% |

A U-shaped relationship: both very few and very many open lines carry
more risk than the middle range.

## Exposure Index (notebooks/03_exposure_analysis.ipynb)

**Methodology:** No loan balance or credit limit fields exist in this
dataset, so exact financial exposure cannot be calculated. An Exposure
Index (0-6) was built instead — a relative, pre-default risk-ranking
proxy combining:
- **Utilization score (0-3):** banded per the validated SQL segmentation;
  borrowers with the confirmed placeholder (0 open lines) scored as
  high-risk (3) based on that segment's own validated 25.64% default
  rate, not the broken utilization value itself.
- **Debt ratio score (0-3):** calculated only for borrowers with valid
  income. For the 19.82% with missing income, left unscored rather than
  fabricated.

Borrowers with missing income are labeled **"Indeterminate"** rather
than forced into a score.

### Validation — Exposure Index vs. actual default rate
| Tier | Count | Default Rate |
|---|---|---|
| Low | 63,709 | 2.35% |
| Indeterminate | 29,731 | 5.61% |
| Moderate | 40,394 | 9.73% |
| High | 9,562 | 15.17% |
| **Critical** | 6,603 | **22.35%** |

Clean monotonic separation — Critical exposure borrowers default at
~9.5x the rate of Low. Notably, the Indeterminate group's empirical
default rate (5.61%) lands sensibly between Low and Moderate — support
for not fabricating a score for this group rather than a sign the
approach failed.

### Compounding finding: Exposure Index adds signal beyond Risk Tier
Cross-tabbing Exposure Index against Pillar 1's behavioral Risk Tier
shows the two scores are not redundant — within the same Risk Tier,
Exposure Index still separates real default rate substantially:

**Within "Low" risk_tier (clean payment history):**
| Exposure Tier | Default Rate |
|---|---|
| Low | 1.12% |
| Indeterminate | 2.69% |
| Moderate | 6.50% |
| High | 6.89% |

A ~6x spread among borrowers who look identical on delinquency history
alone — meaning exposure signals matter even for borrowers with no
adverse payment history.

**Highest combined-risk segment found in the project:** Critical
risk_tier + Critical exposure_tier = **54.97% default rate** — higher
than either score alone (Pillar 1 Critical: 47.11%; Pillar 2 Critical:
22.35%).

The same separation pattern (Low < Indeterminate < Moderate/High 
Critical) holds within every individual age band, confirming the
Exposure Index captures signal independent of age.

## Key Outputs (per execution guide)
1. ✅ Estimated exposure by segment — Exposure Index, validated against
   real default rate (9.5x spread, Low to Critical)
2. ✅ Bad debt rate by borrower profile — Risk Tier × Exposure Tier
   cross-tab, Age Band × Exposure Tier cross-tab
3. ✅ Overexposure concentration — utilization and debt ratio bands
   (SQL), with two data quality issues identified, documented, and
   corrected for before being used in the index

## Exported Files
- outputs/sql_p2_utilization_bands.csv
- outputs/sql_p2_debtratio_bands.csv
- outputs/sql_p2_creditlines_bands.csv
- data/processed/cs_training_exposure_scored.csv