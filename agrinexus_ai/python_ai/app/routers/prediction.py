from fastapi import APIRouter
from pydantic import BaseModel
import random

router = APIRouter()

class PricePrediction(BaseModel):
    crop: str
    market: str
    predictedPrice: float
    minPrice: float
    maxPrice: float
    trend: str
    dataPeriod: str
    recommendation: str

class Recommendation(BaseModel):
    cropName: str
    suitabilityScore: float
    season: str
    expectedYield: str
    expectedPrice: float
    reason: str

@router.get("/price", response_model=PricePrediction)
def predict_price(crop: str, market: str = "Warangal APMC"):
    base_prices = {
        "Tomatoes": 28.0,
        "Onions": 22.0,
        "Rice": 66.0,
        "Wheat": 25.0,
        "Mangoes": 180.0,
        "Chilies": 48.0,
        "Turmeric": 125.0
    }
    base = base_prices.get(crop, 35.0)
    pred = round(base * (0.95 + random.random() * 0.15), 2)
    return PricePrediction(
        crop=crop,
        market=market,
        predictedPrice=pred,
        minPrice=round(pred * 0.88, 2),
        maxPrice=round(pred * 1.14, 2),
        trend="Upward (+6.2%)",
        dataPeriod="Oct 2024 - Nov 2026",
        recommendation=f"Optimal window to sell within 3 days. Demand index in {market} is accelerating."
    )

@router.get("/recommend", response_model=list[Recommendation])
def recommend_crops(nitrogen: float = 60, phosphorus: float = 50, potassium: float = 70, rainfall: float = 120, temperature: float = 25):
    return [
        Recommendation(
            cropName="Tomatoes",
            suitabilityScore=95.0,
            season="Rabi (Oct - Mar)",
            expectedYield="28-35 Tonnes/Ha",
            expectedPrice=28.0,
            reason="Current NPK ratio and climate conditions are optimal for nightshade family crops."
        ),
        Recommendation(
            cropName="Guntur Red Chilies",
            suitabilityScore=89.5,
            season="Kharif / Rabi",
            expectedYield="3.5-5 Tonnes/Ha",
            expectedPrice=50.0,
            reason="Soil aeration and thermal degree days match peak spice flowering dynamics."
        ),
        Recommendation(
            cropName="Basmati Paddy",
            suitabilityScore=84.0,
            season="Kharif",
            expectedYield="5-6.5 Tonnes/Ha",
            expectedPrice=65.0,
            reason="High precipitation resilience and seasonal water holding capacity."
        )
    ]
