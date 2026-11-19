// Orders Screen
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/orders_provider.dart';
import '../../../data/models/models.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});
  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrdersProvider>().loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final op = context.watch<OrdersProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: op.isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryGreen))
          : op.orders.isEmpty
              ? _empty()
              : RefreshIndicator(
                  onRefresh: op.loadOrders,
                  color: AppTheme.primaryGreen,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: op.orders.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (ctx, i) => _OrderCard(order: op.orders[i]),
                  ),
                ),
    );
  }

  Widget _empty() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text('📦', style: TextStyle(fontSize: 48)),
        SizedBox(height: 12),
        Text('No orders yet', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        Text('Your orders will appear here', style: TextStyle(color: AppTheme.textGrey)),
      ],
    ),
  );
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  const _OrderCard({required this.order});

  Color get _statusColor {
    switch (order.status) {
      case AppConstants.statusDelivered: return AppTheme.successGreen;
      case AppConstants.statusInTransit: return Colors.blue;
      case AppConstants.statusConfirmed: return AppTheme.primaryGreen;
      case AppConstants.statusCancelled: return AppTheme.errorRed;
      default: return AppTheme.warningOrange;
    }
  }

  IconData get _statusIcon {
    switch (order.status) {
      case AppConstants.statusDelivered: return Icons.check_circle;
      case AppConstants.statusInTransit: return Icons.local_shipping;
      case AppConstants.statusConfirmed: return Icons.thumb_up;
      case AppConstants.statusCancelled: return Icons.cancel;
      default: return Icons.pending;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Order #${order.id}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: _statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_statusIcon, size: 14, color: _statusColor),
                    const SizedBox(width: 4),
                    Text(order.status, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _statusColor)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: 46, height: 46,
                decoration: BoxDecoration(color: AppTheme.lightBg, borderRadius: BorderRadius.circular(10)),
                child: const Center(child: Text('🌱', style: TextStyle(fontSize: 22))),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.productName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                    Text('Farmer: ${order.farmerName}', style: const TextStyle(fontSize: 12, color: AppTheme.textGrey)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('₹${order.totalAmount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppTheme.primaryGreen)),
                  Text('${order.quantity.toStringAsFixed(0)} kg', style: const TextStyle(fontSize: 12, color: AppTheme.textGrey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(DateFormat('dd MMM yyyy, hh:mm a').format(order.createdAt), style: const TextStyle(fontSize: 11, color: AppTheme.textGrey)),
              if (order.status == AppConstants.statusDelivered)
                TextButton.icon(
                  onPressed: () => _rateOrder(context),
                  icon: const Icon(Icons.star_outline, size: 16, color: AppTheme.accentGold),
                  label: const Text('Rate', style: TextStyle(color: AppTheme.accentGold, fontSize: 12)),
                  style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                ),
              if (order.status == AppConstants.statusInTransit)
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.map_outlined, size: 16, color: Colors.blue),
                  label: const Text('Track', style: TextStyle(color: Colors.blue, fontSize: 12)),
                  style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                ),
            ],
          ),
          // Status Progress
          _buildStatusProgress(),
        ],
      ),
    );
  }

  Widget _buildStatusProgress() {
    final statuses = [
      AppConstants.statusPending,
      AppConstants.statusConfirmed,
      AppConstants.statusInTransit,
      AppConstants.statusDelivered,
    ];
    if (order.status == AppConstants.statusCancelled) {
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(color: AppTheme.errorRed.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: const Text('This order was cancelled', style: TextStyle(color: AppTheme.errorRed, fontSize: 12)),
        ),
      );
    }
    final currentIdx = statuses.indexOf(order.status);
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: List.generate(statuses.length, (i) {
          final done = i <= currentIdx;
          return Expanded(
            child: Row(
              children: [
                if (i > 0) Expanded(child: Container(height: 2, color: done ? AppTheme.primaryGreen : Colors.grey.shade200)),
                Container(
                  width: 10, height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: done ? AppTheme.primaryGreen : Colors.grey.shade300,
                  ),
                ),
                if (i == statuses.length - 1) const SizedBox(),
              ],
            ),
          );
        }),
      ),
    );
  }

  void _rateOrder(BuildContext context) {
    int rating = 4;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Rate Your Experience', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) => GestureDetector(
                  onTap: () => setS(() => rating = i + 1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(i < rating ? Icons.star_rounded : Icons.star_outline_rounded, color: AppTheme.accentGold, size: 36),
                  ),
                )),
              ),
              const SizedBox(height: 20),
              const TextField(
                decoration: InputDecoration(labelText: 'Write a review (optional)', alignLabelWithHint: true),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('⭐ Thank you for your rating!'), backgroundColor: AppTheme.successGreen),
                  );
                },
                child: const Text('Submit Rating'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
