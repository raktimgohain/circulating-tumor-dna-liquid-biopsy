# Kaplan–Meier Overall Survival Analysis

This repository contains a reproducible workflow for Kaplan–Meier overall survival analysis using oncology datasets.

The goal of this project is to demonstrate standard survival analysis pipelines used in translational cancer research and provide an accessible introduction to Kaplan–Meier survival estimation for beginners in biomedical data science.

---

# Introduction to Survival Analysis

Survival analysis is a statistical framework used to analyze **time-to-event data**. In clinical oncology research, the “event” usually refers to:

- death (overall survival)
- disease recurrence
- disease progression

In this repository, the event of interest is **death**, so the analysis focuses on **overall survival**.

Unlike traditional statistical methods, survival analysis properly handles **censored observations**, which occur when:

- a patient is still alive at last follow-up
- a patient is lost to follow-up
- the event has not yet occurred by the end of the study

Because of censoring, specialized statistical techniques are required to estimate survival probabilities.

---

# What is the Kaplan–Meier Method?

The **Kaplan–Meier estimator** is a non-parametric method used to estimate the probability of survival over time.

It calculates survival probability at each time point where an event occurs and updates the survival estimate step-by-step. It produces a **stepwise survival curve** that decreases whenever an event occurs.

---

# What Does a Kaplan–Meier Curve Show?

A Kaplan–Meier curve visualizes the **probability that a patient survives beyond a certain time**.

Typical plot components include:

- **x-axis:** time (months or years)
- **y-axis:** survival probability
- **step decreases:** represent events such as death
- **tick marks:** indicate censored observations

Kaplan–Meier curves are widely used to compare survival outcomes between different patient groups.

---

# What is Median Survival?

The **median survival time** is the time at which the survival probability equals 0.5.

In other words, it represents the time when **50% of the study population has experienced the event**.

Median survival is commonly reported because:

- survival data are typically skewed
- the median is more robust than the mean
- it provides an intuitive summary of survival outcomes

---

# Why Use the Log-Rank Test?

When comparing survival between two or more groups, the **log-rank test** is the most commonly used statistical test.

The log-rank test evaluates whether survival curves differ significantly across the entire follow-up period.

It works by comparing:

- the **observed number of events**
- the **expected number of events**

at each time point for each group.

If the difference between observed and expected events is large, the survival curves are considered statistically different.

---

# Why Not Use Other Statistical Tests?

Standard statistical tests such as:

- t-tests
- chi-square tests
- linear regression

are not appropriate for survival data because they **do not account for censoring or time-to-event information**.

The log-rank test is specifically designed for survival analysis because it:

- incorporates censored observations
- evaluates differences across the entire survival curve
- does not assume a specific survival distribution

---

# Limitations of Kaplan–Meier Analysis

Although Kaplan–Meier survival estimation is widely used, it has several limitations:

- it does not adjust for multiple covariates
- it cannot model the effect of predictors simultaneously
- it assumes proportional hazards when using the log-rank test

To adjust for multiple predictors, researchers typically use **Cox proportional hazards regression**.

---

# Example Output

Below is an example Kaplan–Meier overall survival plot generated from the analysis workflow in this repository.

![Kaplan–Meier Overall Survival Curve](GitHub_Overall_Survival.png)

---

# Analysis Workflow

The workflow used in this repository follows these steps:

1. import the survival dataset
2. define follow-up time and event status
3. create the survival object
4. fit the Kaplan–Meier model
5. compare groups using the log-rank test
6. generate the survival plot and risk table
7. export the figure for reporting and presentation

---

# Tools

Analysis is performed in **R** using the following packages:

- `readxl`
- `survival`
- `survminer`

---

# Repository Structure

```text
kaplan-meier-overall-survival/
├── README.md
├── LICENSE
├── .gitignore
├── GitHub_Overall_Survival.png
└── scripts/
    └── km_overall_survival.R
