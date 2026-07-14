# Phase 4 — Pillar 3: Operational Inefficiency

**Date:** 2026-07-14
**Status:** Complete
**Core question:** Where does the lending process expose the business to
avoidable cost or risk?
**Note:** This pillar was fully SQL-driven per original project scope —
no new engineered columns, no dataframe changes; existing
`cs_training_exposure_scored.csv` remains the current dataset.

## SQL Analysis (sql/01d_operational.sql)

### Dependency ratio vs. income
Borrowers with **3-4 dependents in the lowest income quartile (Q1)**
show a **15.69% delinquency rate** (n=1,638) — more than double the rate
of income-matched borrowers with 0 dependents (7.60%, n=20,667). The
pattern holds directionally even at 1-2 dependents in Q1 (12.05%,
n=7,866).

**Approval risk flag:** household size, combined with low income, is a
concrete, data-backed indicator of elevated default risk — independent
of the individual borrower's own payment history.

### Credit line proliferation vs. delinquency
Confirms the U-shaped relationship found in Pillar 2: both very few (0
lines: 25.64%) and very many (16+ lines: 6.91%) open credit lines carry
more risk than the middle range (8-15 lines: 5.82%). Average real estate
loans climbs steadily with credit line count (0.00 to 1.91), indicating
general credit activity rather than a distinct real-estate-specific risk
driver.

**Conclusion:** credit line "proliferation" alone is not a reliable
operational risk signal — extremity in either direction matters more
than raw count.

### Approval calibration check
| | Defaulted | Did Not Default |
|---|---|---|
| Avg Age | 45.9 | 51.7 |
| Avg Income | $5,630.83 | $6,747.84 |
| Avg Open Lines | 8.24 | 8.80 |
| Avg Dependents | 1.05 | 0.84 |

Every dimension points the same direction: defaulters are younger,
lower-income, hold fewer open credit lines, and have more dependents.
This is a coherent approval-calibration gap — traditional criteria alone
(income, credit line count) would systematically under-price risk for
this profile without behavioral/exposure signals layered in (Pillars 1-2).

## Key Outputs (per execution guide)
1. ✅ Approval process risk flags — dependency ratio × income (3-4
   dependents + Q1 income = 2x risk vs. 0 dependents)
2. ✅ Portfolio concentration inefficiency — credit line U-shape, real
   estate loan cross-reference
3. ✅ Segment-level operational exposure — approval calibration gap
   across age, income, credit lines, and dependents

## Exported Files
- outputs/sql_p3_dependents_income.csv
- outputs/sql_p3_creditlines_realestate.csv
- outputs/sql_p3_approval_calibration.csv