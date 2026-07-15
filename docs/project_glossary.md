# Project Glossary — Fintech Credit Risk Analysis

**Project:** Fintech Credit Risk Analysis  
**Author:** Taofeek Salami

---

# Overview

This glossary explains the business, fintech, lending, analytics, and project-specific terminology used throughout the project.

It is intended to help readers interpret the analysis while demonstrating the domain knowledge required for credit risk analytics.

---

# Lending & Credit Terms

| Term | Definition |
|------|------------|
| **Borrower** | Individual or business receiving credit from a lender. |
| **Lender** | Financial institution or fintech company that provides loans or credit. |
| **Credit Bureau** | Organization that collects and maintains borrowers' credit histories. |
| **Credit History** | Record of an individual's borrowing and repayment behaviour. |
| **Credit Line** | Maximum amount a borrower is allowed to borrow. |
| **Credit Limit** | Upper borrowing threshold assigned to a revolving credit account. |
| **Revolving Credit** | Credit that can be borrowed, repaid, and reused repeatedly (e.g., credit cards). |
| **Installment Loan** | Loan repaid through scheduled fixed payments over time. |
| **Mortgage** | Loan secured by real estate property. |
| **Unsecured Credit** | Credit issued without collateral. |
| **Thin-File Borrower** | Borrower with little or no traditional credit history. |
| **Alternative Data** | Non-traditional borrower information used instead of bureau history for credit assessment. |

---

# Credit Risk Terms

| Term | Definition |
|------|------------|
| **Credit Risk** | Risk that a borrower fails to repay debt obligations. |
| **Default** | Failure to meet agreed repayment obligations. In this project, represented by becoming **90+ days delinquent** within two years. |
| **Delinquency** | Late or missed loan payment. |
| **30 DPD** | Borrower is 30 days past due. |
| **60 DPD** | Borrower is 60 days past due. |
| **90+ DPD** | Borrower is at least 90 days past due; commonly treated as default. |
| **Early Warning Signal** | Variable indicating elevated default risk before default actually occurs. |
| **Risk Segmentation** | Grouping borrowers according to their likelihood of default. |
| **Portfolio Risk** | Aggregate credit risk across all borrowers in a lending portfolio. |
| **Exposure** | Amount of financial risk associated with a borrower. |
| **Overexposure** | Situation where borrower financial obligations exceed safe repayment capacity. |
| **Repayment Capacity** | Borrower's ability to meet loan repayments from available income. |

---

# Financial Metrics

| Term | Definition |
|------|------------|
| **Credit Utilization** | Percentage of available revolving credit currently in use. |
| **Debt Ratio** | Monthly debt obligations divided by monthly gross income. |
| **Monthly Income** | Borrower's reported gross monthly earnings. |
| **Financial Stress** | Indicators suggesting difficulty meeting financial obligations. |
| **Leverage** | Degree to which borrowing finances personal or business activity. |

---

# Data & Analytics Terms

| Term | Definition |
|------|------------|
| **Cross-Sectional Dataset** | Dataset collected at one point in time rather than across multiple time periods. |
| **Feature Engineering** | Creating new variables from existing data to improve analysis. |
| **Composite Score** | Score produced by combining multiple indicators into a single metric. |
| **Behavioral Risk Score** | Composite score measuring borrower risk using repayment behaviour. |
| **Exposure Index** | Composite score ranking borrowers by relative financial exposure. |
| **Correlation** | Statistical relationship between two variables. |
| **Outlier** | Observation that differs substantially from the rest of the dataset. |
| **Missing Data** | Records where values are unavailable or unreported. |
| **Imbalanced Dataset** | Dataset in which one outcome occurs far less frequently than another. |
| **Proxy Variable** | Substitute variable used when the desired measurement is unavailable. |

---

# Dashboard & Business Intelligence Terms

| Term | Definition |
|------|------------|
| **Dashboard** | Interactive visual interface summarizing business performance. |
| **KPI (Key Performance Indicator)** | Quantitative measure used to evaluate business performance. |
| **Filter** | Interactive control that restricts displayed data. |
| **Navigation Button** | Interactive element allowing users to move between dashboards. |
| **Tooltip** | Information displayed when hovering over a visualization. |
| **Heatmap** | Color-coded visualization highlighting intensity or concentration. |
| **Drill-down** | Interactive exploration from summarized information to detailed records. |

---

# Project-Specific Terms

| Term | Definition |
|------|------------|
| **Behavioral Risk Score** | Composite score built from repayment frequency, delinquency severity, and repayment recency proxy. |
| **Risk Tier** | Final borrower classification: Low, Medium, High, or Critical. |
| **Exposure Index** | Composite financial exposure score ranging from 0–6. |
| **Exposure Tier** | Final exposure classification: Low, Moderate, High, Critical, or Indeterminate. |
| **income_missing** | Engineered flag identifying borrowers whose income was originally missing. |
| **utilization_extreme_flag** | Engineered flag identifying utilization values greater than 100%. |
| **delinquency_data_error_flag** | Engineered flag identifying known placeholder values (96 & 98) in delinquency fields. |
| **Critical Borrower** | Borrower classified into the highest behavioral risk tier. |
| **Combined Risk Segment** | Borrowers classified as both Critical Risk and Critical Exposure. |
| **Indeterminate Exposure** | Borrowers whose exposure score cannot be reliably computed due to missing income. |

---

# Related Documentation

| Resource | Description |
|----------|-------------|
| `README.md` | Project overview and methodology |
| `docs/documentation_index.md` | Documentation directory |
| `docs/data_dictionary.md` | Dataset and engineered variable definitions |
| `docs/tableau_blueprint.md` | Tableau dashboard implementation guide |
| `docs/security_notes.md` | Credential management and security practices |
| `docs/phase_*.md` | Phase-by-phase project documentation |
