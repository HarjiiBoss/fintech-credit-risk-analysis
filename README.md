# Fintech Credit Risk Analysis
### Bureau-Independent Credit Risk Segmentation for Digital Lending

---

## Problem Statement

Nigeria's digital lending industry has grown rapidly, expanding access to credit for a population historically underserved by traditional banking. However, this rapid growth has been accompanied by increasing default rates, while many borrowers remain outside the coverage of traditional credit bureaus. As a result, digital lenders increasingly rely on alternative behavioral signals—such as repayment history, credit utilization, debt burden, and income characteristics—to assess borrower risk.

This project develops a bureau-independent credit risk segmentation framework using the public **Give Me Some Credit** dataset as a proof of concept. Although the dataset originates from the United States, its behavioral credit variables closely resemble the alternative lending signals commonly used by Nigerian fintech lenders when traditional credit bureau information is unavailable.

The project demonstrates how SQL, Python, and Tableau can be combined to transform raw lending data into actionable business intelligence for borrower segmentation, financial exposure assessment, and operational decision-making.

---

## Executive Summary

This project presents an end-to-end credit risk analytics solution covering the complete analytical workflow—from database design and ETL through feature engineering, business analysis, and executive reporting.

Using behavioral lending data, the project:

- Identifies borrowers most likely to default.
- Develops a custom Behavioral Risk Score for borrower segmentation.
- Builds an Exposure Index to estimate relative financial exposure where loan balance information is unavailable.
- Evaluates operational inefficiencies that contribute to higher lending risk.
- Delivers interactive Tableau dashboards for business stakeholders.

The solution demonstrates how bureau-independent data can support lending decisions in emerging digital credit markets.

---

## Repository Structure

```text
fintech-credit-risk-analysis/
│
├── data/
│   ├── raw/
│   └── processed/
│
├── docs/
│   ├── documentation_index.md
│   ├── phase_00_project_setup.md
│   ├── phase_01_data_cleaning_eda.md
│   ├── phase_02_borrower_default_risk.md
│   ├── phase_03_financial_exposure_risk.md
│   ├── phase_04_operational_inefficiency.md
│   ├── data_dictionary.md
│   ├── project_glossary.md
│   ├── security_notes.md
│   └── tableau_blueprint.md
│
├── notebooks/
├── outputs/
├── sql/
│
├── tableau/
│   ├── workbook/
│   └── screenshots/
│
├── README.md
└── LICENSE
```

---

## Data

| Attribute | Description |
|-----------|-------------|
| **Source** | Kaggle — *Give Me Some Credit* |
| **Original Records** | 150,000 borrowers |
| **Processed Records** | 149,999 borrowers |
| **Dataset Type** | Consumer Credit Risk |
| **Target Variable** | Serious delinquency within two years (90+ days past due) |

### Methodological Note

Public Nigerian lending datasets containing borrower-level repayment behavior are not currently available. Therefore, this project uses the **Give Me Some Credit** dataset as a bureau-independent proof of concept.

The analysis focuses on behavioral lending patterns—including repayment history, credit utilization, debt burden, and income characteristics—rather than absolute monetary values, making the methodology transferable to digital lending environments where traditional credit histories are limited.

---

## Business Questions

This project answers three key business questions:

1. **Which borrowers are most likely to default, and what are the earliest warning signals?**
2. **Where is the lending portfolio exposed to financial leakage and overexposure risk?**
3. **Which operational patterns indicate opportunities to improve lending decisions and reduce future defaults?**

---

## Methodology

The project follows a five-phase analytical workflow:

```text
Raw Dataset
      │
      ▼
Project Setup & Database Design
      │
      ▼
Python ETL
      │
      ▼
Data Cleaning & Exploratory Analysis
      │
      ▼
SQL Business Analysis
      │
      ▼
Behavioral Risk Scoring
      │
      ▼
Financial Exposure Analysis
      │
      ▼
Operational Risk Assessment
      │
      ▼
Interactive Tableau Dashboard
```

The workflow combines:

- MySQL database design and SQL business analysis
- Python ETL, feature engineering, and statistical analysis
- Behavioral Risk Score development
- Exposure Index construction
- Executive dashboard development using Tableau

---

## Key Findings

### Borrower Default Risk

- Borrowers aged **20–39** consistently exhibited the highest default rates.
- A first **30–59 day delinquency** was associated with a **5.7× higher likelihood** of reaching 90+ days past due.
- A Behavioral Risk Score successfully segmented borrowers into **Low, Medium, High, and Critical** risk tiers with clear monotonic increases in observed default rates.
- Placeholder delinquency codes (96/98) emerged as the strongest single early-warning indicator, with a **54.65%** observed default rate.

