# Phase 5 — Dashboard Design & Documentation

**Tool:** Tableau Public
**Workbook:** `Fintech_Credit_Risk_Analysis.twbx`
**Dashboards:** 4
**Status:** Complete ✅

---

## Objective

Design, build, and validate a consistent interactive reporting interface that translates the analytical outputs from Phases 2–4 into clear business intelligence.

The dashboard suite communicates:
- Borrower default risk
- Financial exposure risk
- Operational inefficiency

A standardized visual design system was applied across all four dashboards to ensure consistency, readability, and ease of interpretation.

The dashboards are built on the validated SQL segmentation, Python risk-scoring logic, and Exposure Index developed during the analytical phases. Tableau functions as the presentation and interaction layer rather than duplicating the underlying analytical logic.

---

# Dashboard Architecture

The reporting workflow follows a layered storytelling structure:

```text
Executive Overview
        ↓
Borrower Default Risk
        ↓
Financial Exposure Risk
        ↓
Operational Inefficiency
```

The Executive Overview presents the portfolio-level risk position and the interaction between behavioral risk and financial exposure.

The three supporting dashboards then provide progressively deeper analysis of the project's analytical pillars.

---

## Dashboard Purpose

| Dashboard | Purpose | Primary Audience |
|---|---|---|
| Executive Overview | Present headline portfolio KPIs and the relationship between behavioral risk and financial exposure | Executive Leadership |
| Borrower Default Risk | Identify who is most likely to default and surface behavioral early-warning signals | Credit Risk · Underwriting |
| Financial Exposure Risk | Evaluate utilization, debt burden, and pre-default exposure risk | Risk · Portfolio Management |
| Operational Inefficiency | Identify structural borrower patterns that may indicate weaknesses in approval criteria | Underwriting · Product Strategy |

---

# Dashboard Design System

A consistent visual design system was applied across all dashboard pages to improve readability, reduce cognitive load, and create a unified reporting experience.

---

## Colour Palette

| Purpose | Colour | Hex Code |
|---|---|---|
| Primary Brand | Dark Navy | `#1F3864` |
| KPI Highlight | Gold | `#C9A84C` |
| Critical Risk | Red | `#C00000` |
| Secondary Background | Light Navy | `#DAE3F3` |
| Moderate Risk | Light Gold | `#FDF2D0` |
| High Risk Row | Light Red | `#FADBD8` |
| Secondary Elements | Light Grey | `#D9D9D9` |
| Data Limitation / Indeterminate | Muted Blue-Grey | `#A9B4C2` |
| Primary Text | Dark Grey | `#262626` |
| Background | White | `#FFFFFF` |

Data Limitation / Indeterminate is used specifically for values affected by known data limitations, such as borrowers with missing income who cannot be reliably scored on the Exposure Index.

This visually distinguishes:
- Genuine low-risk findings
- Genuine high-risk findings
- Segments where the available data does not support a reliable score

---

## Typography

| Element | Font Size | Weight |
|---|---:|---|
| Dashboard Title | 14 pt | Bold |
| Dashboard Subtitle | 9 pt | Regular |
| KPI Value | 36 pt | Bold |
| KPI Label | 11 pt | Bold |
| Chart Title | 10 pt | Bold |
| Chart Axis Labels | 8 pt | Regular |
| Chart Data Labels | 9 pt | Regular |
| Insight Box Title | 11 pt | Bold |
| Insight Box Text | 9 pt | Regular |
| Footer | 8 pt | Regular |

---

## Layout Standards

| Component | Standard |
|---|---|
| Canvas size | Fixed, 1920 × 1080 |
| Sheet background | White |
| Chart background | No fill |
| Dashboard title | Left aligned |
| Subtitle | Left aligned |
| Visual hierarchy | KPI Cards → Charts → Insights → Recommendations |
| KPI internal padding | 8–10 pt |
| KPI corner radius | 6 pt |
| Footer alignment | Right aligned |
| Dashboard spacing | Consistent alignment and margins across all pages |

---

## KPI Card Standards

| Element | Standard |
|---|---|
| Background | Dark Navy |
| KPI Value | Gold |
| KPI Label | Muted Blue-Grey |
| Shape | Rounded rectangle |
| Border | None |
| Purpose | Highlight headline portfolio metrics consistently across dashboards |

---

## Chart Standards

| Element | Standard |
|---|---|
| Background | No fill |
| Border | None |
| Gridlines | Removed |
| Primary highlight | Gold |
| Highest-risk category | Red |
| Secondary categories | Light Grey |
| Stable / lowest-risk category | Dark Navy |
| Data-limitation category | Muted Blue-Grey |
| Data labels | Enabled where useful |
| Legends | Removed where redundant |
| Axes | Removed when unnecessary |
| Chart titles | Dark Navy, Bold |

---

## Insight and Recommendation Panel Standards

