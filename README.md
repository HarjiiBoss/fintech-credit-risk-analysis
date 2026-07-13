# Fintech Credit Risk Analysis
### Bureau-Independent Credit Risk Segmentation for Digital Lending

---

## Problem Statement

Nigeria's digital lending industry has grown rapidly, expanding access to credit for a population historically shut out of traditional banking. But this growth has come with rising default rates, and most digital lenders cannot rely on traditional credit bureau records — the majority of borrowers have no bureau history at all. Lenders depend on alternative signals — transaction behavior, repayment patterns, credit utilization, income ratios — to assess risk.

This project develops a bureau-independent credit risk segmentation pipeline using a public consumer-credit dataset as a proof of concept. While the dataset is not Nigerian, its alternative credit signals closely mirror those used by digital lenders to assess borrower risk where traditional credit histories are unavailable.

*(Full problem statement to be pasted in from project scoping doc.)*

---

## Data

- **Source:** Kaggle — "Give Me Some Credit" (150,000 records)
- **Note:** Bureau-linked Nigerian lending datasets with the necessary feature granularity are not publicly available. This dataset's features (credit utilization, late-payment history, debt ratio, monthly income, open credit lines, age) mirror the bureau-independent, behavior-based signals Nigerian fintech lenders already rely on.

---

## Methodology

*(To be filled in as each phase completes — data cleaning approach, behavioral risk scoring logic, exposure estimation method, and any assumptions made.)*

---

## Pillar Findings

### Pillar 1 — Borrower Default Risk
*(TBD)*

### Pillar 2 — Revenue Leakage
*(TBD)*

### Pillar 3 — Operational Inefficiency
*(TBD)*

---

## Tools

| Tool | Role |
|---|---|
| SQL (MySQL) | Segmentation queries |
| Python (Pandas, NumPy) | Cleaning, scoring, visualization |
| Matplotlib / Seaborn | Exploratory and pillar-level visuals |
| Excel | Executive summary dashboard |
| Tableau Public | Final interactive dashboard |
| Jupyter Notebook | Analysis environment |

---

## How to Reproduce

1. Clone this repo
2. Load `data/raw/` CSV into MySQL using the schema in `sql/`
3. Run notebooks in `notebooks/` in order
4. Open Tableau workbook in `tableau/` or view the published dashboard: *(link TBD)*

---

## Dashboard

*(Tableau Public link + screenshot TBD)*
