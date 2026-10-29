# Fintech Credit Risk Analysis

**Project charter.** Written retrospectively in October 2026 from the project's phase records, when the project was brought in line with the Data Analysis Playbook v3.4. The analysis itself was carried out in July 2026 (Phases 0–6) and August 2026 (Phase 7). This document records the question, scope and definitions the analysis used; it was not written before the data was examined, and nothing in it should be read as a rule set in advance.

---

# Project Overview

| Item | Details |
|------|---------|
| Project | Capstone of the 3MTT Data Analysis & Visualization programme |
| Domain | Credit risk |
| Type | Descriptive risk segmentation, with significance tests and a logistic regression in Phase 7 |
| Tools | MySQL (SQL analysis), Python with pandas, SciPy, statsmodels and scikit-learn (cleaning, scoring, modelling), Tableau Public (reporting) |
| Author | Taofeek Salami |
| Analysis period | July–August 2026 |
| Status | Complete; revised October 2026 (see README → Corrections) |

---

# Business Context

Digital lenders in markets such as Nigeria often lend to borrowers with little or no credit bureau history, so they rely on behavioural signals such as repayment history, credit utilisation, debt burden and income. The lender wants to know which of those signals separate borrowers who go on to serious delinquency from those who do not, so it can tier borrowers for underwriting and monitoring.

This is a portfolio project on public US data (Kaggle, Give Me Some Credit). The stakeholders below are modelled on a typical digital lender, and the methods are intended to transfer; the dataset does not represent Nigerian borrowers.

---

# Business Problem

The lender sees an overall serious-delinquency rate but has no way to rank borrowers by risk without bureau data, and no measure of how stretched a borrower is, because the data has no loan balances or credit limits.

---

# Primary Business Question

Which borrower groups have the highest observed rate of serious delinquency, and can behavioural signals be combined into tiers that separate high-risk from low-risk borrowers?

---

# Supporting Analytical Questions

1. How does the default rate differ by age band, income quartile and their combination?
2. How do borrowers with a 30–59 day late payment compare with those without one?
3. Does a composite behavioural risk score separate borrowers into tiers with clearly different default rates?
4. Does a relative exposure measure built from utilisation and debt ratio separate default rates, including within the Low behavioural tier?
5. Which structural characteristics (open credit lines, dependents, income) are associated with higher default rates?
6. Are the differences between risk tiers statistically significant, and how well do the tiers rank borrowers on data the model was not trained on?

---

# Stakeholders (modelled)

| Stakeholder | Interest |
|-------------|----------|
| Credit risk / underwriting | Which borrowers to decline, price up or review |
| Collections and portfolio monitoring | Early signals worth acting on |
| Product | Whether thin-file or missing-income borrowers need separate treatment |
| Leadership | Size of the highest-risk segments |

---

# Scope

## Included

- Default rates by age band, income quartile, credit-line band, dependents, utilisation band and debt-ratio band
- A behavioural risk score (frequency, highest delinquency bucket, debt-ratio quartile) and four risk tiers
- A relative Exposure Index (utilisation score plus debt-ratio score) and exposure tiers, with missing-income borrowers kept as a separate Indeterminate tier
- Chi-square and two-proportion z-tests on the risk tiers, and a logistic regression evaluated on a stratified 20% test set (Phase 7)
- A four-dashboard Tableau Public report

## Excluded

- Monetary exposure or expected loss: the data has no loan balance, credit limit or recovery fields
- Calibrated probabilities of default: the Phase 7 model uses class weighting, so its scores rank borrowers rather than estimate probabilities
- Causes of default, and any analysis over time: the data is a single snapshot with no dates
- Claims about Nigerian borrowers specifically

---

# Available Data

Kaggle *Give Me Some Credit*, file `cs-training.csv`: 150,000 borrowers and 11 columns plus an `id`, one row per borrower, with no dates. The target `SeriousDlqin2yrs` records whether the borrower was 90 or more days past due in the two years after the snapshot. One record with `age = 0` was removed, leaving 149,999. `MonthlyIncome` is missing for 29,731 borrowers (19.82%) and was not imputed; `NumberOfDependents` is missing for 3,924 (2.62%) and was set to 0. 269 borrowers carry the codes 96 or 98 in the late-payment counts, which are placeholders rather than real counts. The file checksum was not recorded at download.

---

# Metric Definitions

