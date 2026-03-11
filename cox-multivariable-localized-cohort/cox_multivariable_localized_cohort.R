# ------------------------------------------------------------
# Cox Multivariable Model for Localized Cohort
#
# This script performs:
# 1. Univariate Cox regression for each independent variable
# 2. Multivariable Cox regression including all selected variables
# 3. Forest plot visualization of the multivariable model
#
# Variables included:
# - clinical_stage_merged
# - Baseline_Alteration
# - lymph_node
#
# Outcome:
# - Overall Survival (OS)
# ------------------------------------------------------------


# ------------------------------------------------------------
# Load required R libraries
# dplyr: data manipulation
# survival: Cox proportional hazards modeling
# survminer: forest plot visualization
# readxl: import Excel data
# ------------------------------------------------------------

library(dplyr)
library(survival)
library(survminer)
library(readxl)


# ------------------------------------------------------------
# Import localized cohort dataset from Excel
# This is a placeholder path.
# Replace it with the actual location of your file.
# ------------------------------------------------------------

data_local <- read_excel(
  "data/cox_multivariable_localized_cohort.xlsx",
  sheet = "Cox_cstage_merged"
)


# ------------------------------------------------------------
# Optional: inspect the imported dataset
# ------------------------------------------------------------

View(data_local)


# ------------------------------------------------------------
# Convert imported tibble to a standard dataframe
# Some survival/modeling functions work more predictably with data.frame
# ------------------------------------------------------------

cox_dataframe <- as.data.frame(data_local)


# ------------------------------------------------------------
# Optional: inspect the dataframe
# ------------------------------------------------------------

cox_dataframe


# ------------------------------------------------------------
# Convert predictor variables to factors with readable labels
#
# clinical_stage_merged:
#   original levels = 2, 3, 4
#   labels = Stage 2, Stage 3, Stage 4
#
# Baseline_Alteration:
#   0 = Negative
#   1 = Positive
#
# lymph_node:
#   0 = Negative
#   1 = Positive
# ------------------------------------------------------------

cox_dataframe$clinical_stage_merged <- factor(
  cox_dataframe$clinical_stage_merged,
  levels = c(2, 3, 4),
  labels = c("Stage 2", "Stage 3", "Stage 4")
)

cox_dataframe$Baseline_Alteration <- factor(
  cox_dataframe$Baseline_Alteration,
  levels = c(0, 1),
  labels = c("Negative", "Positive")
)

cox_dataframe$lymph_node <- factor(
  cox_dataframe$lymph_node,
  levels = c(0, 1),
  labels = c("Negative", "Positive")
)


# ------------------------------------------------------------
# Univariate Cox regression: clinical stage only
#
# Surv(OS_Months, survival_status) defines the survival object:
# - OS_Months = follow-up time in months
# - survival_status = event indicator
#                     1 = death
#                     0 = censored
#
# This model evaluates whether clinical stage alone is associated
# with overall survival.
# ------------------------------------------------------------

res.cox <- coxph(
  Surv(OS_Months, survival_status) ~ clinical_stage_merged,
  data = cox_dataframe
)

summary(res.cox)


# ------------------------------------------------------------
# Univariate Cox regression: baseline ctDNA detection only
#
# This model evaluates whether baseline ctDNA detection status
# is associated with overall survival.
# ------------------------------------------------------------

res.cox <- coxph(
  Surv(OS_Months, survival_status) ~ Baseline_Alteration,
  data = cox_dataframe
)

summary(res.cox)


# ------------------------------------------------------------
# Univariate Cox regression: lymph node status only
#
# This model evaluates whether baseline lymph node status
# is associated with overall survival.
# ------------------------------------------------------------

res.cox <- coxph(
  Surv(OS_Months, survival_status) ~ lymph_node,
  data = cox_dataframe
)

summary(res.cox)


# ------------------------------------------------------------
# Multivariable Cox regression model
#
# This model includes all selected predictors simultaneously:
# - clinical stage
# - baseline ctDNA detection
# - lymph node status
#
# The goal is to estimate the independent association of each
# variable with overall survival while adjusting for the others.
# ------------------------------------------------------------

fit <- coxph(
  Surv(OS_Months, survival_status) ~ clinical_stage_merged +
    Baseline_Alteration +
    lymph_node,
  data = cox_dataframe
)


# ------------------------------------------------------------
# Print multivariable model object
# ------------------------------------------------------------

fit


# ------------------------------------------------------------
# Display full multivariable Cox model summary
#
# This output includes:
# - hazard ratios
# - confidence intervals
# - Wald test p-values
# - model concordance
# - likelihood ratio / score / Wald tests
# ------------------------------------------------------------

summary(fit)


# ------------------------------------------------------------
# Generate forest plot of multivariable Cox model
#
# ggforest() creates a visual summary of:
# - hazard ratio estimates
# - 95% confidence intervals
# - reference categories
# - p-values
# ------------------------------------------------------------

ggforest(fit, data = cox_dataframe)
