// Data Models for AgriNexus AI

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String language;
  final double trustScore;
  final int completedOrders;
  final String? avatarUrl;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.language,
    this.trustScore = 4.5,
    this.completedOrders = 0,
    this.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['user_id']?.toString() ?? '',
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        phone: json['phone'] ?? '',
        role: json['role'] ?? '',
        language: json['language'] ?? 'en',
        trustScore: (json['trust_score'] ?? 4.5).toDouble(),
        completedOrders: json['completed_orders'] ?? 0,
        avatarUrl: json['avatar_url'],
      );

  Map<String, dynamic> toJson() => {
        'user_id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'role': role,
        'language': language,
      };
}

class ProductModel {
  final String id;
  final String farmerId;
  final String farmerName;
  final String name;
  final String category;
  final double quantity;
  final double unitPrice;
  final String qualityGrade;
  final String? imageUrl;
  final String location;
  final String status;
  final double rating;
  final int ratingCount;
  final DateTime createdAt;
  final String description;

  const ProductModel({
    required this.id,
    required this.farmerId,
    required this.farmerName,
    required this.name,
    required this.category,
    required this.quantity,
    required this.unitPrice,
    required this.qualityGrade,
    this.imageUrl,
    required this.location,
    required this.status,
    this.rating = 4.0,
    this.ratingCount = 0,
    required this.createdAt,
    this.description = '',
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['product_id']?.toString() ?? '',
        farmerId: json['farmer_id']?.toString() ?? '',
        farmerName: json['farmer_name'] ?? '',
        name: json['name'] ?? '',
        category: json['category'] ?? '',
        quantity: (json['quantity'] ?? 0).toDouble(),
        unitPrice: (json['unit_price'] ?? 0).toDouble(),
        qualityGrade: json['quality_grade'] ?? 'B',
        imageUrl: json['image_url'],
        location: json['location'] ?? '',
        status: json['status'] ?? 'Available',
        rating: (json['rating'] ?? 4.0).toDouble(),
        ratingCount: json['rating_count'] ?? 0,
        createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
        description: json['description'] ?? '',
      );
}

class OrderModel {
  final String id;
  final String buyerId;
  final String buyerName;
  final String productId;
  final String productName;
  final String farmerName;
  final double quantity;
  final double totalAmount;
  final String status;
  final DateTime createdAt;
  final String? imageUrl;

  const OrderModel({
    required this.id,
    required this.buyerId,
    required this.buyerName,
    required this.productId,
    required this.productName,
    required this.farmerName,
    required this.quantity,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    this.imageUrl,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json['order_id']?.toString() ?? '',
        buyerId: json['buyer_id']?.toString() ?? '',
        buyerName: json['buyer_name'] ?? '',
        productId: json['product_id']?.toString() ?? '',
        productName: json['product_name'] ?? '',
        farmerName: json['farmer_name'] ?? '',
        quantity: (json['quantity'] ?? 0).toDouble(),
        totalAmount: (json['total_amount'] ?? 0).toDouble(),
        status: json['status'] ?? 'Pending',
        createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
        imageUrl: json['image_url'],
      );
}

class DiseaseReport {
  final String id;
  final String disease;
  final double confidence;
  final String advice;
  final String severity;
  final String? imageUrl;
  final DateTime createdAt;

  const DiseaseReport({
    required this.id,
    required this.disease,
    required this.confidence,
    required this.advice,
    required this.severity,
    this.imageUrl,
    required this.createdAt,
  });
}

class PricePrediction {
  final String crop;
  final String market;
  final double predictedPrice;
  final double minPrice;
  final double maxPrice;
  final String trend;
  final String dataPeriod;
  final String recommendation;

  const PricePrediction({
    required this.crop,
    required this.market,
    required this.predictedPrice,
    required this.minPrice,
    required this.maxPrice,
    required this.trend,
    required this.dataPeriod,
    required this.recommendation,
  });
}

class CropRecommendation {
  final String cropName;
  final double suitabilityScore;
  final String season;
  final String expectedYield;
  final double expectedPrice;
  final String reason;
  final String imageAsset;

  const CropRecommendation({
    required this.cropName,
    required this.suitabilityScore,
    required this.season,
    required this.expectedYield,
    required this.expectedPrice,
    required this.reason,
    required this.imageAsset,
  });
}

class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
