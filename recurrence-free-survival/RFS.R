# ------------------------------------------------------------
# Load required R libraries
# survminer: used for visualizing survival curves
# survival: provides functions for survival analysis (Kaplan-Meier, Cox models)
# readxl: used to import Excel datasets
# ------------------------------------------------------------

library(readxl)
library(survival)
library(survminer)


# ------------------------------------------------------------
# Import recurrence-free survival dataset
# This is a placeholder path for the dataset.
# In practice, replace this with the location of your clinical dataset.
# ------------------------------------------------------------

RFS <- read_excel("data/recurrence_free_survival.xlsx")


# ------------------------------------------------------------
# Inspect the biomarker grouping variable
# Baseline_ctDNA indicates ctDNA status at baseline
# This helps verify that the grouping variable was read correctly
# ------------------------------------------------------------

RFS$Baseline_ctDNA


# ------------------------------------------------------------
# Fit Kaplan-Meier survival model
#
# Surv(RFS_Months, RFS_Status) creates the survival object
#
# RFS_Months  = follow-up time (in months)
# RFS_Status  = event indicator
#               1 = recurrence
#               0 = censored
#
# Baseline_ctDNA is used to stratify survival curves
# ------------------------------------------------------------

fit <- survfit(Surv(RFS_Months, RFS_Status) ~ Baseline_ctDNA, data = RFS)


# ------------------------------------------------------------
# Print Kaplan-Meier model results
# Shows number of patients, events, and survival probabilities
# ------------------------------------------------------------

print(fit)


# ------------------------------------------------------------
# Display detailed survival summary
# Provides survival probabilities and confidence intervals
# at each time point
# ------------------------------------------------------------

summary(fit)


# ------------------------------------------------------------
# Display only the survival summary table
# Useful for inspecting survival statistics by strata
# ------------------------------------------------------------

summary(fit)$table


# ------------------------------------------------------------
# Create a data frame containing Kaplan-Meier output values
# This table stores:
#
# time      = time points where events occur
# n.risk    = number of patients still at risk
# n.event   = number of recurrence events
# n.censor  = number of censored observations
# surv      = survival probability estimate
# upper/lower = confidence interval bounds
#
# This step is optional but useful for inspecting
# survival probabilities programmatically
# ------------------------------------------------------------

d <- data.frame(
  time = fit$time,
  n.risk = fit$n.risk,
  n.event = fit$n.event,
  n.censor = fit$n.censor,
  surv = fit$surv,
  upper = fit$upper,
  lower = fit$lower
)


# ------------------------------------------------------------
# Display first rows of Kaplan-Meier output table
# ------------------------------------------------------------

head(d)


# ------------------------------------------------------------
# Generate Kaplan-Meier survival plot
#
# Features included:
# - Log-rank test p-value
# - Risk table (number of patients at risk)
# - Custom colors for ctDNA groups
# - Median survival lines
# - Publication-style formatting
# ------------------------------------------------------------

ggsurvplot(
  fit,

  # Display log-rank p-value comparing survival curves
  pval = TRUE,

  # Display number of patients at risk table below plot
  risk.table = TRUE,

  # Color risk table values according to ctDNA group
  risk.table.col = "strata",

  # Remove risk table title
  risk.table.title = "",

  # Legend labels for ctDNA groups
  legend.labs = c("Baseline ctDNA (-)", "Baseline ctDNA (+)"),

  # Legend position
  legend = c(0.9, 1),

  # Remove legend title
  legend.title = "",

  # Plot title
  title = "Recurrence-Free Survival for ctDNA Patients",

  # Limit x-axis to 60 months
  xlim = c(0, 60),

  # Display tick marks every 12 months
  break.x.by = 12,

  # Use solid line style
  linetype = "solid",

  # Draw horizontal/vertical median survival lines
  surv.median.line = "hv",

  # Size of censoring tick marks
  censor.size = 0.5,

  # Line thickness
  size = 1,

  # Use clean publication-style theme
  ggtheme = theme_classic(),

  # Custom color palette
  # Blue = ctDNA negative
  # Red = ctDNA positive
  palette = c("#003399", "#FF0000")
)
