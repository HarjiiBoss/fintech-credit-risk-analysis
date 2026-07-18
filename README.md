# Fintech Credit Risk Analysis
### Bureau-Independent Credit Risk Segmentation for Digital Lending

---

## Problem Statement

Nigeria's digital lending industry has grown rapidly, expanding access to credit for a population historically underserved by traditional banking. However, this growth has been accompanied by increasing credit risk, while many borrowers remain outside the coverage of traditional credit bureaus.

As a result, digital lenders increasingly rely on alternative behavioral signals—including repayment history, credit utilization, debt burden, income characteristics, and borrower profiles—to assess credit risk.

This project develops a bureau-independent credit risk segmentation framework using the public **Give Me Some Credit** dataset as a proof of concept.

Although the dataset originates from the United States, its behavioral credit variables closely resemble alternative lending signals commonly used by digital lenders when traditional credit bureau information is limited or unavailable.

The project demonstrates how SQL, Python, and Tableau can be combined to transform raw lending data into actionable business intelligence for:

- Borrower default risk segmentation
- Financial exposure assessment
- Operational risk analysis
- Evidence-based underwriting decisions

---

## Executive Summary

This project presents an end-to-end credit risk analytics solution covering the complete analytical workflow—from database design and ETL through data quality assessment, feature engineering, SQL analysis, risk scoring, exposure indexing, business interpretation, and executive reporting.

Using behavioral lending data, the project:

- Identifies borrowers most likely to default.
- Develops a custom **Behavioral Risk Score** for borrower segmentation.
- Builds an **Exposure Index** to estimate relative exposure where direct loan balance and credit-limit data are unavailable.
- Evaluates structural borrower characteristics associated with elevated default risk.
- Investigates data-quality anomalies that may contain meaningful predictive signals.
- Delivers a four-dashboard interactive Tableau reporting application.

The result is a bureau-independent credit risk framework designed to demonstrate how alternative borrower data can support lending decisions in emerging digital credit markets.

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
│   ├── phase_05_dashboard_design.md
│   ├── phase_06_business_insights.md
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
