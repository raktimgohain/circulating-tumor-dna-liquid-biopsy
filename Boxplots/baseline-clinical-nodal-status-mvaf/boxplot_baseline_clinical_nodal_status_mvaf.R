# ------------------------------------------------------------
# Load required R libraries
# readxl: used to import Excel datasets
# dplyr: used for data manipulation if needed
# ggplot2: used for boxplot visualization
# ------------------------------------------------------------

library(readxl)
library(dplyr)
library(ggplot2)


# ------------------------------------------------------------
# Import dataset
# This is a placeholder file path.
# Replace this with the location of your actual dataset.
# ------------------------------------------------------------

data <- read_excel("data/baseline_clinical_nodal_status_mvaf.xlsx")


# ------------------------------------------------------------
# Inspect the clinical nodal status variable
# cN is the grouping variable used in this analysis
# Example groups:
# LN- = clinically node-negative
# LN+ = clinically node-positive
# ------------------------------------------------------------

data$cN


# ------------------------------------------------------------
# Perform Wilcoxon rank-sum test
#
# This compares baseline ctDNA mVAF values between the two cN groups.
# The Wilcoxon test is used because:
# - mVAF values are often highly skewed
# - mVAF values are very small and not normally distributed
# - the test is non-parametric and does not assume normality
# ------------------------------------------------------------

wilcox_test <- wilcox.test(Baseline_ctDNA_mVAF ~ cN, data = data)


# ------------------------------------------------------------
# Print Wilcoxon test results
# ------------------------------------------------------------

wilcox_test


# ------------------------------------------------------------
# Extract p-value from the Wilcoxon test result
# ------------------------------------------------------------

p_value <- wilcox_test$p.value


# ------------------------------------------------------------
# Format p-value text for plot annotation
# This creates a cleaner title label depending on the p-value size
# ------------------------------------------------------------

if (p_value < 0.0001) {
  p_value_text <- "Wilcoxon P < 0.0001"
} else if (p_value < 0.001) {
  p_value_text <- "Wilcoxon P < 0.001"
} else {
  p_value_text <- paste("Wilcoxon P =", round(p_value, 4))
}


# ------------------------------------------------------------
# Optional: Create boxplot on original scale
# This version may be harder to interpret when values are extremely small
# ------------------------------------------------------------

ggplot(data, aes(x = factor(cN), y = Baseline_ctDNA_mVAF, fill = factor(cN))) +
  geom_boxplot(outlier.shape = NA, alpha = 0.5) +   # Draw boxplots without separate outlier symbols
  geom_jitter(width = 0.2, size = 2, alpha = 0.6, color = "black") +   # Show individual data points
  labs(
    x = "Clinical Node (cN)",
    y = "Baseline ctDNA mVAF",
    title = paste0("Baseline ctDNA mVAF by Clinical Node (", p_value_text, ")")
  ) +
  scale_fill_manual(values = c("LN+" = "navy", "LN-" = "grey")) +   # Set custom colors for groups
  theme_minimal() +
  theme(
    panel.border = element_rect(colour = "black", fill = NA, size = 1),
    axis.text.x = element_text(angle = 0, hjust = 0.5),
    axis.ticks = element_line(colour = "black"),
    plot.title = element_text(hjust = 0, vjust = 1, face = "bold", size = 14),
    legend.position = "none"
  )


# ------------------------------------------------------------
# Create boxplot on log10 scale
#
# This is the preferred version for visualization because:
# - mVAF values are extremely small
# - the log scale spreads out small values more clearly
# - differences between groups become easier to visualize
# ------------------------------------------------------------

mvaf_plot <- ggplot(data, aes(x = factor(cN), y = Baseline_ctDNA_mVAF, fill = factor(cN))) +
  geom_boxplot(outlier.shape = NA, alpha = 0.5) +   # Draw boxplots without separate outlier symbols
  geom_jitter(width = 0.2, size = 2, alpha = 0.6, color = "black") +   # Show individual data points
  scale_y_log10() +   # Apply log10 scaling to the y-axis
  labs(
    x = "Clinical Node (cN)",
    y = "Baseline ctDNA mVAF (log10 scale)",
    title = "Maximum variant allele fractions (mVAFs) of baseline ctDNA detection by lymph node involvement for locally-advanced patients"
  ) +
  scale_fill_manual(values = c("LN+" = "navy", "LN-" = "grey")) +   # Set custom colors
  theme(
    panel.background = element_blank(),   # Remove background shading
    panel.grid.major = element_blank(),   # Remove major grid lines
    panel.grid.minor = element_blank(),   # Remove minor grid lines
    panel.border = element_rect(colour = "black", fill = NA, size = 1),   # Add black border
    axis.text.x = element_text(angle = 0, hjust = 0.5),
    axis.ticks = element_line(colour = "black"),
    plot.title = element_text(hjust = 0, vjust = 1, face = "plain", size = 14),
    legend.position = "right"
  )


# ------------------------------------------------------------
# Print the final log-scale boxplot
# ------------------------------------------------------------

print(mvaf_plot)


# ------------------------------------------------------------
# Save the final plot for GitHub or manuscript use
# ------------------------------------------------------------

ggsave(
  filename = "baseline-clinical-nodal-status-mvaf/GitHub_Baseline_Clinical_Nodal_Detection_by_mVAF.png",
  plot = mvaf_plot,
  width = 8,
  height = 10,
  dpi = 300
)
