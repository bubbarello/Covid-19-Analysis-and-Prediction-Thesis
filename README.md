# Covid-19-Analysis-and-Prediction-Thesis
This is the source code of my thesis that explores the prediction capabilities of three compartmental models (SIR, SEIRS, SVEIRS) in the italian context of the pandemic of Sars-Cov-2
***
# Objective of this project
Using the dataset "daticovid.csv" obtained from the [Protezione Civile](https://github.com/pcm-dpc/COVID-19) analyze and compare each models prediction capabilities, using 120 days as observation period, in three different phases of the pandemic.
The SIR model for the earliest stage of the pandemic, the SEIRS model for the period in which the delta variant was the most active and the SVEIRS models for when the vaccination rate was picking up steam.

# How to use this project

The code is divided into 5 files, 3 of which are the models main code, one (errore.m) is used to calculate the error between the real curve of infected and the expected, and the main file is where all the analysis and prediction is made.

Running main.m will produce 18 pictures, 1 through 3 are graph that rappresent each model compartment using arbitrary parameters, 3 through 6 are each model infected curve (real vs expected outcome), 6 through 9 are each model infection curve expected outcome using fminsearch to return parameters that minimize the error between the real and the predicted curve and the last 9 show each model prediction capabilities using 30/60/90 days intervals 

