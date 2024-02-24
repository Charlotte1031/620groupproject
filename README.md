# Screen Time and Course Time Relationship Study

## Overview

This repository contains code and data for a study investigating the relationship between daily screen time on social apps and daily course time of students. The study utilizes the Federated Statistical Learning method to address data privacy concerns while analyzing the correlation between these variables. Additionally, the performance of Federated Statistical Learning is compared with Oracle Learning.

## File Navigation

- **data/:** Contains the raw and processed data used in the study.
  - `raw_data.xlsx`: Raw data collected during the study.
  - `folder_01`: 

- **src/:** Source code for data preprocessing and model training.
  - `EDA.Rmd`: Code for integrating objective data with self-reported screen time activity data.
  - `.R`: 
  - `oracle_learning.R`: 
  
- **results/:** Output files and visualizations generated during the study.
  - `.`: Comparison of Federated Statistical Learning and Oracle Learning models.

- **README.md:** Documentation providing an overview of the project, study details, and instructions for replication.

## Study Details

### Abstract
This project explores the relationship between daily screen time on social apps and daily course time of students. The Federated Statistical Learning model is employed, addressing data privacy concerns by using individual summary statistics instead of raw data. The model reveals a correlation between daily screen time on social apps and the first phone pickup time.

### Key Phases
- Social screen time
- Social media addiction
- Course hours
- Central server data structure
- Federated learning

### Variables
- **Dependent Variable:** Daily Social Screen Time
- **Independent Variables:** Daily Course Minutes, Temperature, Snowing Condition, Screen Use Duration per Pickup, Daily First Pickup Time

### Data Preprocessing
Objective data, including weather conditions, is integrated with self-reported screen time activity data. Participants update daily information using an online collaborative sheet, standardizing the entry of weather-related details.

## Model Fitting

The Federated Statistical Learning method is applied to a linear regression model, with daily screen time on social applications as the response variable and daily course time, temperature, snow condition, and use time per pickup as explanatory variables. Assumptions of LINE (Linear relationship, no autocorrelation, normal distribution of residuals, constant variance of residuals) are considered.

