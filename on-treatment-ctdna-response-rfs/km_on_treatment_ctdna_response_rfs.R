# ------------------------------------------------------------
# Load required R libraries
# survminer: used for Kaplan-Meier plotting and pairwise log-rank tests
# survival: used for survival objects and Kaplan-Meier model fitting
# readxl: used to import Excel datasets
# ------------------------------------------------------------

library(readxl)
library(survival)
library(survminer)


# ------------------------------------------------------------
# Import dataset
# This is a placeholder file path.
# Replace this with the location of your actual dataset.
# ------------------------------------------------------------

survival_groups <- read_excel("data/on_treatment_ctdna_response_rfs.xlsx")


# ------------------------------------------------------------
# Inspect the grouping variable
# Converted defines the three ctDNA response groups used in this analysis
# ------------------------------------------------------------

survival_groups$Converted


# ------------------------------------------------------------
# Fit Kaplan-Meier survival model
#
# Surv(RFS_Months, RFS_Status) creates the survival object
#
# RFS_Months = recurrence-free survival follow-up time in months
# RFS_Status = event indicator
#              1 = recurrence event
#              0 = censored
#
# Converted is the grouping variable:
# 0 = baseline undetectable ctDNA
# 1 = detected at baseline, then converted to undetectable on treatment
# 2 = persistently detectable ctDNA from baseline onward
# ------------------------------------------------------------

fit <- survfit(Surv(RFS_Months, RFS_Status) ~ Converted, data = survival_groups)


# ------------------------------------------------------------
# Print Kaplan-Meier model summary
# ------------------------------------------------------------

print(fit)


# ------------------------------------------------------------
# Display detailed survival summary
# ------------------------------------------------------------

summary(fit)


# ------------------------------------------------------------
# Display survival summary table only
# ------------------------------------------------------------

summary(fit)$table


# ------------------------------------------------------------
# Create a data frame containing Kaplan-Meier output values
# This allows manual inspection of:
# - event times
# - number at risk
# - number of events
# - number censored
# - survival probabilities
# - confidence interval bounds
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
# Display first rows of the Kaplan-Meier output table
# ------------------------------------------------------------

head(d)


# ------------------------------------------------------------
# Generate Kaplan-Meier recurrence-free survival plot
#
# This plot includes:
# - log-rank p-value
# - risk table
# - custom colors for the three ctDNA groups
# - median survival reference lines
# - recurrence-free survival on the y-axis
# ------------------------------------------------------------

km_plot <- ggsurvplot(
  fit,

  # Show log-rank p-value
  pval = TRUE,

  # Add risk table below the plot
  risk.table = TRUE,

  # Color the risk table text according to survival group
  risk.table.col = "strata",

  # Remove risk table title
  risk.table.title = "",

  # Labels for the three ctDNA groups
  legend.labs = c(
    "Baseline undetectable ctDNA",
    "Converted detected to undetectable ctDNA",
    "Persistent detectable ctDNA"
  ),

  # Position legend inside the plot area
  legend = c(0.9, 1),

  # Remove legend title
  legend.title = "",

  # Plot title
  title = "Recurrence-Free Survival Among Patients With Locally Advanced Disease Based on On-Treatment ctDNA Detection",

  # X-axis range
  xlim = c(0, 60),

  # X-axis tick marks every 12 months
  break.x.by = 12,

  # Use solid line type for all groups
  linetype = "solid",

  # Add horizontal and vertical median survival lines
  surv.median.line = "hv",

  # Size of censor marks
  censor.size = 0.5,

  # Line thickness
  size = 1,

  # Y-axis label
  ylab = "Recurrence-free survival",

  # Use classic publication-style theme
  ggtheme = theme_classic(),

  # Color palette:
  # Blue  = baseline undetectable ctDNA
  # Green = converted detected to undetectable ctDNA
  # Red   = persistent detectable ctDNA
  palette = c("#003399", "#006633", "#FF0000")
)


# ------------------------------------------------------------
# Print the Kaplan-Meier plot
# ------------------------------------------------------------

print(km_plot)


# ------------------------------------------------------------
# Save the full plot including risk table
# PNG device is used here because it reliably saves
# the entire ggsurvplot object with the risk table.
# ------------------------------------------------------------

png(
  "on-treatment-ctdna-response-rfs/GitHub_On_Treatment_ctDNA_RFS.png",
  width = 8,
  height = 7,
  units = "in",
  res = 300
)
print(km_plot)
dev.off()


# ------------------------------------------------------------
# Pairwise log-rank tests between the three groups
# p.adjust.method = "none" gives unadjusted p-values
# ------------------------------------------------------------

pairwise_results <- pairwise_survdiff(
  Surv(RFS_Months, RFS_Status) ~ Converted,
  data = survival_groups,
  p.adjust.method = "none"
)


# ------------------------------------------------------------
# Print pairwise p-values
# This helps identify which specific groups differ
# ------------------------------------------------------------

print(pairwise_results$p.value)


# ------------------------------------------------------------
# Optional additional visualization:
# Compare only group 0 vs group 1
#
# 0 = baseline undetectable ctDNA
# 1 = converted detected to undetectable ctDNA
# ------------------------------------------------------------

subset_data <- subset(survival_groups, Converted %in% c(0, 1))

fit_subset <- survfit(
  Surv(RFS_Months, RFS_Status) ~ Converted,
  data = subset_data
)

ggsurvplot(
  fit_subset,
  pval = TRUE,
  ylab = "Recurrence-free survival",
  ggtheme = theme_classic()
)
