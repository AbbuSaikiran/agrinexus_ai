class AppConstants {
  static const String appName = 'AgriNexus';
  static const String tagline = 'Real-Time Agriculture & Mandi Network';

  // Roles
  static const String roleFarmer = 'FARMER';
  static const String roleBuyer = 'BUYER';
  static const String roleConsumer = 'CONSUMER';
  static const String roleLogistics = 'LOGISTICS';
  static const String roleAdmin = 'ADMIN';

  // Languages
  static const List<Map<String, String>> languages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'te', 'name': 'తెలుగు (Telugu)'},
    {'code': 'hi', 'name': 'हिंदी (Hindi)'},
    {'code': 'ta', 'name': 'தமிழ் (Tamil)'},
    {'code': 'kn', 'name': 'ಕನ್ನಡ (Kannada)'},
    {'code': 'mr', 'name': 'मराठी (Marathi)'},
  ];

  // Crop Categories
  static const List<String> cropCategories = [
    'Vegetables',
    'Fruits',
    'Grains',
    'Pulses',
    'Spices',
    'Other',
  ];

  // Quality Grades
  static const List<String> qualityGrades = ['A+', 'A', 'B', 'C'];

  // Order Statuses
  static const String statusPending = 'Pending';
  static const String statusConfirmed = 'Confirmed';
  static const String statusInTransit = 'In Transit';
  static const String statusDelivered = 'Delivered';
  static const String statusCancelled = 'Cancelled';

  // SharedPrefs Keys
  static const String keyToken = 'jwt_token';
  static const String keyUserId = 'user_id';
  static const String keyUserRole = 'user_role';
  static const String keyUserName = 'user_name';
  static const String keyLanguage = 'language';

  // Mock API base
  static const String baseUrl = 'https://api.agrinexus.example.com';
}
