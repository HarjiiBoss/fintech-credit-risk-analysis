# Documentation Index

**Project:** Fintech Credit Risk Analysis  
**Author:** Taofeek Salami  
**Purpose:** This directory contains the technical documentation supporting the end-to-end credit risk analysis workflow, from project setup and data preparation to borrower segmentation, financial exposure analysis, operational risk assessment, and interactive dashboard design.

---

# Documentation Overview

The documentation is organized to mirror the project's analytical workflow. Each phase builds on the previous one, providing transparency into the decisions, assumptions, methodologies, and findings that shaped the final solution.

---

# Phase Documentation

| Document | Purpose |
|----------|---------|
| `phase_00_project_setup.md` | Documents the project environment setup, database creation, data ingestion process, ETL workflow, and issues encountered during initial implementation. |
| `phase_01_data_cleaning_eda.md` | Covers data quality assessment, exploratory data analysis (EDA), cleaning decisions, feature preparation, and key observations before modeling. |
| `phase_02_borrower_default_risk.md` | Documents borrower segmentation, behavioral risk scoring methodology, default risk analysis, and identification of early warning signals. |
| `phase_03_revenue_leakage.md` | Explains the Exposure Index methodology, financial exposure analysis, revenue leakage assessment, and validation of exposure-based borrower segmentation. |
| `phase_04_operational_inefficiency.md` | Evaluates operational lending inefficiencies, approval quality, portfolio characteristics, and opportunities to improve lending decisions. |

---

# Reference Documentation

| Document | Purpose |
|----------|---------|
| `data_dictionary.md` | Defines every original dataset field and engineered feature used throughout the project. |
| `project_glossary.md` | Provides definitions of lending, credit risk, fintech, and analytical terminology referenced throughout the project. |
| `security_notes.md` | Documents credential management, environment configuration, security improvements, and development best practices. |
| `tableau_blueprint.md` | Describes the Tableau dashboard architecture, worksheet mapping, data sources, filters, calculated fields, navigation, and dashboard design plan. |

---

# Project Workflow

```text
Phase 00
Project Setup & Data Ingestion
        │
        ▼
Phase 01
Data Cleaning & Exploratory Data Analysis
        │
        ▼
Phase 02
Borrower Default Risk Analysis
        │
        ▼
Phase 03
Revenue Leakage Analysis
        │
        ▼
Phase 04
Operational Inefficiency Analysis
        │
        ▼
Interactive Tableau Dashboard
        │
        ▼
Business Insights & Recommendations
```

---

# Project Assets

| Folder | Description |
|----------|-------------|
| `data/raw/` | Original Kaggle dataset used for the analysis. |
| `data/processed/` | Cleaned, feature-engineered, and analysis-ready datasets generated throughout the project. |
| `sql/` | SQL scripts used for database setup, exploratory analysis, segmentation, and business analysis. |
| `notebooks/` | Python notebooks covering ETL, data cleaning, feature engineering, risk scoring, exposure analysis, visualization, and model preparation. |
| `outputs/` | Exported SQL query results, figures, intermediate analysis outputs, and supporting files. |
| `tableau/` | Tableau workbook, dashboard assets, screenshots, and Tableau Public publication files. |

---

# Recommended Reading Order

For the best understanding of the project, review the documentation in the following order:

1. `README.md`
2. `phase_00_project_setup.md`
3. `phase_01_data_cleaning_eda.md`
4. `phase_02_borrower_default_risk.md`
5. `phase_03_revenue_leakage.md`
6. `phase_04_operational_inefficiency.md`
7. `data_dictionary.md`
8. `project_glossary.md`
9. `security_notes.md`
10. `tableau_blueprint.md`

---

# Documentation Standards

Throughout the project, all documentation follows these principles:

- Clear separation between observed findings and analytical assumptions.
- Reproducible analytical workflow from raw data to final dashboard.
- Transparent documentation of data quality issues and mitigation strategies.
- Business-oriented interpretation of statistical findings.
- Consistent naming conventions across SQL, Python, Tableau, and documentation.
- Version-controlled project assets to support reproducibility.

---

# Related Resources

| Resource | Description |
|----------|-------------|
| `README.md` | Project overview, business problem, methodology, key findings, deliverables, and reproduction guide. |
| `LICENSE` *(optional)* | Open-source license governing project usage and distribution. |

---

**Last Updated:** July 2026
