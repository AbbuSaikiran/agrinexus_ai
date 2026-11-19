from fastapi import APIRouter
from pydantic import BaseModel

router = APIRouter()

class ChatIn(BaseModel):
    message: str
    language: str = "en"

class ChatOut(BaseModel):
    reply: str
    language: str

@router.post("/chat", response_model=ChatOut)
def assistant_chat(req: ChatIn):
    q = req.message.lower()
    if "tomato" in q or "tamatar" in q:
        reply = "Tomatoes need fertile, well-draining loam with pH 6.2–6.8 and steady irrigation. Watch for late blight after unseasonal rains."
    elif "price" in q or "rate" in q or "bhav" in q:
        reply = "Current average APMC rates: Tomatoes ₹28/kg, Onions ₹22/kg, Paddy ₹66/kg. You can check the 7-day predictive trend under Price Forecast."
    elif "fertilizer" in q or "khaad" in q:
        reply = "Apply balanced NPK 120:60:60 kg/ha. Integrate farmyard manure and bio-fertilizers like Azotobacter and PSB for soil longevity."
    else:
        reply = "Namaste! AgriNexus AI assistant is at your service. Ask me about disease symptoms, seasonal planting calendars, fertilizer dosages, or current wholesale mandi prices."

    return ChatOut(reply=reply, language=req.language)
