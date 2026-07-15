# Tableau Blueprint — Fintech Credit Risk Analysis

This document serves as the implementation guide for the Tableau dashboards in the **Fintech Credit Risk Analysis** project. It defines the workbook architecture, data sources, worksheet inventory, dashboard layout, navigation, filters, calculated fields, and design standards to ensure consistency throughout development.

---

# Workbook Architecture

```
Tableau Workbook
│
├── Executive Overview Dashboard
├── Borrower Default Risk Dashboard
├── Revenue Leakage Dashboard
└── Operational Inefficiency Dashboard
```

Each dashboard uses a **1920 × 1080** fixed-size layout for consistent presentation across desktop displays.

---

# Data Sources

## Primary Data Source

**File:** `data/processed/cs_training_exposure_scored.csv`

This is the project's master analytical dataset and contains:

- Original borrower variables
- Cleaned data
- Engineered features
- Risk Score
- Risk Tier
- Exposure Index
- Exposure Tier
- Income Missing Flag
- Utilization Extreme Flag
- Delinquency Placeholder Flag

This dataset powers nearly all KPIs, filters, and interactive analysis.

---

## Supporting SQL Outputs

These datasets are pre-aggregated using SQL and are used where they exactly match documented business findings.

| CSV | Used For |
|------|----------|
| `outputs/sql_p1_delinquency_by_age.csv` | Default rate by age band |
| `outputs/sql_p1_delinquency_by_income.csv` | Default rate by income quartile |
| `outputs/sql_p1_high_risk_profile.csv` | Highest-risk borrower segment |
| `outputs/sql_p1_delinquency_progression.csv` | Delinquency progression |
| `outputs/sql_p2_utilization_bands.csv` | Utilization analysis |
| `outputs/sql_p2_debtratio_bands.csv` | Debt ratio analysis |
| `outputs/sql_p2_creditlines_bands.csv` | Credit line segmentation |
| `outputs/sql_p3_dependents_income.csv` | Dependents vs income |
| `outputs/sql_p3_creditlines_realestate.csv` | Credit lines vs real estate loans |
| `outputs/sql_p3_approval_calibration.csv` | Approval calibration analysis |

---

# Dashboard Inventory

---

# Dashboard 1 — Executive Overview

## Purpose

Provide an executive summary of portfolio risk and allow users to navigate to detailed analysis.

---

## KPIs

- Population
- Overall Default Rate
- Critical Risk Borrowers
- Critical Exposure Borrowers
- Highest Combined Default Rate

---

## Worksheets

| Worksheet | Source |
|------------|--------|
| KPI Cards | Exposure dataset |
| Default Rate by Risk Tier | Exposure dataset |
| Exposure Tier vs Default Rate | Exposure dataset |
| Risk × Exposure Heatmap | Exposure dataset |
| Population Distribution | Exposure dataset |

---

## Filters

- Age Band
- Income Quartile
- Risk Tier
- Exposure Tier

---

# Dashboard 2 — Borrower Default Risk

## Purpose

Identify which borrower segments have the highest probability of default and highlight early warning indicators.

---

## KPIs

- Population
- Portfolio Default Rate
- Critical Risk Default Rate
- Highest-Risk Segment

---

## Worksheets

| Worksheet | Source |
|------------|--------|
| Delinquency by Age Band | SQL Output |
| Delinquency by Income Quartile | SQL Output |
| High-Risk Borrower Profile | SQL Output |
| Delinquency Progression | SQL Output |
| Risk Tier Distribution | Exposure dataset |
| Risk Tier Breakdown | Exposure dataset |

---

## Filters

- Age Band
- Income Quartile
- Risk Tier

---

# Dashboard 3 — Revenue Leakage

## Purpose

Identify financially overexposed borrowers before default occurs and evaluate portfolio exposure.

---

## KPIs

- Critical Exposure Default Rate
- Low Exposure Default Rate
- Invalid Utilization Default Rate
- Highest Combined Risk

---

## Worksheets

| Worksheet | Source |
|------------|--------|
| Utilization Bands | SQL Output |
| Debt Ratio Bands | SQL Output |
| Credit Line Bands | SQL Output |
| Exposure Tier Distribution | Exposure dataset |
| Risk × Exposure Matrix | Exposure dataset |

