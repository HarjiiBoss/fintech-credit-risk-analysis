# Fintech Credit Risk Analysis
### Bureau-Independent Credit Risk Segmentation for Digital Lending

---

## Problem Statement

Nigeria's digital lending industry has grown rapidly, expanding access to credit for a population historically shut out of traditional banking. But this growth has come with rising default rates, and most digital lenders cannot rely on traditional credit bureau records—the majority of borrowers have no bureau history at all. Instead, lenders depend on alternative signals such as transaction behavior, repayment patterns, credit utilization, and income ratios to assess borrower risk.

This project develops a bureau-independent credit risk segmentation pipeline using a public consumer-credit dataset as a proof of concept. While the dataset is not Nigerian, its alternative credit signals closely mirror those used by digital lenders to evaluate borrower risk where traditional credit histories are unavailable.

> **Note:** The complete business context and industry background will be incorporated from the project scoping document upon completion.

---

## Repository Structure

```text
fintech-credit-risk-analysis/
├── data/
│   ├── raw/
│   └── processed/
├── sql/
├── notebooks/
├── tableau/
│   ├── workbook/
│   └── screenshots/
├── outputs/
└── README.md
```

---

## Data

- **Source:** Kaggle — **Give Me Some Credit** (150,000 records)
- **Dataset Type:** Consumer credit risk dataset
- **Methodological Note:** Bureau-linked Nigerian lending datasets with the necessary feature granularity are not publicly available. This dataset's features—including credit utilization, repayment history, debt ratio, monthly income, open credit lines, age, and dependents—closely mirror the bureau-independent behavioral signals that Nigerian digital lenders rely on when traditional credit bureau information is unavailable.

---

## Key Questions

This project is designed to answer three business questions:

1. **Which borrowers are most likely to default, and what are the earliest warning signals?**
2. **Where is the lending business exposed to financial leakage and overexposure risk?**
3. **Which operational patterns indicate avoidable lending risk and opportunities to improve approval decisions?**

---

## Methodology

*This section will be completed after implementation.*

It will document:

- Data loading and cleaning strategy
- Exploratory Data Analysis (EDA)
- SQL-based borrower segmentation
- Behavioral risk scoring methodology
- Financial exposure estimation approach
- Operational risk assessment
- Key analytical assumptions and limitations

---

## Pillar Findings

### Pillar 1 — Borrower Default Risk

*Findings will be added after analysis.*

This section will summarize:

- Borrower default rates by segment
- High-risk borrower profile
- Behavioral risk scoring results
- Delinquency progression analysis
- Early warning indicators

---

### Pillar 2 — Revenue Leakage

*Findings will be added after analysis.*

This section will summarize:

- Financial exposure by borrower segment
- Bad debt rate analysis
- Credit utilization patterns
- Overexposure concentration
- Relative revenue risk

---

### Pillar 3 — Operational Inefficiency

*Findings will be added after analysis.*

This section will summarize:

- Approval process risk flags
- Credit line proliferation analysis
- Borrower demographic risk patterns
- Operational improvement opportunities

---

## Tools

| Tool | Role |
|------|------|
| **SQL (MySQL)** | Data storage, segmentation queries, aggregation, and business analysis |
| **Python (Pandas, NumPy)** | Data cleaning, behavioral risk scoring, feature engineering, and analysis |
| **Matplotlib / Seaborn** | Exploratory and explanatory visualizations |
| **Tableau Public** | Interactive business intelligence dashboard |
| **Jupyter Notebook** | End-to-end analytical workflow and documentation |
| **GitHub** | Version control and project documentation |

---

## Deliverables

Upon completion, this repository will contain:

- SQL scripts for borrower segmentation and business analysis
- Annotated Jupyter Notebook documenting the full analytical workflow
- Cleaned and processed datasets
- Tableau Public interactive dashboard
- Comprehensive project documentation
- Portfolio-ready README
- Dashboard screenshots and shareable Tableau link

---

## How to Reproduce

1. Clone this repository.
2. Download the **Give Me Some Credit** dataset from Kaggle.
3. Place the raw dataset inside the `data/raw/` directory.
4. Create the MySQL database and import the dataset.
5. Execute the SQL scripts inside the `sql/` folder.
6. Run the notebooks in the `notebooks/` directory in sequence.
7. Open the Tableau workbook in the `tableau/` folder or view the published Tableau Public dashboard *(link to be added upon completion).*

---

## Dashboard

The completed project will include an interactive Tableau Public dashboard featuring:

- **Borrower Default Risk**
- **Revenue Leakage**
- **Operational Inefficiency**

Dashboard screenshots and the public Tableau link will be added after project completion.

---

## License

This project is intended for educational and portfolio purposes.

The original dataset is provided by Kaggle under its applicable terms of use. All analysis, SQL scripts, notebooks, dashboards, and documentation in this repository are original work created for this project.
