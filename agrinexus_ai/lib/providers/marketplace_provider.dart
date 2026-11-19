// Marketplace Provider
import 'package:flutter/foundation.dart';
import '../data/models/models.dart';
import '../data/services/mock_data_service.dart';

class MarketplaceProvider extends ChangeNotifier {
  List<ProductModel> _products = [];
  List<ProductModel> _filteredProducts = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _selectedGrade = 'All';

  List<ProductModel> get products => _filteredProducts;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  String get selectedGrade => _selectedGrade;

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 600));
    _products = MockDataService.sampleProducts;
    _applyFilters();
    _isLoading = false;
    notifyListeners();
  }

  void search(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  void filterByGrade(String grade) {
    _selectedGrade = grade;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredProducts = _products.where((p) {
      final matchSearch = _searchQuery.isEmpty ||
          p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.farmerName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.location.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchCategory =
          _selectedCategory == 'All' || p.category == _selectedCategory;
      final matchGrade =
          _selectedGrade == 'All' || p.qualityGrade == _selectedGrade;
      return matchSearch && matchCategory && matchGrade && p.status == 'Available';
    }).toList();
  }

  Future<void> addProduct(ProductModel product) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _products.insert(0, product);
    _applyFilters();
    notifyListeners();
  }
}
