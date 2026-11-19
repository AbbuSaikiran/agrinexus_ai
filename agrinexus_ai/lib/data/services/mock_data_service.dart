// Mock Data Service — simulates backend & AI responses
import 'dart:math';
import '../models/models.dart';

class MockDataService {
  static final Random _rng = Random();

  // ── Marketplace products ──────────────────────────────────────────────────
  static List<ProductModel> get sampleProducts => [
        ProductModel(
          id: '1',
          farmerId: 'f1',
          farmerName: 'Ravi Kumar',
          name: 'Fresh Tomatoes',
          category: 'Vegetables',
          quantity: 500,
          unitPrice: 25,
          qualityGrade: 'A+',
          imageUrl: null,
          location: 'Narsampet, Warangal',
          status: 'Available',
          rating: 4.8,
          ratingCount: 42,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          description:
              'Freshly harvested tomatoes. Grown organically without pesticides.',
        ),
        ProductModel(
          id: '2',
          farmerId: 'f2',
          farmerName: 'Lakshmi Devi',
          name: 'Basmati Rice',
          category: 'Grains',
          quantity: 1000,
          unitPrice: 65,
          qualityGrade: 'A',
          imageUrl: null,
          location: 'Karimnagar, Telangana',
          status: 'Available',
          rating: 4.6,
          ratingCount: 87,
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          description: 'Premium basmati rice. Long grain variety.',
        ),
        ProductModel(
          id: '3',
          farmerId: 'f3',
          farmerName: 'Suresh Reddy',
          name: 'Alphonso Mangoes',
          category: 'Fruits',
          quantity: 200,
          unitPrice: 180,
          qualityGrade: 'A+',
          imageUrl: null,
          location: 'Rajahmundry, AP',
          status: 'Available',
          rating: 4.9,
          ratingCount: 125,
          createdAt: DateTime.now().subtract(const Duration(hours: 5)),
          description: 'Premium Alphonso mangoes. Sweet and juicy.',
        ),
        ProductModel(
          id: '4',
          farmerId: 'f4',
          farmerName: 'Anjamma',
          name: 'Green Chilies',
          category: 'Vegetables',
          quantity: 150,
          unitPrice: 40,
          qualityGrade: 'B',
          imageUrl: null,
          location: 'Guntur, AP',
          status: 'Available',
          rating: 4.3,
          ratingCount: 31,
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
          description: 'Spicy green chilies from Guntur region.',
        ),
        ProductModel(
          id: '5',
          farmerId: 'f5',
          farmerName: 'Venkata Rao',
          name: 'Toor Dal',
          category: 'Pulses',
          quantity: 800,
          unitPrice: 95,
          qualityGrade: 'A',
          imageUrl: null,
          location: 'Nizamabad, Telangana',
          status: 'Available',
          rating: 4.7,
          ratingCount: 58,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          description: 'High-protein toor dal. Machine-cleaned and sorted.',
        ),
        ProductModel(
          id: '6',
          farmerId: 'f6',
          farmerName: 'Padma Kumari',
          name: 'Onions',
          category: 'Vegetables',
          quantity: 2000,
          unitPrice: 18,
          qualityGrade: 'A',
          imageUrl: null,
          location: 'Kurnool, AP',
          status: 'Available',
          rating: 4.5,
          ratingCount: 203,
          createdAt: DateTime.now().subtract(const Duration(hours: 12)),
          description: 'Medium-sized onions. Dry and well-stored.',
        ),
        ProductModel(
          id: '7',
          farmerId: 'f7',
          farmerName: 'Krishnamurthy',
          name: 'Turmeric',
          category: 'Spices',
          quantity: 300,
          unitPrice: 120,
          qualityGrade: 'A+',
          imageUrl: null,
          location: 'Nizamabad, Telangana',
          status: 'Available',
          rating: 4.9,
          ratingCount: 76,
          createdAt: DateTime.now().subtract(const Duration(days: 4)),
          description: 'Premium quality turmeric with high curcumin content.',
        ),
        ProductModel(
          id: '8',
          farmerId: 'f8',
          farmerName: 'Bhavani',
          name: 'Bananas',
          category: 'Fruits',
          quantity: 400,
          unitPrice: 30,
          qualityGrade: 'A',
          imageUrl: null,
          location: 'Nellore, AP',
          status: 'Available',
          rating: 4.4,
          ratingCount: 44,
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          description: 'Ripe Robusta bananas. Ready to eat.',
        ),
      ];

