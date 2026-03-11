# ------------------------------------------------------------
# Load required R libraries
# readxl: import Excel data
# dplyr: data manipulation
# ggplot2: plotting
# tidyr: reshaping if needed
# ------------------------------------------------------------

library(readxl)
library(dplyr)
library(ggplot2)
library(tidyr)


# ------------------------------------------------------------
# Import swimmer plot dataset
# This is a placeholder file path.
# Replace with the actual location of your dataset.
# ------------------------------------------------------------

swim <- read_excel("data/swimmers_plot_longitudinal_ctdna.xlsx")


# ------------------------------------------------------------
# Optional: inspect the dataset
# ------------------------------------------------------------

View(swim)


# ------------------------------------------------------------
# Step 1: Reorder patients
#
# Logic:
# Patients are ordered primarily by the earliest important event
# (recurrence or death), so patients with earlier events appear
# higher in the plot.
#
# For patients without an event, ordering is based on their last
# available follow-up month.
# ------------------------------------------------------------

dat_reorder <- swim %>%
  group_by(ID_new) %>%
  mutate(
    earliest_event_month = if_else(
      any(Recurrence == 1 | Death == 1, na.rm = TRUE),
      min(Month[Recurrence == 1 | Death == 1], na.rm = TRUE),
      NA_real_
    ),
    last_month = max(Month, na.rm = TRUE)
  ) %>%
  ungroup() %>%
  mutate(
    ordering_month = if_else(!is.na(earliest_event_month), earliest_event_month, last_month),
    ID_new = factor(
      ID_new,
      levels = rev(unique(ID_new[order(ordering_month)]))
    )
  )


# ------------------------------------------------------------
# Step 2: Create plotting helper columns
#
# These columns assign Month values only when a particular event,
# biomarker status, or pathologic response is present.
#
# If the condition is absent, NA is used so nothing is plotted.
# ------------------------------------------------------------

dat_swim <- dat_reorder %>%
  mutate(
    ctDNA_not_detected_this_month = if_else(ctDNA_not_Detected == 1, Month, NA_real_),
    ctDNA_detected_this_month     = if_else(ctDNA_Detected == 1, Month, NA_real_),

    MPR_this_month = if_else(MPR == 1, Month, NA_real_),
    NR_this_month  = if_else(NR == 1, Month, NA_real_),
    PD_this_month  = if_else(PD == 1, Month, NA_real_),

    Recurrence_this_month = if_else(Recurrence == 1, Month, NA_real_),
    Death_this_month      = if_else(Death == 1, Month, NA_real_)
  )


# ------------------------------------------------------------
# Step 3: Create treatment segment dataset
#
# The uploaded swimmer plot shows colored horizontal bars representing
# treatment exposures over time.
#
# This code assumes your dataset contains:
# - segment_start
# - segment_end
# - Treatment_Group
#
# Example Treatment_Group values:
# - Chemo
# - Chemo + RT
# - Chemo + Trastuzumab
# - Chemo + IO
# - Chemo + IO + RT
# - IO
#
# If your actual column names differ, replace them here.
# ------------------------------------------------------------

dat_treatment <- dat_swim %>%
  filter(!is.na(segment_start), !is.na(segment_end), !is.na(Treatment_Group))


# ------------------------------------------------------------
# Step 4: Create subtype annotation dataset
#
# The uploaded figure shows colored subtype blocks near baseline.
#
# This code assumes one subtype label per patient:
# - CIN
# - GS
# - MSI
# ------------------------------------------------------------

dat_subtype <- dat_swim %>%
  group_by(ID_new) %>%
  slice(1) %>%
  ungroup() %>%
  mutate(
    subtype_x = -0.15
  )


# ------------------------------------------------------------
# Step 5: Define colors for all plotted elements
# ------------------------------------------------------------

cols_points <- c(
  "ctDNA Detected" = "#2E4DA7",
  "ctDNA not Detected" = "#163D1F",
  "MPR" = "#3F3AA8",
  "NR" = "#0D7A7A",
  "Progressive Disease" = "#C4471C",
  "Recurrence" = "#FF0000",
  "Death" = "#000000"
)

cols_treatment <- c(
  "Chemo" = "#9ED9C8",
  "Chemo + RT" = "#7DB6E8",
  "Chemo + Trastuzumab" = "#6C8D74",
  "Chemo + IO" = "#B68AA0",
  "Chemo + IO + RT" = "#6E6F83",
  "IO" = "#66B24A"
)

cols_subtype <- c(
  "CIN" = "#7B5AA6",
  "GS"  = "#6DBB45",
  "MSI" = "#15A8E0"
)


# ------------------------------------------------------------
# Step 6: Create the swimmer plot
# ------------------------------------------------------------