---

## Filters

- Exposure Tier
- Risk Tier
- Age Band
- Income Quartile

---

# Dashboard 4 — Operational Inefficiency

## Purpose

Evaluate lending process weaknesses and identify approval characteristics associated with higher default rates.

---

## KPIs

- Zero Credit Lines Default Rate
- High Dependency Segment
- Average Defaulter Age
- Highest Approval Risk Segment

---

## Worksheets

| Worksheet | Source |
|------------|--------|
| Dependents vs Income | SQL Output |
| Credit Lines vs Delinquency | SQL Output |
| Approval Calibration | SQL Output |
| Borrower Characteristics | Exposure dataset |
| Age Distribution | Exposure dataset |

---

## Filters

- Age Band
- Income Quartile
- Credit Line Band
- Dependents Band

---

# Navigation

Every dashboard includes consistent navigation buttons positioned at the top of the page.

```
Executive Overview

Borrower Default Risk

Revenue Leakage

Operational Inefficiency
```

Navigation should remain identical across every dashboard.

---

# Global Filters

Global filters should appear in the upper-right corner of every dashboard.

Recommended order:

```
Age Band

Income Quartile

Risk Tier

Exposure Tier
```

Where applicable, filters should be configured using:

**Apply to Worksheets → All Using This Data Source**

---

# Tableau Calculated Fields

Only lightweight presentation calculations should be created inside Tableau.

## Population

```tableau
COUNT([id])
```

---

## Default Rate

```tableau
AVG([SeriousDlqin2yrs])
```

Format as Percentage.

---

## Critical Risk Borrowers

```tableau
SUM(
IF [risk_tier] = "Critical"
THEN 1
END
)
```

---

## Critical Exposure Borrowers

```tableau
SUM(
IF [exposure_tier] = "Critical"
THEN 1
END
)
```

---

## Combined Critical Borrowers

```tableau
SUM(
IF [risk_tier] = "Critical"
AND [exposure_tier] = "Critical"
THEN 1
END
)
```

---

# Fields Reused Directly from Python

The following fields have already been engineered during the Python workflow and **must not be recreated inside Tableau**.

- `risk_score`
- `risk_tier`
- `exposure_index`
- `exposure_tier`
- `income_missing`
- `utilization_extreme_flag`
- `delinquency_data_error_flag`
- `age_band` *(if present)*
- `income_quartile` *(if present)*

These fields should be used directly from the processed dataset.

---

# Design Standards

## Canvas Size

- Fixed Size
- **1920 × 1080**

---

## Typography

| Element | Font Size |
|----------|-----------|
| Dashboard Title | 30–34 pt |
| Dashboard Subtitle | 16–18 pt |
| KPI Value | 34–42 pt |
| KPI Label | 13–16 pt |
| Chart Title | 18–22 pt |
| Axis Labels | 11–12 pt |
| Tooltip | 12 pt |

---

## Color Palette

| Purpose | Color |
|----------|--------|
| Primary Navy | #243E73 |
| Gold Accent | #D4AF37 |
| Critical | #C00000 |
| High | #D6B04C |
| Medium | #D9D9D9 |
| Low | #243E73 |
| Background | #F8F8F8 |
| Insight Box | #F7D7D4 |

---

# Dashboard Layout Standards

Top section

- Dashboard title
- Dashboard subtitle
- Navigation buttons
- Global filters

Second section

- KPI cards

Third section

- Primary analytical visualizations

Bottom section

- Business Insight panel summarizing the most important finding

Footer

```
Fintech Credit Risk Analysis • Taofeek Salami
```

---

# Development Principles

- Use the processed exposure dataset as the primary data source.
- Use SQL output CSVs where they directly support documented business findings.
- Do not duplicate feature engineering inside Tableau.
- Keep layouts, navigation, filters, colors, and typography consistent across dashboards.
- Ensure every visualization supports a documented business question from the project.
- Prioritize clarity, consistency, and executive readability over visual complexity.

---

# Expected Deliverables

- Tableau Workbook (`.twb` / `.twbx`)
- Four Interactive Dashboards
- Interactive Filters
- Navigation Buttons
- Dynamic Tooltips
- Business Insight Panels
- Export-ready Presentation Dashboard
- Public Tableau profile publication
