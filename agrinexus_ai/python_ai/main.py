from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.routers import vision, prediction, assistant

app = FastAPI(
    title="AgriNexus AI Microservice",
    description="Python AI service powering YOLOv8 Plant Disease Detection, Crop Quality Grading, Price Prediction & Agricultural Chatbot",
    version="1.0.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(vision.router, prefix="/api/vision", tags=["Vision AI"])
app.include_router(prediction.router, prefix="/api/prediction", tags=["Predictive Analytics"])
app.include_router(assistant.router, prefix="/api/assistant", tags=["Multilingual Assistant"])

@app.get("/")
def health_check():
    return {
        "status": "healthy",
        "service": "AgriNexus AI Python Engine",
        "modules": ["YOLOv8 Disease Detection", "OpenCV Quality Grading", "RandomForest Price Forecasting", "Multilingual LLM Assistant"]
    }
