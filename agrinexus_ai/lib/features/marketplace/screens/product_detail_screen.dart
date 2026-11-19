// Product Detail Screen
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/models.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/orders_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductModel product;
  const ProductDetailScreen({super.key, required this.product});

  Color get _gradeColor {
    switch (product.qualityGrade) {
      case 'A+': return const Color(0xFF1B5E20);
      case 'A': return AppTheme.primaryGreen;
      case 'B': return AppTheme.accentGold;
      default: return AppTheme.textGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthProvider>().currentUser!;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppTheme.primaryGreen,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [AppTheme.primaryGreen.withOpacity(0.3), AppTheme.primaryGreen.withOpacity(0.6)]),
                ),
                child: const Center(child: Text('🌱', style: TextStyle(fontSize: 80))),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(product.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: _gradeColor, borderRadius: BorderRadius.circular(20)),
                      child: Text('Grade ${product.qualityGrade}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, color: AppTheme.accentGold, size: 18),
                    Text(' ${product.rating} ', style: const TextStyle(fontWeight: FontWeight.w700)),
                    Text('(${product.ratingCount} ratings)', style: const TextStyle(color: AppTheme.textGrey, fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 16),
                // Price & Quantity
                Row(
                  children: [
                    _infoBox('Price', '₹${product.unitPrice.toStringAsFixed(0)}/kg', Icons.currency_rupee, AppTheme.primaryGreen),
                    const SizedBox(width: 12),
                    _infoBox('Available', '${product.quantity.toStringAsFixed(0)} kg', Icons.inventory_2_outlined, Colors.blue),
                  ],
                ),
                const SizedBox(height: 16),
                // Farmer Info
                _sectionHeader('Farmer Details'),
                _farmerCard(context),
                const SizedBox(height: 16),
                // Location
                _sectionHeader('Location'),
                _locationCard(),
                const SizedBox(height: 16),
                // Description
                if (product.description.isNotEmpty) ...[
                  _sectionHeader('Description'),
                  Text(product.description, style: const TextStyle(color: AppTheme.textGrey, height: 1.5)),
                  const SizedBox(height: 16),
                ],
                // AI Quality Badge
                _qualityBadge(),
                const SizedBox(height: 90),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, -4))],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showOrderDialog(context, user),
                icon: const Icon(Icons.shopping_cart_checkout),
                label: const Text('Buy Now'),
              ),
            ),
            const SizedBox(width: 12),
            OutlinedButton(
              onPressed: () {},
              child: const Icon(Icons.chat_outlined, color: AppTheme.primaryGreen),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoBox(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textGrey)),
                Text(value, style: TextStyle(fontWeight: FontWeight.w700, color: color, fontSize: 16)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textDark)),
  );

  Widget _farmerCard(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: Row(
      children: [
        CircleAvatar(
          backgroundColor: AppTheme.primaryGreen.withOpacity(0.15),
          child: Text(product.farmerName[0], style: const TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.w700)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.farmerName, style: const TextStyle(fontWeight: FontWeight.w700)),
              Row(
                children: const [
                  Icon(Icons.verified, size: 14, color: AppTheme.primaryGreen),
                  Text(' Verified Farmer', style: TextStyle(fontSize: 12, color: AppTheme.primaryGreen)),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: AppTheme.primaryGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: const Row(
            children: [
              Icon(Icons.star, size: 13, color: AppTheme.primaryGreen),
              Text(' 4.7', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.primaryGreen)),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _locationCard() => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.blue.shade50,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      children: [
        const Icon(Icons.location_on, color: Colors.blue),
        const SizedBox(width: 10),
        Expanded(child: Text(product.location, style: const TextStyle(fontWeight: FontWeight.w500))),
      ],
    ),
  );

  Widget _qualityBadge() => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: [AppTheme.primaryGreen.withOpacity(0.08), Colors.green.shade50]),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.2)),
    ),
    child: Row(
      children: [
        const Text('🤖', style: TextStyle(fontSize: 24)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('AI Quality Verified', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppTheme.primaryGreen)),
              Text('Grade ${product.qualityGrade} assessed by YOLOv8 model with 94% confidence', style: const TextStyle(fontSize: 12, color: AppTheme.textGrey)),
            ],
          ),
        ),
      ],
    ),
  );

  void _showOrderDialog(BuildContext context, dynamic user) {
    double qty = 10;
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
              const Text('Place Order', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Quantity (kg):', style: TextStyle(fontWeight: FontWeight.w500)),
                  Row(
                    children: [
                      IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () => setS(() { if (qty > 1) qty--; })),
                      Text('$qty', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                      IconButton(icon: const Icon(Icons.add_circle_outline, color: AppTheme.primaryGreen), onPressed: () => setS(() { qty++; })),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: AppTheme.lightBg, borderRadius: BorderRadius.circular(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Amount:', style: TextStyle(fontWeight: FontWeight.w600)),
                    Text('₹${(qty * product.unitPrice).toStringAsFixed(0)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.primaryGreen)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(ctx);
                  await context.read<OrdersProvider>().placeOrder(
                    product: product,
                    quantity: qty,
                    buyerId: user.id,
                    buyerName: user.name,
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('✅ Order placed successfully!'), backgroundColor: AppTheme.successGreen),
                    );
                  }
                },
                child: const Text('Confirm Order'),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
