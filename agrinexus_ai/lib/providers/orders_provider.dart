// Orders Provider
import 'package:flutter/foundation.dart';
import '../data/models/models.dart';
import '../data/services/mock_data_service.dart';

class OrdersProvider extends ChangeNotifier {
  List<OrderModel> _orders = [];
  bool _isLoading = false;

  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;

  Future<void> loadOrders() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 500));
    _orders = MockDataService.sampleOrders;
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> placeOrder({
    required ProductModel product,
    required double quantity,
    required String buyerId,
    required String buyerName,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final order = OrderModel(
      id: 'ORD${DateTime.now().millisecondsSinceEpoch}',
      buyerId: buyerId,
      buyerName: buyerName,
      productId: product.id,
      productName: product.name,
      farmerName: product.farmerName,
      quantity: quantity,
      totalAmount: quantity * product.unitPrice,
      status: 'Pending',
      createdAt: DateTime.now(),
    );
    _orders.insert(0, order);
    notifyListeners();
    return true;
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    final idx = _orders.indexWhere((o) => o.id == orderId);
    if (idx == -1) return;
    final o = _orders[idx];
    _orders[idx] = OrderModel(
      id: o.id,
      buyerId: o.buyerId,
      buyerName: o.buyerName,
      productId: o.productId,
      productName: o.productName,
      farmerName: o.farmerName,
      quantity: o.quantity,
      totalAmount: o.totalAmount,
      status: status,
      createdAt: o.createdAt,
    );
    notifyListeners();
  }
}
