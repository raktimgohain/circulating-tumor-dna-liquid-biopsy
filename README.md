# Circulating Tumor DNA (ctDNA) Survival Analysis Through Liquid Biopsy

![R](https://img.shields.io/badge/language-R-blue)
![Python](https://img.shields.io/badge/language-Python-yellow)
![Survival Analysis](https://img.shields.io/badge/statistics-survival--analysis-green)
![License](https://img.shields.io/badge/license-MIT-lightgrey)

This repository contains analysis pipelines for studying **circulating tumor DNA (ctDNA)** using liquid biopsy data.

The project focuses on **survival analysis and biomarker evaluation in oncology datasets**, using statistical and computational methods commonly applied in translational cancer research.

The goal of this repository is to provide **clear, reproducible workflows for ctDNA biomarker analysis** and demonstrate how ctDNA measurements can be evaluated in relation to clinical outcomes.

The analyses implemented here were developed as part of research associated with work accepted for publication in **JCO Precision Oncology (JCO-PO)**.

---

# Scientific Background

Circulating tumor DNA (ctDNA) detected through liquid biopsy is increasingly used as a biomarker for:

- cancer prognosis  
- treatment response monitoring  
- minimal residual disease detection  
- disease recurrence prediction  

In clinical oncology studies, ctDNA status is frequently evaluated in relation to survival outcomes such as:

- **Overall Survival (OS)**  
- **Recurrence-Free Survival (RFS)**  
- **Progression-Free Survival (PFS)**  

Statistical modeling techniques allow researchers to determine whether ctDNA measurements correlate with patient outcomes or clinical disease characteristics.

This repository provides reproducible code implementing these analyses.

---

# Key Features

- Reproducible **Kaplan–Meier survival analysis workflows**
- **Cox proportional hazards modeling**
- **ROC analysis for biomarker discrimination**
- **Statistical comparison of ctDNA measurements between clinical groups**
- Publication-style plots for translational oncology research
- Modular repository structure allowing independent analysis modules

---

# Analyses Included

This repository contains the following analysis modules.

### Survival Analysis
- Kaplan–Meier overall survival modeling  
- ctDNA-stratified survival comparison  
- log-rank statistical testing  
- risk table visualization  

### ctDNA Biomarker Analyses
- Baseline ctDNA variant allele frequency vs clinical lymph node status  
- ctDNA dynamics after neoadjuvant therapy  
- pathologic response comparison  
- multivariable Cox proportional hazards modeling  

### Diagnostic Performance
- ROC analysis evaluating ctDNA variant allele frequency as a predictor of lymph node status  

Each analysis module is contained within its own folder and includes:

- the analysis script  
- the generated figure  
- detailed documentation describing the workflow  

---

# Repository Structure

```
circulating-tumor-dna-liquid-biopsy
│
├── survival-analysis
│   ├── README.md
│   ├── survival_on_treatment_ctDNA.R
│   └── GitHub_OS_ctDNA_conversion.png
│
├── baseline-lymph-node-mvaf
│   ├── README.md
│   ├── baseline_mvaf_vs_lymphnode.R
│   └── GitHub_Baseline_Clinical_Nodal_Detection_by_mVAF.png
│
├── delta-post-treatment
│   ├── README.md
│   ├── delta_post_nt_response.R
│   └── GitHub_Delta_post_treatment_by_pathologic_response.png
│
├── cox-multivariable-localized
│   ├── README.md
│   ├── cox_multivariable_localized.R
│   └── GitHub_Cox_Multivariable.png
│
├── roc-clinical-lymph
│   ├── README.md
│   ├── roc_baseline_mvaf_clinical_node.py
│   └── GitHub_ROC_clinical_lymph.png
│
├── LICENSE
└── README.md
```

Each analysis folder contains:

- the code used to generate the analysis  
- the figure produced by the analysis  
- documentation explaining the statistical methods used  

This modular design allows each analysis to be understood and reproduced independently.

---

# Workflow Overview

The general workflow implemented across the repository follows the structure below:

Clinical dataset  
↓  
Data preprocessing  
↓  
Biomarker variable definition  
↓  
Statistical modeling  
↓  
Visualization of results  

Depending on the analysis module, the statistical modeling step may include:

- Kaplan–Meier survival estimation  
- Cox proportional hazards regression  
- Wilcoxon rank-sum testing  
- ROC analysis  

---

# Statistical Methods Used

The analyses in this repository use statistical methods commonly applied in translational oncology studies.

### Survival Analysis
- Kaplan–Meier survival estimation  
- Log-rank test for survival curve comparison  
- Median survival estimation  
- Confidence interval estimation  
- Risk table visualization  

### Multivariable Modeling
- Cox proportional hazards regression  

### Group Comparisons
- Wilcoxon rank-sum test for non-normally distributed biomarker values  

### Diagnostic Performance Evaluation
- Receiver Operating Characteristic (ROC) curve analysis  
- Area Under the Curve (AUC)  
- Youden’s J statistic for threshold selection  

---

# Requirements

Two programming environments are used in this repository.

### R (for survival and biomarker analyses)

Recommended version:  
R ≥ 4.0

Required packages:

- survival  
- survminer  
- readxl  
- tidyverse  
- dplyr  
- ggplot2  

Install required packages in R:

```r
install.packages(c("survival","survminer","readxl","tidyverse","dplyr","ggplot2"))
```

### Python (for ROC analysis)

Required libraries:

- pandas  
- numpy  
- matplotlib  
- scikit-learn  

Install using pip:

```
pip install pandas numpy matplotlib scikit-learn
```

---

# Data Availability

The clinical datasets used in these analyses are **not included in this repository**.

The data originate from institutional clinical cohorts and cannot be publicly shared due to:

- patient privacy regulations  
- institutional data governance policies  

However, the code in this repository can be applied to any dataset containing standard clinical variables such as:

- follow-up time  
- event indicator  
- biomarker measurements  
- clinical covariates  

---

# Reproducibility

To reproduce any analysis in this repository:

1. Prepare a dataset containing the required clinical variables.  
2. Update the file path in the analysis scripts to point to your dataset.  
3. Run the script in the corresponding module directory.  

Each module README contains **step-by-step explanations of the statistical workflow**.

---

# Related Publication

This repository accompanies research workflows associated with work accepted for publication in:

**Journal of Clinical Oncology – Precision Oncology (JCO-PO)**

Full citation details will be updated once the manuscript is formally published.

---

# License

This repository is released under the **MIT License**.
