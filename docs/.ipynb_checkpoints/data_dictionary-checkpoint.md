# Data Dictionary — Fintech Credit Risk Analysis

**Source:** Kaggle "Give Me Some Credit" (cs-training.csv)
**Rows:** 149,999 (after Phase 1 cleaning; 1 record with age=0 dropped from
original 150,000)

**Note on currency/scale:** Monetary fields (`MonthlyIncome`, `DebtRatio`)
are denominated in US dollars per the original Kaggle dataset. As detailed
in the project README, this dataset is used as a bureau-independent proxy
for Nigerian digital lending — the *behavioral patterns* (utilization,
delinquency, income ratios) are what transfer to that context, not the
literal currency values.

**How to read this:** Each row below is one column in `borrowers`
(MySQL) or `cs_training_cleaned.csv` (processed). "Notes" flags anything
non-obvious — missingness, outliers, or how a value was engineered.

| Column | Type | Description | Notes |
|---|---|---|---|
| `id` | INT | Unique borrower identifier | Renamed from unnamed index column in raw CSV |
| `SeriousDlqin2yrs` | TINYINT | Target variable: 1 = borrower experienced serious delinquency (90+ days past due) within 2 years, 0 = did not | Imbalanced: 6.68% positive class |
| `RevolvingUtilizationOfUnsecuredLines` | DOUBLE | Total balance on credit cards/lines of credit divided by sum of credit limits | Contains extreme outliers (max 50,708); values >1 flagged via `utilization_extreme_flag` rather than capped |
| `age` | INT | Borrower's age in years | 1 record with age=0 dropped as data entry error |
| `NumberOfTime30_59DaysPastDueNotWorse` | INT | Number of times borrower was 30-59 days past due (not worse) in the last 2 years | Highly correlated (0.98-0.99) with the 60-89 and 90+ day fields |
| `DebtRatio` | DECIMAL | Monthly debt payments, alimony, living costs divided by monthly gross income | Contains extreme outliers (values in the thousands) |
| `MonthlyIncome` | DECIMAL, nullable | Borrower's monthly income | 19.82% missing; flagged via `income_missing` rather than imputed |
| `NumberOfOpenCreditLinesAndLoans` | INT | Number of open loans and credit lines | |
| `NumberOfTimes90DaysLate` | INT | Number of times borrower was 90+ days past due | Highly correlated with the 30-59 and 60-89 day fields |
| `NumberRealEstateLoansOrLines` | INT | Number of mortgage and real estate loans | |
| `NumberOfTime60_89DaysPastDueNotWorse` | INT | Number of times borrower was 60-89 days past due (not worse) | Highly correlated with the 30-59 and 90+ day fields |
| `NumberOfDependents` | INT, nullable | Number of dependents excluding self | 2.62% missing; imputed with 0 (mode) |

## Engineered Columns (Python/pandas only — not loaded into MySQL)

| Column | Type | Description |
|---|---|---|
| `income_missing` | Boolean | True if `MonthlyIncome` was null in the original data |
| `utilization_extreme_flag` | Boolean | True if `RevolvingUtilizationOfUnsecuredLines` > 1 — found to correlate with a 37.25% default rate vs. 5.99% for others |