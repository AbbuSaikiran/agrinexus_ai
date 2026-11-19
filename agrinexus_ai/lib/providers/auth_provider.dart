// Auth Provider — manages login state
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/models.dart';
import '../core/constants/app_constants.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.keyToken);
    if (token == null) return;
    final userId = prefs.getString(AppConstants.keyUserId) ?? '';
    final role = prefs.getString(AppConstants.keyUserRole) ?? '';
    final name = prefs.getString(AppConstants.keyUserName) ?? '';
    final lang = prefs.getString(AppConstants.keyLanguage) ?? 'en';
    _currentUser = UserModel(
      id: userId,
      name: name,
      email: '',
      phone: '',
      role: role,
      language: lang,
    );
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));

    // Mock login — accept any non-empty credentials
    if (email.isEmpty || password.isEmpty) {
      _error = 'Please enter email and password';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    // Determine role from email for demo
    String role = AppConstants.roleFarmer;
    if (email.contains('buyer')) role = AppConstants.roleBuyer;
    if (email.contains('admin')) role = AppConstants.roleAdmin;
    if (email.contains('logistics')) role = AppConstants.roleLogistics;

    _currentUser = UserModel(
      id: 'USR001',
      name: email.split('@').first.replaceAll('.', ' ').toUpperCase(),
      email: email,
      phone: '+91 9876543210',
      role: role,
      language: 'en',
      trustScore: 4.7,
      completedOrders: 24,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keyToken, 'mock-jwt-token-${DateTime.now().millisecondsSinceEpoch}');
    await prefs.setString(AppConstants.keyUserId, _currentUser!.id);
    await prefs.setString(AppConstants.keyUserRole, _currentUser!.role);
    await prefs.setString(AppConstants.keyUserName, _currentUser!.name);
    await prefs.setString(AppConstants.keyLanguage, _currentUser!.language);

    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String role,
    required String language,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));

    _currentUser = UserModel(
      id: 'USR${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      phone: phone,
      role: role,
      language: language,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keyToken, 'mock-jwt-token');
    await prefs.setString(AppConstants.keyUserId, _currentUser!.id);
    await prefs.setString(AppConstants.keyUserRole, role);
    await prefs.setString(AppConstants.keyUserName, name);
    await prefs.setString(AppConstants.keyLanguage, language);

    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _currentUser = null;
    notifyListeners();
  }

  void updateLanguage(String lang) async {
    if (_currentUser == null) return;
    _currentUser = UserModel(
      id: _currentUser!.id,
      name: _currentUser!.name,
      email: _currentUser!.email,
      phone: _currentUser!.phone,
      role: _currentUser!.role,
      language: lang,
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keyLanguage, lang);
    notifyListeners();
  }
}