  // ── Disease Detection (mock AI) ───────────────────────────────────────────
  static Future<DiseaseReport> detectDisease() async {
    await Future.delayed(const Duration(seconds: 2));
    final diseases = [
      {
        'disease': 'Tomato Late Blight',
        'confidence': 92.4,
        'severity': 'High',
        'advice':
            'Apply copper-based fungicide immediately. Remove affected leaves. Ensure good air circulation. Avoid overhead watering.',
      },
      {
        'disease': 'Powdery Mildew',
        'confidence': 87.6,
        'severity': 'Medium',
        'advice':
            'Apply sulfur-based fungicide or neem oil spray. Improve plant spacing for better airflow.',
      },
      {
        'disease': 'Leaf Curl Virus',
        'confidence': 78.9,
        'severity': 'High',
        'advice':
            'No cure available. Remove infected plants. Control whitefly vectors with insecticide. Use resistant varieties.',
      },
      {
        'disease': 'Healthy Plant',
        'confidence': 95.1,
        'severity': 'None',
        'advice':
            'Your plant looks healthy! Continue current care practices and monitor regularly.',
      },
      {
        'disease': 'Nutrient Deficiency (Nitrogen)',
        'confidence': 83.2,
        'severity': 'Low',
        'advice':
            'Apply nitrogen-rich fertilizer (urea or DAP). Yellowing of leaves indicates N deficiency. Test soil pH.',
      },
    ];
    final d = diseases[_rng.nextInt(diseases.length)];
    return DiseaseReport(
      id: 'DR${DateTime.now().millisecondsSinceEpoch}',
      disease: d['disease'] as String,
      confidence: double.parse(d['confidence'].toString()),
      advice: d['advice'] as String,
      severity: d['severity'] as String,
      createdAt: DateTime.now(),
    );
  }

  // ── Quality Assessment (mock AI) ─────────────────────────────────────────
  static Future<Map<String, dynamic>> assessQuality() async {
    await Future.delayed(const Duration(seconds: 2));
    final grades = [
      {'grade': 'A+', 'score': 95, 'notes': 'Excellent quality. Market-ready. High demand expected.'},
      {'grade': 'A', 'score': 82, 'notes': 'Good quality. Minor surface blemishes. Suitable for retail.'},
      {'grade': 'B', 'score': 68, 'notes': 'Average quality. Suitable for processing or bulk trade.'},
      {'grade': 'C', 'score': 51, 'notes': 'Below average. Recommend processing use only.'},
    ];
    final weights = [0.4, 0.35, 0.2, 0.05];
    double rand = _rng.nextDouble();
    int idx = 0;
    double cumulative = 0;
    for (int i = 0; i < weights.length; i++) {
      cumulative += weights[i];
      if (rand <= cumulative) { idx = i; break; }
    }
    return grades[idx];
  }

  // ── Price Prediction (mock ML model) ────────────────────────────────────
  static Future<PricePrediction> predictPrice(String crop, String market) async {
    await Future.delayed(const Duration(milliseconds: 1500));
    final basePrices = {
      'Tomatoes': 28.0, 'Onions': 20.0, 'Rice': 68.0,
      'Wheat': 24.0, 'Mangoes': 190.0, 'Bananas': 32.0,
      'Potatoes': 22.0, 'Chilies': 45.0, 'Turmeric': 125.0,
    };
    final base = basePrices[crop] ?? 40.0;
    final variation = (_rng.nextDouble() - 0.3) * base * 0.2;
    final predicted = base + variation;
    final trends = ['Rising ↑', 'Stable →', 'Falling ↓'];
    final recommendations = [
      'Good time to sell! Prices are above seasonal average.',
      'Hold for 2–3 days. Market shows stabilising trend.',
      'Sell now before prices drop further. High supply expected.',
    ];
    final trendIdx = _rng.nextInt(3);
    return PricePrediction(
      crop: crop,
      market: market,
      predictedPrice: predicted,
      minPrice: predicted * 0.85,
      maxPrice: predicted * 1.15,
      trend: trends[trendIdx],
      dataPeriod: 'Oct 2024 – Nov 2026',
      recommendation: recommendations[trendIdx],
    );
  }

