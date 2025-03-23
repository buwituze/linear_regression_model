## Disease Prevalence Rate Prediction System

This project implements a machine learning system to predict disease prevalence rates based on health indicators, socioeconomic factors, and healthcare infrastructure. It includes a trained prediction model, a FastAPI backend, and a Flutter mobile application to access the predictions.

### Project Components

1. Linear Regression Model

- Implemented using gradient descent optimization
- Compared with Decision Tree and Random Forest models
- Feature importance analysis to identify key health indicators
- Loss curves and cross-validation for performance evaluation

2. FastAPI Backend
   The API provides a prediction endpoint that accepts healthcare data and returns predicted disease prevalence rates.
   Deployed API Endpoint: https://linear-regression-model-f74t.onrender.com/docs

3. Flutter Mobile Application

Demo Video:

### Installation Steps

- Clone the repository: clone https://github.com/your-username/disease-prevalence-prediction.git
- Navigate into the frontend dir: cd summative\FlutterApp\app
- Install dependencies: flutter pub get
- Run the app: flutter run

### Usage

- Fill in all required fields with appropriate values (Follow the provided hints for accuracy and practicalty):

    - Healthcare System section (access percentages, doctors per 1000, etc.)
    - Socioeconomic Factors (income, education index, etc.)
    - Disease Factors (population affected, treatment costs, etc.)
    - Demographics & Treatment information

- Click the "PREDICT" button to send data to the API
- View the predicted disease prevalence rate at the bottom of the screen

### Model Performance Summary

- Linear Regression Test MSE: 35.42
- Decision Tree Test MSE: 37.26
- Random Forest Test MSE: 33.07 (Best performing model)
