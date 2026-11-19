from fastapi import APIRouter, UploadFile, File
from pydantic import BaseModel
import random

router = APIRouter()

class DiseaseResult(BaseModel):
    disease: str
    confidence: float
    severity: str
    advice: str
    boxes: list = []

class QualityResult(BaseModel):
    qualityGrade: str
    score: float
    notes: str

DISEASES = [
    {
        "disease": "Tomato Early Blight",
        "confidence": 94.6,
        "severity": "Medium",
        "advice": "Apply Mancozeb or Chlorothalonil fungicide spray every 7-10 days. Remove lower diseased leaves to stop soil splash."
    },
    {
        "disease": "Tomato Late Blight",
        "confidence": 92.1,
        "severity": "High",
        "advice": "Immediately spray copper oxychloride or metalaxyl. Isolate and safely discard heavily infected plant tissue."
    },
    {
        "disease": "Powdery Mildew",
        "confidence": 88.5,
        "severity": "Medium",
        "advice": "Dust with sulfur or spray wettable sulfur/neem oil emulsion. Prune for optimal airflow and sunlight exposure."
    },
    {
        "disease": "Healthy Foliage",
        "confidence": 98.2,
        "severity": "None",
        "advice": "Plant is vigorous and symptom-free. Maintain balanced NPK irrigation and routine prophylactic pest scouting."
    }
]

@router.post("/disease", response_model=DiseaseResult)
async def detect_disease(file: UploadFile = File(...)):
    # Simulates YOLOv8 bounding box and disease inference pipeline
    contents = await file.read()
    item = random.choice(DISEASES)
    return DiseaseResult(
        disease=item["disease"],
        confidence=item["confidence"],
        severity=item["severity"],
        advice=item["advice"],
        boxes=[{"x": 120, "y": 85, "w": 240, "h": 180, "cls": item["disease"]}]
    )

@router.post("/quality", response_model=QualityResult)
async def assess_quality(file: UploadFile = File(...)):
    # Simulates OpenCV morphology + surface defect analysis
    grades = [
        ("A+", 95.0, "Superior color uniformity, unblemished skin and optimal market diameter. Certified Grade A+."),
        ("A", 84.5, "High commercial quality with minimal superficial marks. Approved for prime supermarket distribution."),
        ("B", 72.0, "Standard bulk trade quality suitable for local processing and culinary distribution.")
    ]
    g = random.choice(grades)
    return QualityResult(qualityGrade=g[0], score=g[1], notes=g[2])