The unit of analysis is one borrower. SQL results are saved in `outputs/`; scored data is in `data/processed/cs_training_exposure_scored.csv`.

| Metric | Calculation | Denominator | Time window | Units |
|--------|-------------|-------------|-------------|-------|
| Default rate | Borrowers with `SeriousDlqin2yrs = 1` ÷ borrowers | Borrowers in the group (income-quartile results exclude the 29,731 with missing income) | Two years after the snapshot, as defined by the source | % of borrowers |
| 90+ day late rate (Phase 2 progression check) | Borrowers with `NumberOfTimes90DaysLate > 0` ÷ borrowers | Borrowers with (or without) a 30–59 day late payment | Late payments recorded before the snapshot | % of borrowers. Not the default target |
| Behavioural risk score | Binned late-payment count (0–3) + highest late bucket reached (0–3) + debt-ratio quartile (0–3) | — | Snapshot | Score 0–9 |
| Risk tier | Low ≤ 1, Medium 2–3, High 4–6, Critical ≥ 7; borrowers with a 96/98 placeholder are set to Critical | — | Snapshot | Category |
| Exposure Index | Utilisation score (0–3) + debt-ratio score (0–3); zero open credit lines scores 3 on utilisation; missing income gives no debt-ratio score | — | Snapshot | Index 0–6. A relative measure, not money |
| Exposure tier | Low ≤ 1, Moderate 2–3, High 4, Critical 5–6, Indeterminate where income is missing | — | Snapshot | Category |
| AUC / Gini | Area under the ROC curve on the test set; Gini = 2 × AUC − 1 | 30,000 test borrowers (stratified 20%) | — | 0–1 |
| Recall / precision (defaulters) | At the model's default 0.5 threshold, with class weighting | Test-set defaulters / test-set borrowers flagged | — | % |

---

# Known Risks

| Risk | Effect | How it was handled |
|------|--------|--------------------|
| Score design used the outcome | The 96/98 placeholder group was set to Critical, and zero-credit-line borrowers given the top utilisation score, after their default rates (54.65% and 25.64%) were seen on the full data | Stated in the phase records; tier results are described as observed separation, not out-of-sample validation |
| Test set not held out from design | Tier cut-offs and debt-ratio quartiles were set on all 149,999 borrowers, including the 20% later used to test the model | The test-set AUC may be somewhat optimistic; noted in the README; a fresh split before feature design is listed as next work |
| Related variables | Age, income, dependents and late payments are related, so a high rate in one group may reflect another | Reported as associations only |
| Snapshot data | No dates, so no trends, cohorts or causes | Stated in the phase records and summaries |
| US data for a Nigerian use case | Rates will not carry over to another market | Framed as a transferable method, not a description of Nigerian borrowers |

---

# Assumptions

| Assumption | Status | Note |
|------------|--------|------|
| Late-payment counts of 96 and 98 are placeholder codes, not real counts | Partially validated | All 269 borrowers with them carry the same code across all three count columns ([phase_02_borrower_default_risk.md](docs/phase_02_borrower_default_risk.md)) |
| Utilisation is not meaningful for borrowers with zero open credit lines | Partially validated | 1,878 of the 1,888 such borrowers (99.5%) had a utilisation of exactly 0.9999999 ([phase_03_financial_exposure_risk.md](docs/phase_03_financial_exposure_risk.md)) |
| Debt ratio is not meaningful where income is missing | Partially validated | 90.04% of missing-income borrowers have a debt ratio above 10 ([phase_03_financial_exposure_risk.md](docs/phase_03_financial_exposure_risk.md)) |
| The 150,000 rows are distinct borrowers | Validated | No duplicate IDs ([phase_01_data_cleaning_eda.md](docs/phase_01_data_cleaning_eda.md)) |

---

# Deliverables

- Five SQL scripts and 14 CSV outputs
- Four notebooks: cleaning, risk scoring, exposure analysis, inference and prediction
- Tableau Public workbook with four dashboards
- Phase records 0–7, data dictionary, glossary and the project page

---

# Revision History

| Date | Change |
|------|--------|
| July 2026 | Phases 0–6: analysis, dashboards and documentation completed |
| 27 Aug 2026 | Phase 7 added: significance tests and logistic regression |
| 26 Oct 2026 | Phase 7 added to the project page |
| 29 Oct 2026 | 30–59 day finding corrected (see README → Corrections); this charter written retrospectively; Published Surfaces added |
