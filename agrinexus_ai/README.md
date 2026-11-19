# AgriNexus AI: Smart Farm Marketplace

A major project submitted in partial fulfilment of the requirements for the award of Bachelor of Technology in Computer Science and Engineering (IoT), Balaji Institute of Technology & Science (Autonomous), Narsampet, Warangal (2023–2027).

**Team Members:**
- G. Sreeja (23C31A6913)
- A. Manaswini (23C31A6901)
- V. Naveen (23C31A6929)
- K. Vikranth (23C31A6916)

**Project Guide:**
Mr. S. Sravan Vardhan Rao, Assistant Professor, Department of CSE (Data Science)

---

## 📁 Unified Project Directory Structure

```text
agrinexus_ai/
├── lib/                             # Flutter Mobile Frontend
│   ├── core/                        # Themes, Constants, Localization
│   ├── data/                        # Models, Mock & REST Services
│   ├── features/
│   │   ├── auth/                    # Splash, Login, Registration
│   │   ├── home/                    # Role-based Dashboard & Market Highlights
│   │   ├── marketplace/             # Crop Discovery, Listings & Purchasing
│   │   ├── scan/                    # YOLOv8 Disease Detection & Quality Grading
│   │   ├── predict/                 # ML Price Forecasting & Crop Recommendations
│   │   ├── orders/                  # Order Lifecycle Tracking & Trust Ratings
│   │   ├── assistant/               # Multilingual Voice/Text AI Assistant
│   │   └── profile/                 # User Profile & Language Switcher
│   └── providers/                   # State Management (Provider)
│
├── backend/                         # Spring Boot REST API Service
│   ├── pom.xml                      # Maven Build & Dependencies
│   └── src/main/
│       ├── resources/application.yml
│       └── java/com/agrinexus/backend/
│           ├── config/              # Security & CORS Configuration
│           ├── controller/          # REST Endpoints (/api/auth, /api/products, /api/orders, /api/ai, /api/deliveries)
│           ├── model/
│           │   ├── entity/          # JPA Entities (User, Product, Order, Rating, DiseaseReport, Delivery)
│           │   ├── dto/             # Request & Response Transfer Objects
│           │   └── enums/           # Role & OrderStatus
│           ├── repository/          # Spring Data JPA Repositories
│           ├── security/            # JWT Token Authentication & Filters
│           └── service/             # Core Business Logic & AI Orchestration
│
└── python_ai/                       # Python Computer Vision & ML Service
    ├── requirements.txt             # FastAPI, OpenCV, Ultralytics YOLOv8, Scikit-learn
    ├── main.py                      # FastAPI App Entrypoint
    └── app/routers/
        ├── vision.py                # YOLOv8 Disease Scanner & OpenCV Quality Assessor
        ├── prediction.py            # Random Forest Price Forecasting & Crop Recommendation
        └── assistant.py             # Multilingual Agricultural Guidance Engine
```

---

## 🚀 How to Run

### 1. Flutter Mobile App
```bash
cd agrinexus_ai
flutter pub get
flutter run
```

### 2. Spring Boot Backend
Ensure MySQL is running on port 3306 (database `agrinexus_db`).
```bash
cd agrinexus_ai/backend
mvn spring-boot:run
```
Swagger UI will be available at: `http://localhost:8080/swagger-ui.html`

### 3. Python AI Microservice
```bash
cd agrinexus_ai/python_ai
pip install -r requirements.txt
uvicorn main:app --reload --port 8000
```
Interactive API docs at: `http://localhost:8000/docs`
