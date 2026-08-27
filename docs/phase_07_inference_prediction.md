# Phase 7 — Statistical Inference & Predictive Modeling

**Date:** 2026-08-27  
**Status:** ✅ Complete  
**Core Question:** Is the risk_tier separation established in Phase 2 statistically significant, and can default risk be predicted from features already validated in Phases 2 and 3?  
**Notebook:** `notebooks/07_inference_and_prediction.ipynb`  
**Input:** `data/processed/cs_training_exposure_scored.csv`

---

## Overview

Phases 2 and 3 established default rate differences across risk_tier
and exposure_tier using observed percentages and cross-tabulation.
This phase extends that work in two directions: formally testing
whether the observed association is statistically distinguishable
from independence, and building a predictive model that estimates
default risk from the same validated features. This phase does not
modify or replace the existing Tableau dashboards.

---

# Statistical Inference — Risk Tier Separation

## Chi-Square Test (All Tiers)

Tests independence between risk_tier and SeriousDlqin2yrs across all
four tiers.

| Statistic | Value |
|:---|---:|
| Chi-square | 21521.39 |
| Degrees of freedom | 3 |
| p-value | < 0.001 |

### Finding

The null hypothesis of independence is rejected. risk_tier and
default status are not independent.

## Two-Proportion Z-Test (Low vs. Critical)

| Statistic | Value |
|:---|---:|
| Low default rate | 2.23% |
| Critical default rate | 47.11% |
| Z-statistic | -133.82 |
| p-value | < 0.001 |
| 95% CI for the difference | (43.5%, 46.2%) |

### Finding

The default rate gap between Low and Critical risk tiers is
statistically significant and large in magnitude — the 95%
confidence interval excludes zero by a wide margin.

---

# Predictive Modeling — Default-Risk Prediction

## Feature Preparation

Features: risk_tier and exposure_tier (one-hot encoded, Low as
reference category), delinquency_data_error_flag,
RevolvingUtilizationOfUnsecuredLines, age.

income_missing was excluded from the feature set. Phase 3 defines
exposure_tier as "Indeterminate" exactly when income is missing,
making the two features redundant; including both caused the model
to fail to estimate standard errors for several coefficients.

Two logistic regression implementations were used for complementary
purposes: statsmodels was used to examine coefficient estimates and
statistical significance (unweighted fit), while scikit-learn was
used for train/test evaluation with class_weight='balanced' to
address class imbalance. These are two separate fits, not one model
used twice.

## Coefficient Interpretation (statsmodels)

| Feature | Coefficient | p-value |
|:---|---:|---:|
| risk_tier_Critical | 3.1953 | < 0.001 |
| risk_tier_High | 1.8537 | < 0.001 |
| risk_tier_Medium | 0.2762 | < 0.001 |
| exposure_tier_Critical | 1.2168 | < 0.001 |
| exposure_tier_High | 1.0071 | < 0.001 |
| exposure_tier_Moderate | 0.8773 | < 0.001 |
| exposure_tier_Indeterminate | 0.1994 | < 0.001 |
| age | -0.0244 | < 0.001 |
| delinquency_data_error_flag | 0.0856 | 0.555 |
| RevolvingUtilizationOfUnsecuredLines | -0.00004 | 0.541 |

Pseudo R-squared: 0.2143

### Finding

All risk_tier and exposure_tier coefficients are positive and highly
significant, with larger positive coefficients generally
corresponding to more severe tiers — consistent with the default
rates validated in Phases 2 and 3. age is negative and significant,
consistent with the Phase 2 finding that default risk decreases with
age.

delinquency_data_error_flag and RevolvingUtilizationOfUnsecuredLines
are not significant in this model. Both are components already
absorbed into the tier variables: flagged borrowers were
automatically assigned to risk_tier Critical in Phase 2, and
utilization was one of two inputs to exposure_index in Phase 3. Once
the engineered tier variables are included, the individual
contribution of these underlying variables is no longer statistically
distinguishable in this specification — not evidence that utilization
or delinquency history are unimportant.

## Model Evaluation (scikit-learn)

80/20 stratified train/test split, class_weight='balanced' to
account for the 6.68% positive class rate.

| Metric | Value |
|:---|---:|
| Recall (defaulters) | 72% |
| Precision (defaulters) | 20% |
| AUC | 0.8349 |
| Gini | 0.6699 |

### Finding

The model correctly identifies 72% of actual defaulters, at a
precision of 20% — for every 5 borrowers flagged, roughly 1 defaults.
This reflects the balanced class weighting, which prioritizes
catching defaulters over minimizing false alarms, consistent with a
screening tool rather than a final decision-maker.

The model achieved an AUC of 0.8349 (Gini = 0.6699), indicating
strong discrimination between defaulters and non-defaulters on the
held-out test set.

---

# Business Interpretation

The model predicts default risk and produces probability estimates
from logistic regression; these outputs are not treated as
calibrated Probability of Default (PD) estimates because class
weighting was used during training. The model is therefore used for
default-risk ranking and screening rather than as a source of
calibrated PD estimates without further calibration.

A full Expected Loss figure (EL = PD × LGD × EAD) is not computable
from this dataset, since it contains no loan balance, credit limit,
or recovery data needed to estimate Loss Given Default or Exposure
at Default.

Because risk_tier and exposure_tier are engineered variables derived
from underlying borrower characteristics, their strong predictive
performance is interpreted as validation of the constructed
segmentation methodology, not as independent evidence that these
variables are causally responsible for default.

---

# Key Findings

- ✅ risk_tier default rate separation is statistically significant
  (χ² = 21521.39, df = 3, p < 0.001)
- ✅ Low vs. Critical default rate gap: 95% CI (43.5%, 46.2%),
  z = -133.82, p < 0.001
- ✅ Logistic regression identifies risk_tier and exposure_tier as
  the dominant predictors in this model, with larger positive
  coefficients generally corresponding to more severe tiers
- ✅ delinquency_data_error_flag and utilization lose significance
  once tier variables are included — their signal is already
  captured, not lost
- ✅ Model achieves AUC 0.8349 / Gini 0.6699, indicating strong
  discrimination on the held-out test set
- ✅ Model outputs are default-risk scores, not calibrated PD;
  full Expected Loss is not computable without LGD/EAD data

---

# Outputs Generated

- `outputs/chart_roc_curve.png`
- `notebooks/07_inference_and_prediction.ipynb`

---

# Phase Summary

**Objectives Completed**

- ✅ Statistical significance testing of risk_tier separation
- ✅ Two-proportion z-test with confidence interval, Low vs. Critical
- ✅ Predictive model (logistic regression) for default-risk scoring
- ✅ Coefficient-sign and significance validation against Phase 2/3
  findings
- ✅ Model evaluation: confusion matrix, precision/recall, AUC, Gini
- ✅ ROC curve exported