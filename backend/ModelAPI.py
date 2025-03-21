from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field, validator
import joblib
import numpy as np
import uvicorn
import os

PARENT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MODEL_PATH = os.path.join(PARENT_DIR, "best_model.pkl")
SCALER_PATH = os.path.join(PARENT_DIR, "scaler.pkl")

# initialzing a FastAPI app
app = FastAPI(
    title="Disease Prevalence Prediction API",
    description="API for predicting disease prevalence rates based on health indicators",
    version="1.0.0"
)

# Add CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Defining input data model with Pydantic
class PredictionInput(BaseModel):
    healthcare_access: float = Field(..., ge=0, le=100, description="Healthcare Access (%)")
    doctors_per_1000: float = Field(..., ge=0, le=20, description="Doctors per 1000 people")
    hospital_beds_per_1000: float = Field(..., ge=0, le=20, description="Hospital Beds per 1000 people")
    per_capita_income: float = Field(..., ge=0, le=100000, description="Per Capita Income (USD)")
    education_index: float = Field(..., ge=0, le=1, description="Education Index (0-1)")
    urbanization_rate: float = Field(..., ge=0, le=100, description="Urbanization Rate (%)")
    population_affected: int = Field(..., ge=0, description="Population Affected")
    dalys: float = Field(..., ge=0, description="Disability-Adjusted Life Years")
    improvement_5_years: float = Field(..., ge=-100, le=100, description="Improvement in 5 Years (%)")
    avg_treatment_cost: float = Field(..., ge=0, description="Average Treatment Cost (USD)")
    gender: int = Field(..., ge=0, le=1, description="Gender (encoded: 0=Female, 1=Male)")
    treatment_type: int = Field(..., ge=0, le=2, description="Treatment Type (encoded: values depend on your encoding)")
    
    @validator('education_index')
    def validate_education_index(cls, v):
        if v < 0 or v > 1:
            raise ValueError('Education Index must be between 0 and 1')
        return v

# Define response model
class PredictionOutput(BaseModel):
    prevalence_rate: float = Field(..., description="Predicted Disease Prevalence Rate (%)")

# Load the model and scaler
try:
    print(f"Loading model from: {MODEL_PATH}")
    print(f"Loading scaler from: {SCALER_PATH}")
    
    model = joblib.load(MODEL_PATH)
    scaler = joblib.load(SCALER_PATH)
    
    print("Model and scaler loaded successfully")
except FileNotFoundError as e:
    model = None
    scaler = None
    print(f"Error: {e}")
    print("Warning: Model or scaler file not found. Please check the file paths.")

@app.post("/predict", response_model=PredictionOutput)
def predict(data: PredictionInput):
    """
    Predict disease prevalence rate based on input health indicators
    """
    if model is None or scaler is None:
        raise HTTPException(status_code=500, detail="Model not loaded. Please check server logs for details.")
    
    # change input to feature array
    features = np.array([
        data.healthcare_access,
        data.doctors_per_1000,
        data.hospital_beds_per_1000,
        data.per_capita_income,
        data.education_index,
        data.urbanization_rate,
        data.population_affected,
        data.dalys,
        data.improvement_5_years,
        data.avg_treatment_cost,
        data.gender,
        data.treatment_type
    ]).reshape(1, -1)
    
    scaled_features = scaler.transform(features)
    
    # Make prediction
    prediction = model.predict(scaled_features)[0]
    
    # Return prediction
    return PredictionOutput(prevalence_rate=prediction)

@app.get("/")
def read_root():
    """
    Root endpoint that provides basic API information
    """
    return {
        "message": "Disease Prevalence Prediction API",
        "usage": "Make a POST request to /predict endpoint with the required parameters",
        "documentation": "/docs or /redoc for detailed API documentation"
    }

if __name__ == "__main__":
    uvicorn.run("ModelAPI:app", host="0.0.0.0", port=8000, reload=True)