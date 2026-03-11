


# ------------------------------------------------------------
# Load required R libraries
# ggplot2: plotting
# dplyr: data wrangling
# rstatix: Games-Howell post hoc test
# readxl: import Excel file
# ------------------------------------------------------------

library(ggplot2)
library(dplyr)
library(rstatix)
library(readxl)


# ------------------------------------------------------------
# Load dataset from Excel
# Replace the file path with your actual local file path if needed
# ------------------------------------------------------------

Delta <- read_excel(
  "Data.xlsx",
  sheet = "Delta_Pretx-Posttx"
)


# ------------------------------------------------------------
# Optional: inspect the dataset
# ------------------------------------------------------------

View(Delta)


# ------------------------------------------------------------
# Remove rows where Delta_II is missing
# This ensures that all downstream analyses use valid Delta_II values
# ------------------------------------------------------------

Delta <- Delta %>%
  filter(!is.na(Delta_II))


# ------------------------------------------------------------
# Create analysis dataset with Delta_II not equal to 0
# This is the final analysis dataset used for statistical testing
# and plotting
# ------------------------------------------------------------

Delta_no_zero <- Delta %>%
  filter(Delta_II != 0)


# ------------------------------------------------------------
# Run Welch's ANOVA
# Welch's ANOVA is used instead of standard ANOVA because it does
# not assume equal variances across groups
# ------------------------------------------------------------

welch_anova_test <- oneway.test(
  Delta_II ~ Pathologic_Response,
  data = Delta_no_zero,
  var.equal = FALSE
)

print(welch_anova_test)


# ------------------------------------------------------------
# Format the Welch ANOVA p-value for display in the plot title
# ------------------------------------------------------------

p_value_text <- paste(
  "Welch's ANOVA p-value:",
  formatC(welch_anova_test$p.value, format = "e", digits = 2)
)


# ------------------------------------------------------------
# Perform Games-Howell post hoc test
# This is the preferred pairwise comparison after Welch's ANOVA
# because it does not assume equal variances or equal sample sizes
# ------------------------------------------------------------

pairwise_games_howell <- Delta_no_zero %>%
  games_howell_test(Delta_II ~ Pathologic_Response)

print(pairwise_games_howell)


# ------------------------------------------------------------
# Create final boxplot
# This uses the cleaned non-zero dataset and the visual style from
# your second code
# ------------------------------------------------------------

final_boxplot <- ggplot(
  Delta_no_zero,
  aes(x = factor(Pathologic_Response), y = Delta_II, fill = Pathologic_Response)
) +
  geom_boxplot(
    outlier.shape = NA,
    alpha = 0.7,
    width = 0.8
  ) +  # wider boxes, hide separate outlier symbols
  geom_jitter(
    width = 0.1,
    size = 2,
    alpha = 0.6
  ) +  # show individual observations with tighter jitter spread
  labs(
    x = "Pathologic Response",
    y = "Delta (Months)",
    title = paste("Comparing Post-Treatment Delta by Pathologic Response\n", p_value_text)
  ) +
  scale_fill_manual(
    values = c(
      "PD" = "#FF0000",
      "NR" = "#003399",
      "MPR" = "#009E73"
    ),
    name = "Pathologic Response"
  ) +
  scale_y_continuous(
    limits = c(-0.2, 0.2),
    breaks = seq(-0.2, 0.2, by = 0.05)
  ) +  # match your preferred final y-axis display
  theme(
    panel.background = element_blank(),
    axis.text.x = element_text(angle = 0, hjust = 0.5),
    axis.ticks = element_line(colour = "black"),
    axis.line = element_blank(),
    panel.border = element_rect(colour = "black", fill = NA, linewidth = 1),
    plot.title = element_text(hjust = 0.5, vjust = 1.2, face = "bold", size = 14),
    axis.title.y = element_text(vjust = 1),
    legend.position = "right",
    legend.title = element_text(face = "bold"),
    plot.margin = margin(10, 10, 10, 10)
  )


# ------------------------------------------------------------
# Print final boxplot
# ------------------------------------------------------------

print(final_boxplot)