  // ── Crop Recommendation (mock ML model) ─────────────────────────────────
  static Future<List<CropRecommendation>> recommendCrops({
    required double nitrogen,
    required double phosphorus,
    required double potassium,
    required double rainfall,
    required double temperature,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return [
      CropRecommendation(
        cropName: 'Tomatoes',
        suitabilityScore: 94,
        season: 'Oct – Feb',
        expectedYield: '25–35 tonnes/ha',
        expectedPrice: 28.0,
        reason: 'Ideal soil N-P-K and temperature range. High market demand.',
        imageAsset: 'tomato',
      ),
      CropRecommendation(
        cropName: 'Chili Peppers',
        suitabilityScore: 88,
        season: 'Jul – Nov',
        expectedYield: '3–5 tonnes/ha',
        expectedPrice: 45.0,
        reason: 'Excellent P-K ratio. Region suits spice cultivation.',
        imageAsset: 'chili',
      ),
      CropRecommendation(
        cropName: 'Rice',
        suitabilityScore: 82,
        season: 'Jun – Sep',
        expectedYield: '5–7 tonnes/ha',
        expectedPrice: 68.0,
        reason: 'Adequate rainfall. Suitable temperature for paddy.',
        imageAsset: 'rice',
      ),
      CropRecommendation(
        cropName: 'Turmeric',
        suitabilityScore: 76,
        season: 'Apr – Nov',
        expectedYield: '20–25 tonnes/ha',
        expectedPrice: 125.0,
        reason: 'High value spice. Region well-known for turmeric.',
        imageAsset: 'turmeric',
      ),
    ];
  }

  // ── Sample Orders ────────────────────────────────────────────────────────
  static List<OrderModel> get sampleOrders => [
        OrderModel(
          id: 'ORD001',
          buyerId: 'b1',
          buyerName: 'Ramesh Traders',
          productId: '1',
          productName: 'Fresh Tomatoes',
          farmerName: 'Ravi Kumar',
          quantity: 100,
          totalAmount: 2500,
          status: 'Delivered',
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
        OrderModel(
          id: 'ORD002',
          buyerId: 'b2',
          buyerName: 'Sri Traders',
          productId: '2',
          productName: 'Basmati Rice',
          farmerName: 'Lakshmi Devi',
          quantity: 200,
          totalAmount: 13000,
          status: 'In Transit',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        OrderModel(
          id: 'ORD003',
          buyerId: 'b3',
          buyerName: 'Fresh Mart',
          productId: '3',
          productName: 'Alphonso Mangoes',
          farmerName: 'Suresh Reddy',
          quantity: 50,
          totalAmount: 9000,
          status: 'Confirmed',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        OrderModel(
          id: 'ORD004',
          buyerId: 'b1',
          buyerName: 'Ramesh Traders',
          productId: '5',
          productName: 'Toor Dal',
          farmerName: 'Venkata Rao',
          quantity: 150,
          totalAmount: 14250,
          status: 'Pending',
          createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        ),
      ];

  // ── AI Assistant Responses (mock) ────────────────────────────────────────
  static Future<String> getAssistantResponse(String question, String language) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final q = question.toLowerCase();
    if (q.contains('tomato') || q.contains('tamatar')) {
      return 'Tomatoes grow best at 20–27°C. They need well-drained soil with a pH of 6.0–6.8. '
          'Water regularly but avoid waterlogging. Apply a balanced NPK fertilizer every 2 weeks. '
          'Watch for late blight and aphids. Expected yield: 25–35 tonnes/hectare.';
    } else if (q.contains('disease') || q.contains('rog')) {
      return 'Common plant diseases include Late Blight, Powdery Mildew, and Leaf Curl Virus. '
          'Use AgriNexus AI\'s Crop Scanner to detect diseases early. Take a clear photo of the '
          'affected leaf and upload it for instant AI-powered diagnosis with treatment advice.';
    } else if (q.contains('price') || q.contains('bhav') || q.contains('dam')) {
      return 'Current market prices are updated daily. You can check the Price Prediction feature '
          'in AgriNexus AI to get AI-based price forecasts for your crop. '
          'Tomatoes: ₹25–35/kg | Onions: ₹18–25/kg | Rice: ₹60–75/kg.';
    } else if (q.contains('weather') || q.contains('mausam')) {
      return 'For accurate weather forecasts, check the IMD (India Meteorological Department) app. '
          'Currently, Telangana region expects moderate rainfall this week. '
          'Best time to harvest: early morning to maintain freshness.';
    } else if (q.contains('fertiliz') || q.contains('khaad')) {
      return 'Recommended fertilizers: Urea (Nitrogen), DAP (Phosphorus), MOP (Potassium). '
          'Apply as per soil test results. Organic alternatives: compost, vermicompost, neem cake. '
          'Avoid over-fertilization as it damages soil health.';
    } else if (q.contains('sell') || q.contains('market') || q.contains('bech')) {
      return 'To sell your crops on AgriNexus AI: 1) Go to My Listings, 2) Tap "Add Listing", '
          '3) Take a crop photo for quality assessment, 4) Set your price and quantity, '
          '5) Your listing goes live instantly. Buyers in your region will see it.';
    } else {
      return 'Thank you for your question! I am the AgriNexus AI assistant. '
          'I can help you with: crop diseases, market prices, fertilizer advice, '
          'weather impact, selling guidance, and much more. '
          'Please ask me anything about farming!';
    }
  }

  // ── Market price chart data ───────────────────────────────────────────────
  static List<Map<String, dynamic>> getPriceHistory(String crop) {
    final base = {'Tomatoes': 25.0, 'Onions': 20.0, 'Rice': 65.0}[crop] ?? 40.0;
    return List.generate(7, (i) {
      final date = DateTime.now().subtract(Duration(days: 6 - i));
      final price = base + (_rng.nextDouble() - 0.5) * base * 0.3;
      return {
        'date': '${date.day}/${date.month}',
        'price': price,
      };
    });
  }
}