p <- ggplot() +

  # ----------------------------------------------------------
  # Grey base follow-up line for each patient
  # ----------------------------------------------------------
  geom_line(
    data = dat_swim,
    aes(x = Month, y = ID_new, group = ID_new),
    color = "#D3D3D3",
    linewidth = 1.6
  ) +

  # ----------------------------------------------------------
  # Treatment-colored line segments
  # ----------------------------------------------------------
  geom_segment(
    data = dat_treatment,
    aes(
      x = segment_start,
      xend = segment_end,
      y = ID_new,
      yend = ID_new,
      color = Treatment_Group
    ),
    linewidth = 5,
    lineend = "butt"
  ) +

  # ----------------------------------------------------------
  # Baseline subtype block near the left edge
  # ----------------------------------------------------------
  geom_tile(
    data = dat_subtype,
    aes(x = subtype_x, y = ID_new, fill = Subtype),
    width = 0.22,
    height = 0.8
  ) +

  # ----------------------------------------------------------
  # ctDNA not detected markers
  # ----------------------------------------------------------
  geom_point(
    data = dat_swim,
    aes(x = ctDNA_not_detected_this_month, y = ID_new, color = "ctDNA not Detected"),
    shape = 1,
    stroke = 1.3,
    size = 2.2
  ) +

  # ----------------------------------------------------------
  # ctDNA detected markers
  # ----------------------------------------------------------
  geom_point(
    data = dat_swim,
    aes(x = ctDNA_detected_this_month, y = ID_new, color = "ctDNA Detected"),
    shape = 19,
    size = 2.2
  ) +

  # ----------------------------------------------------------
  # Pathologic response markers
  # ----------------------------------------------------------
  geom_point(
    data = dat_swim,
    aes(x = MPR_this_month, y = ID_new, color = "MPR"),
    shape = 17,
    size = 2.8
  ) +
  geom_point(
    data = dat_swim,
    aes(x = NR_this_month, y = ID_new, color = "NR"),
    shape = 17,
    size = 2.8
  ) +
  geom_point(
    data = dat_swim,
    aes(x = PD_this_month, y = ID_new, color = "Progressive Disease"),
    shape = 17,
    size = 2.8
  ) +

  # ----------------------------------------------------------
  # Recurrence markers
  # ----------------------------------------------------------
  geom_point(
    data = dat_swim,
    aes(x = Recurrence_this_month, y = ID_new, color = "Recurrence"),
    shape = 5,
    stroke = 1.3,
    size = 2.8
  ) +

  # ----------------------------------------------------------
  # Death markers
  # ----------------------------------------------------------
  geom_point(
    data = dat_swim,
    aes(x = Death_this_month, y = ID_new, color = "Death"),
    shape = 15,
    size = 3
  ) +

  # ----------------------------------------------------------
  # Optional arrowhead markers for ongoing follow-up
  #
  # Assumes a column named ongoing_followup == 1 for patients
  # whose line ends without recurrence/death.
  # ----------------------------------------------------------
  geom_point(
    data = dat_swim %>% filter(ongoing_followup == 1),
    aes(x = Month, y = ID_new),
    shape = 4,
    color = "#D3D3D3",
    size = 3
  ) +

  # ----------------------------------------------------------
  # X-axis formatting to match uploaded plot
  # ----------------------------------------------------------
  scale_x_continuous(
    breaks = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11),
    labels = c(
      "Pre-Tx", "Post-IC", "Post-Tx", "Surgery", "Post-OP",
      "3–6mo", "6–9mo", "9–12mo", "12–15mo", "15–18mo", "18–21mo", "21–24mo"
    ),
    expand = expansion(mult = c(0.02, 0.02))
  ) +

  # ----------------------------------------------------------
  # Color scales
  # ----------------------------------------------------------
  scale_color_manual(
    values = c(cols_points, cols_treatment),
    name = "Legend"
  ) +
  scale_fill_manual(
    values = cols_subtype,
    name = "Subtype"
  ) +

  # ----------------------------------------------------------
  # Axis labels and theme
  # ----------------------------------------------------------
  labs(
    x = "Timepoint",
    y = "Patient"
  ) +
  theme_bw() +
  theme(
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_blank(),
    axis.title = element_text(face = "bold", size = 16),
    axis.text.x = element_text(size = 10),
    axis.text.y = element_text(size = 8),
    legend.title = element_text(face = "bold", size = 12),
    legend.text = element_text(size = 9),
    legend.background = element_rect(color = "black", fill = "white"),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 1)
  )

print(p)


# ------------------------------------------------------------
# Step 7: Save the swimmer plot
# ------------------------------------------------------------

ggsave(
  filename = "swimmers-plot-longitudinal-ctdna/GitHub_Swimmers_Plot.png",
  plot = p,
  width = 14,
  height = 12,
  dpi = 300
)