Each dashboard contains a dedicated business interpretation section.

**Insight Panel**

| Element | Standard |
|---|---|
| Background | Dark Navy |
| Heading | Gold |
| Body text | Muted Blue-Grey |
| Content | Three concise, evidence-based findings |

**Recommendation Panel**

| Element | Standard |
|---|---|
| Background | Dark Navy |
| Heading | Gold |
| Body text | Muted Blue-Grey |
| Content | Practical actions directly linked to the evidence |

The panels are included directly within the dashboards so that the key business interpretation is available without requiring the viewer to leave Tableau and consult the README or project documentation.

---

## Interactivity Standards

| Element | Standard |
|---|---|
| Global filters | Age Band, Risk Tier, Exposure Tier, Income Quartile |
| Filter position | Top-right of dashboard |
| Filter scope | Applied only to worksheets where filtering is analytically appropriate |
| Navigation | Consistent text-button navigation across all four dashboards |
| Tooltips | Custom tooltips on every worksheet |
| Annotations | Used for headline findings and important data-quality context |

Filters are deliberately scoped by worksheet where necessary.

Fixed analytical views, such as the High-Risk Borrower Profile, are excluded from filters where filtering would alter the intended analytical comparison or create misleading interpretations.

---

# Dashboard Documentation

---

## Dashboard 1 — Executive Overview

### Objective

Provide a high-level overview of portfolio default risk, financial exposure, and the interaction between behavioral risk and exposure.

### Dashboard Components

**KPI Cards**
- Total Borrowers
- Overall Default Rate
- Critical Risk Borrowers
- Critical Exposure Borrowers
- Peak Default Rate

**Supporting Visuals**
- Default Rate by Exposure Tier
- Risk × Exposure Default Rate Heatmap
- Default Rate by Risk Tier
- Portfolio Population by Age Band

**Insight Panel**

Highlights the three most important cross-pillar findings.

**Recommendation Panel**

Summarises the highest-priority underwriting and portfolio-monitoring actions.

### Business Story

Behavioral risk and financial exposure represent distinct dimensions of borrower risk that compound at the extremes.

Borrowers classified as Critical on both dimensions default at 55.0%, approximately 8.2 times the 6.68% portfolio baseline and materially above either dimension alone.

The Executive Overview therefore establishes the central finding of the project:

Risk is better understood through multiple interacting dimensions than through a single score or characteristic.

---

## Dashboard 2 — Borrower Default Risk

### Objective

Identify which borrower segments are most likely to default and surface the strongest behavioral early-warning signals.

### Dashboard Components

**KPI Cards**
- Total Borrowers
- Overall Default Rate
- Critical Risk Default Rate
- Highest Risk Default Rate
- Strongest Observed Risk Signal

**Supporting Charts**
- Default Rate by Delinquency Data-Error Flag
- Default Rate by Income Quartile
- High-Risk Borrower Profile (Age × Income Heatmap)
- Borrower Distribution by Risk Tier
- Default Rate by Age Band
- Default Rate by Delinquency History

**Insight Panel**

Summarises the strongest behavioral default drivers identified during SQL and Python analysis.

**Recommendation Panel**

Provides targeted actions focused on anomaly investigation, segment-level review, and early intervention.

### Business Story

Default risk is not evenly distributed across borrower segments.

Placeholder delinquency codes — although clearly anomalous — produced the strongest observed default signal in the dataset. Separately, the combination of age and income identifies materially higher-risk borrower segments, while a single 30–59 day delinquency is associated with a substantial increase in the likelihood of serious delinquency.

---

## Dashboard 3 — Financial Exposure Risk

### Objective

Evaluate pre-default financial exposure using credit utilization and debt burden in the absence of direct loan balance and credit-limit fields.

The dashboard also evaluates whether exposure signals add predictive value beyond behavioral payment history.

### Dashboard Components

**KPI Cards**
- Critical Exposure Default Rate
- Income-Missing Empirical Default Rate
- Invalid Utilization Default Rate
- Exposure Spread Within Low Risk Tier

**Supporting Charts**
- Default Rate by Credit Utilization
- Default Rate by Debt Ratio
- Borrower Distribution by Exposure Tier
- Exposure Risk Within Low Behavioral Risk

**Insight Panel**

Summarises the value of exposure-based signals and the data-quality limitations identified during analysis.

**Recommendation Panel**

Focuses on:
- Investigating anomalous exposure values
- Monitoring missing-income borrowers as a distinct segment
- Combining exposure indicators with behavioral risk

### Business Story

Exposure-based signals provide additional information beyond payment history alone.

Even within the Low behavioral risk tier, exposure tiers separate observed default rates by approximately 6.1×.

Two important data-quality limitations were also identified:
- Utilization becomes unreliable for borrowers with zero open credit lines.
- Debt ratio becomes difficult to interpret when income is missing.

