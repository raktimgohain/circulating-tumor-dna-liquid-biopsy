# Load required libraries for survival analysis and plotting
library(readxl)
library(survival)
library(survminer)

# Read the Excel file containing the overall survival dataset
OS_all <- read_excel("data/overall_survival.xlsx")

# Inspect the Baseline_ctDNA column to confirm the grouping variable
OS_all$Baseline_ctDNA

# Fit the Kaplan-Meier survival model
# Surv(OS_Months, survival_status) defines the survival object:
# - OS_Months = follow-up time
# - survival_status = event indicator (for example, 1 = death, 0 = censored)
# Baseline_ctDNA is the grouping variable used to compare survival curves
fit <- survfit(Surv(OS_Months, survival_status) ~ Baseline_ctDNA, data = OS_all)

# Print the fitted Kaplan-Meier model summary
print(fit)

# Display a detailed summary of the survival fit
summary(fit)

# Display the survival summary table only
summary(fit)$table

# Create a data frame containing the Kaplan-Meier output values
# This is useful if you want to inspect survival probabilities,
# number at risk, number of events, and confidence intervals manually
d <- data.frame(
  time = fit$time,
  n.risk = fit$n.risk,
  n.event = fit$n.event,
  n.censor = fit$n.censor,
  surv = fit$surv,
  upper = fit$upper,
  lower = fit$lower
)

# View the first few rows of the Kaplan-Meier output table
head(d)

# Generate the Kaplan-Meier survival plot
# This includes:
# - log-rank p-value
# - risk table
# - custom colors
# - median survival lines
# - 12-month x-axis intervals
km_plot <- ggsurvplot(
  fit,
  pval = TRUE,
  risk.table = TRUE,                         # Add risk table below the plot
  risk.table.col = "strata",                 # Color risk table text by group
  risk.table.title = "",                     # Remove risk table title
  legend.labs = c("Baseline ctDNA (-)", "Baseline ctDNA (+)"),
  legend = c(0.9, 1),                        # Position legend inside plot area
  legend.title = "",                         # Remove legend title
  title = "Overall survival (full cohort)",
  break.x.by = 12,                           # Show x-axis breaks every 12 months
  xlim = c(0, 60),                           # Restrict x-axis from 0 to 60 months
  linetype = "solid",                        # Use solid lines for both groups
  surv.median.line = "hv",                   # Add horizontal and vertical median lines
  censor.size = 0.5,                         # Size of censor marks
  size = 1,                                  # Line thickness
  ggtheme = theme_classic(),                 # Use a clean classic theme
  palette = c("#003399", "#FF0000")          # Blue for ctDNA (-), red for ctDNA (+)
)

# Print the Kaplan-Meier plot to the plotting window
print(km_plot)

# Save the full Kaplan-Meier plot including the risk table
png("figures/GitHub_Overall_Survival.png", width = 7, height = 6, units = "in", res = 300)
print(km_plot)
dev.off()