---

### Financial Exposure Risk

- Developed a custom **Exposure Index** to estimate relative borrower exposure in the absence of loan balance information.
- Identified and corrected two significant data quality issues affecting Debt Ratio and Credit Utilization.
- Exposure Tier produced a **9.5× spread** in observed default rates between Low and Critical exposure groups.
- Combining Behavioral Risk Tier with Exposure Tier identified the highest-risk borrower segments within the portfolio.

---

### Operational Inefficiency

- Younger, lower-income borrowers consistently demonstrated elevated default risk.
- Borrowers with zero active credit lines showed disproportionately high default rates, highlighting potential underwriting concerns.
- Portfolio segmentation identified opportunities to strengthen approval criteria and improve lending efficiency.

---

## Tools & Technologies

| Tool | Purpose |
|------|---------|
| **MySQL** | Database design, SQL analysis, borrower segmentation |
| **Python (Pandas & NumPy)** | ETL, data cleaning, feature engineering, risk scoring |
| **Matplotlib & Seaborn** | Exploratory and explanatory visualizations |
| **Jupyter Notebook** | End-to-end analytical workflow |
| **Tableau Public** | Interactive business intelligence dashboards |
| **Git & GitHub** | Version control and project documentation |

---

## Deliverables

This repository includes:

- SQL scripts for database creation and business analysis
- Python notebooks covering ETL, feature engineering, and analytical workflows
- Cleaned and feature-engineered datasets
- Interactive Tableau dashboard
- Dashboard screenshots
- Comprehensive technical documentation
- Portfolio-ready GitHub repository

---

## Documentation

Comprehensive project documentation is available in the **docs/** directory.

| Document | Description |
|----------|-------------|
| `documentation_index.md` | Documentation overview and navigation |
| `phase_00_project_setup.md` | Project setup and data ingestion |
| `phase_01_data_cleaning_eda.md` | Data cleaning and exploratory analysis |
| `phase_02_borrower_default_risk.md` | Borrower default risk analysis |
| `phase_03_financial_exposure_risk.md` | Financial Exposure Risk analysis |
| `phase_04_operational_inefficiency.md` | Operational inefficiency analysis |
| `data_dictionary.md` | Original dataset fields and engineered variables |
| `project_glossary.md` | Credit risk and fintech terminology |
| `security_notes.md` | Security practices and environment configuration |
| `tableau_blueprint.md` | Dashboard architecture and worksheet mapping |

---

## How to Reproduce

1. Clone this repository.
2. Download the **Give Me Some Credit** dataset from Kaggle.
3. Place the dataset inside `data/raw/`.
4. Execute `sql/00_setup.sql` to create the database.
5. Run the notebooks sequentially:
   - `01_cleaning_eda.ipynb`
   - `02_risk_scoring.ipynb`
   - `03_exposure_analysis.ipynb`
   - `04_operational_analysis.ipynb`
6. Open the Tableau workbook inside the `tableau/` directory or view the published Tableau Public dashboard.

---

## Dashboard

The project includes an interactive **Tableau Public dashboard** designed as a four-page analytical application.

### Dashboard Pages

#### 1. Executive Overview
A high-level summary of portfolio performance featuring:

- Portfolio KPI cards
- Risk distribution overview
- Exposure summary
- Operational health indicators
- Navigation to analytical dashboards

#### 2. Borrower Default Risk
Analyze borrower behavior and identify early warning signals through:

- Risk tier distribution
- Default rates by borrower segment
- Behavioral risk scoring
- Delinquency progression analysis
- High-risk borrower profiles

#### 3. Financial Exposure Risk
Evaluate financial exposure and revenue risk using:

- Exposure Index distribution
- Credit utilization analysis
- Debt ratio segmentation
- Exposure Tier performance
- Combined Risk × Exposure analysis

#### 4. Operational Inefficiency
Identify lending process improvement opportunities through:

- Approval calibration analysis
- Household financial strain
- Credit portfolio composition
- Operational risk indicators
- Borrower demographic comparisons

### Dashboard Features

- Interactive global filters
- Cross-dashboard navigation buttons
- Dynamic KPI cards
- Drill-down analysis
- Consistent visual design across all dashboards
- Executive-ready business insights

**Tableau Public:** *(Link will be added after publication.)*

**Screenshots:** Available in `tableau/screenshots/`.

---

## License

This project is intended for educational and portfolio purposes.

The original **Give Me Some Credit** dataset is provided by Kaggle under its applicable terms of use.

All SQL scripts, Python notebooks, feature engineering, documentation, dashboards, and analytical methodologies contained in this repository are original work created by **Taofeek Salami**.