These limitations were investigated and explicitly handled rather than silently discarded.

---

## Dashboard 4 — Operational Inefficiency

### Objective

Identify structural borrower patterns that may indicate weaknesses in approval criteria and underwriting processes.

### Dashboard Components

**KPI Cards**
- Zero Credit Lines Default Rate
- High Dependency Segment
- Average Defaulter Age
- Thin-File Risk Multiplier

**Supporting Charts**
- Defaulter vs Non-Defaulter Characteristics
- Default Rate by Open Credit Lines
- Default Rate by Dependents and Income

**Insight Panel**

Summarises structural differences between defaulters and non-defaulters.

**Recommendation Panel**

Focuses on:
- Flagging thin-file applicants
- Considering dependency burden alongside income
- Moving toward multi-factor approval criteria

### Business Story

Risk follows a U-shaped pattern across credit-line count.

Borrowers with zero open credit lines show the highest default rate among credit-line bands, while borrowers with the highest number of open lines also show elevated risk relative to the middle range.

Household dependency burden further compounds low-income risk, while defaulters and non-defaulters show consistent differences across age, income, credit lines, and dependents.

The combined evidence supports a move away from single-variable approval rules toward multi-factor borrower assessment.

---

# Dashboard Design Principles

### SQL and Python as the Computation Layer

Risk scores, Exposure Index components, and segment-level metrics are calculated in SQL and Python.

Tableau functions primarily as the presentation, interaction, and communication layer.

This reduces duplicated analytical logic and improves traceability between the underlying analysis and dashboard outputs.

---

### Single Source of Truth

Dashboard KPIs and visualizations are built from validated analytical outputs.

Every headline metric is traceable to the project's SQL segmentation, Python feature engineering, or validated processed datasets.

---

### Layered Reporting

The dashboard structure mirrors the analytical framework:

1. Borrower Default Risk
2. Financial Exposure Risk
3. Operational Inefficiency

The Executive Overview provides the portfolio-level synthesis before directing users into the supporting analytical pillars.

---

### Executive-First Storytelling

Each dashboard follows a consistent structure:

```text
Headline KPIs
      ↓
Supporting Evidence
      ↓
Key Insights
      ↓
Recommended Actions
```

This allows a stakeholder to understand the most important finding quickly while still providing access to supporting analytical detail.

---

### Data Quality as a Visible Finding

Data-quality issues are not automatically treated as noise.

Where anomalous values were identified, the analysis investigated whether they represented:
- Data-entry artifacts
- Placeholder values
- Measurement limitations
- Potentially meaningful risk signals

Relevant limitations and anomalies are surfaced through dashboard annotations, tooltips, distinct visual treatment, and insight-panel text.

---

### Consistent Visual Language

Colours, typography, spacing, KPI formatting, navigation, chart treatment, tooltips, and annotation conventions remain consistent across all four dashboards.

This creates a unified reporting experience rather than four unrelated dashboard pages.

---

### Minimalist Dashboard Design

Unnecessary gridlines, borders, redundant legends, and decorative elements were removed where they did not improve interpretation.

The design prioritises:
- Clear hierarchy
- Fast comprehension
- Evidence-based storytelling
- Consistent visual language
- Business usability

---

# Validation Summary

| Check | Result |
|---|---|
| Four dashboards completed | ✅ |
| Common design system applied | ✅ |
| Colour palette standardised | ✅ |
| Typography standardised | ✅ |
| KPI cards consistent across dashboards | ✅ |
| Chart formatting standardised | ✅ |
| Custom tooltips applied | ✅ |
| Key findings annotated | ✅ |
| Data-quality findings surfaced visually | ✅ |
| Business insight panels included | ✅ |
| Recommendation panels included | ✅ |
| Navigation consistent across all four dashboards | ✅ |
| Filter scope verified | ✅ |
| No unintended cross-worksheet filter leakage | ✅ |
| Dashboard metrics traceable to analytical outputs | ✅ |
| Dashboards reviewed for presentation readiness | ✅ |

---

# Outcome

A four-dashboard interactive reporting solution was successfully developed in Tableau.

The final reporting layer translates validated SQL segmentation, Python risk scoring, and Exposure Index calculations into an interactive business intelligence product.

The dashboard suite enables stakeholders to:
- Understand borrower default risk
- Identify early-warning signals
- Evaluate financial exposure
- Compare behavioral and exposure risk
- Identify structural underwriting risk
- Prioritise evidence-based actions

The dashboard layer completes the analytical workflow by transforming validated technical analysis into a stakeholder-facing decision-support product.

---

**Status:** Phase 5 complete — dashboards designed, built, documented, and validated.

*Project 08: Fintech Credit Risk Analysis — Framework: Borrower Default Risk · Financial Exposure Risk · Operational Inefficiency*
