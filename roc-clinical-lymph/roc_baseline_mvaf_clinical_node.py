# ------------------------------------------------------------
# ROC Analysis: Baseline ctDNA Max VAF vs Clinical Node Status
#
# This script evaluates how well baseline ctDNA maximum VAF
# discriminates between clinical node-positive and
# clinical node-negative patients in the localized cohort.
#
# Workflow:
# 1. Load dataset
# 2. Filter to localized cohorts
# 3. Convert clinical node status to binary
# 4. Compute ROC curve and AUC
# 5. Identify optimal threshold using Youden's J statistic
# 6. Calculate classification metrics at the optimal threshold
# 7. Plot and save the ROC curve
# ------------------------------------------------------------


# ------------------------------------------------------------
# Import required Python libraries
# pandas: data handling
# numpy: numerical operations
# matplotlib: plotting
# sklearn.metrics: ROC, AUC, confusion matrix, and performance metrics
# ------------------------------------------------------------

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.metrics import roc_curve, auc, confusion_matrix, accuracy_score, recall_score, precision_score


# ------------------------------------------------------------
# Load dataset
# Replace this dummy path with your actual local file path if needed
# ------------------------------------------------------------

file_path = "data/roc_baseline_mvaf_clinical_node.csv"
df = pd.read_csv(file_path)


# ------------------------------------------------------------
# Filter to the two localized cohorts of interest
# Keep only the columns needed for this analysis
# ------------------------------------------------------------

filtered_df = df[
    df["Cohort"].isin(["Pre_treatment_locally_advanced", "Pre_treatment_early_stage"])
][["Baseline_ctDNA_Max_VAF", "clinical_node"]].copy()


# ------------------------------------------------------------
# Remove rows with missing values in the variables of interest
# ------------------------------------------------------------

filtered_df = filtered_df.dropna(subset=["Baseline_ctDNA_Max_VAF", "clinical_node"])


# ------------------------------------------------------------
# Convert clinical node status to binary
# Positive -> 1
# Negative -> 0
# ------------------------------------------------------------

filtered_df["clinical_node"] = filtered_df["clinical_node"].map({
    "Positive": 1,
    "Negative": 0
})


# ------------------------------------------------------------
# Remove rows where mapping failed or clinical_node is still missing
# ------------------------------------------------------------

filtered_df = filtered_df.dropna(subset=["clinical_node"])


# ------------------------------------------------------------
# Define:
# y_true   = actual clinical node status
# y_scores = continuous baseline ctDNA Max VAF values
# ------------------------------------------------------------

y_true = filtered_df["clinical_node"].astype(int)
y_scores = filtered_df["Baseline_ctDNA_Max_VAF"]


# ------------------------------------------------------------
# Print sample size used in ROC analysis
# ------------------------------------------------------------

n_patients = len(filtered_df)
print(f"Number of patients included in ROC analysis: {n_patients}")


# ------------------------------------------------------------
# Calculate ROC curve components
# fpr = false positive rate
# tpr = true positive rate
# thresholds = score cutoffs used to generate ROC points
# ------------------------------------------------------------

fpr, tpr, thresholds = roc_curve(y_true, y_scores)


# ------------------------------------------------------------
# Calculate Area Under the Curve (AUC)
# ------------------------------------------------------------

roc_auc = auc(fpr, tpr)
print(f"AUC: {roc_auc:.4f}")


# ------------------------------------------------------------
# Calculate Youden's J statistic
# J = Sensitivity + Specificity - 1 = TPR - FPR
# The threshold with the highest J is chosen as the optimal cutoff
# ------------------------------------------------------------

youden_index = tpr - fpr
optimal_idx = np.argmax(youden_index)
optimal_threshold = thresholds[optimal_idx]
optimal_sensitivity = tpr[optimal_idx]
optimal_specificity = 1 - fpr[optimal_idx]

print(f"Optimal Threshold for Baseline ctDNA Max VAF: {optimal_threshold:.4f}")
print(f"Sensitivity at Optimal Threshold: {optimal_sensitivity:.4f}")
print(f"Specificity at Optimal Threshold: {optimal_specificity:.4f}")


# ------------------------------------------------------------
# Apply the optimal threshold to classify patients
# Patients with mVAF > threshold are classified as node-positive
# ------------------------------------------------------------

y_pred_optimal = (y_scores > optimal_threshold).astype(int)


# ------------------------------------------------------------
# Compute confusion matrix and classification metrics
# ------------------------------------------------------------

cm_optimal = confusion_matrix(y_true, y_pred_optimal)
tn, fp, fn, tp = cm_optimal.ravel()

accuracy_optimal = accuracy_score(y_true, y_pred_optimal)
sensitivity_optimal = recall_score(y_true, y_pred_optimal)
specificity_optimal = tn / (tn + fp)
precision_optimal = precision_score(y_true, y_pred_optimal)

print("\nConfusion Matrix (Optimal Threshold):")
print(cm_optimal)
print(f"Accuracy: {accuracy_optimal:.4f}")
print(f"Sensitivity (Recall): {sensitivity_optimal:.4f}")
print(f"Specificity: {specificity_optimal:.4f}")
print(f"Precision: {precision_optimal:.4f}")


# ------------------------------------------------------------
# Create ROC plot
# Blue curve = ROC
# Red point  = optimal threshold based on Youden's J
# Grey dashed line = random guess reference
# ------------------------------------------------------------

fig, ax = plt.subplots(figsize=(8, 6))

ax.plot(
    fpr,
    tpr,
    color="blue",
    linewidth=2,
    label=f"ROC Curve (AUC = {roc_auc:.2f})"
)

ax.scatter(
    fpr[optimal_idx],
    tpr[optimal_idx],
    color="red",
    label="Optimal Threshold",
    zorder=5
)

ax.plot(
    [0, 1],
    [0, 1],
    color="gray",
    linestyle="--",
    label="Random Guess"
)

ax.set_xlabel("False Positive Rate (1 - Specificity)")
ax.set_ylabel("True Positive Rate (Sensitivity)")
ax.set_title("ROC Curve: Baseline Max VAF vs Clinical Node Status")
ax.legend(loc="lower right")
ax.grid(False)


# ------------------------------------------------------------
# Show the ROC plot
# ------------------------------------------------------------

plt.show()


# ------------------------------------------------------------
# Save the ROC plot as PDF
# ------------------------------------------------------------

save_path = "roc-clinical-lymph/GitHub_ROC_clinical_lymph.pdf"
fig.savefig(save_path, format="pdf", bbox_inches="tight")
plt.close(fig)

print(f"\nROC curve saved successfully at:\n{save_path}")
