// Marketplace Screen
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/marketplace_provider.dart';
import '../../../data/models/models.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import 'product_detail_screen.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});
  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MarketplaceProvider>().loadProducts();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mp = context.watch<MarketplaceProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Mandi Marketplace'),
        actions: [
          IconButton(icon: const Icon(Icons.tune), onPressed: () => _showFilters(context, mp)),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: AppTheme.primaryGreen,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextField(
              controller: _searchCtrl,
              onChanged: mp.search,
              decoration: InputDecoration(
                hintText: 'Search crops, farmers, locations...',
                prefixIcon: const Icon(Icons.search, color: AppTheme.textGrey),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(icon: const Icon(Icons.clear), onPressed: () { _searchCtrl.clear(); mp.search(''); })
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          // Category Filter
          SizedBox(
            height: 46,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              children: ['All', ...AppConstants.cropCategories].map((cat) {
                final sel = mp.selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(cat),
                    selected: sel,
                    onSelected: (_) => mp.filterByCategory(cat),
                    selectedColor: AppTheme.primaryGreen.withOpacity(0.15),
                    checkmarkColor: AppTheme.primaryGreen,
                    backgroundColor: Colors.white,
                    side: BorderSide(color: sel ? AppTheme.primaryGreen : Colors.grey.shade300),
                    labelStyle: TextStyle(color: sel ? AppTheme.primaryGreen : AppTheme.textDark, fontSize: 12, fontWeight: sel ? FontWeight.w600 : FontWeight.w400),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                  ),
                );
              }).toList(),
            ),
          ),
          // Products Grid
          Expanded(
            child: mp.isLoading
                ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryGreen))
                : mp.products.isEmpty
                    ? _emptyState()
                    : RefreshIndicator(
                        onRefresh: mp.loadProducts,
                        color: AppTheme.primaryGreen,
                        child: GridView.builder(
                          padding: const EdgeInsets.all(14),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 14,
                            crossAxisSpacing: 14,
                            childAspectRatio: 0.72,
                          ),
                          itemCount: mp.products.length,
                          itemBuilder: (ctx, i) => _ProductCard(product: mp.products[i]),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  void _showFilters(BuildContext ctx, MarketplaceProvider mp) {
    showModalBottomSheet(
      context: ctx,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Filter by Quality Grade', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              children: ['All', ...AppConstants.qualityGrades].map((g) {
                final sel = mp.selectedGrade == g;
                return ChoiceChip(label: Text(g), selected: sel, onSelected: (_) { mp.filterByGrade(g); Navigator.pop(ctx); });
              }).toList(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🌾', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          const Text('No products found', style: TextStyle(fontWeight: FontWeight.w600)),
          const Text('Try a different search or filter', style: TextStyle(color: AppTheme.textGrey)),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductModel product;
  const _ProductCard({required this.product});

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
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product))),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Container(
              height: 110,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                gradient: LinearGradient(
                  colors: [AppTheme.primaryGreen.withOpacity(0.1), AppTheme.primaryGreen.withOpacity(0.3)],
                ),
              ),
              child: Stack(
                children: [
                  const Center(child: Text('🌱', style: TextStyle(fontSize: 44))),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: _gradeColor, borderRadius: BorderRadius.circular(10)),
                      child: Text(product.qualityGrade, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(product.farmerName, style: const TextStyle(fontSize: 11, color: AppTheme.textGrey), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: AppTheme.accentGold, size: 14),
                      Text(' ${product.rating}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                      Text(' (${product.ratingCount})', style: const TextStyle(fontSize: 10, color: AppTheme.textGrey)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('₹${product.unitPrice.toStringAsFixed(0)}/kg', style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.primaryGreen, fontSize: 14)),
                      Text('${product.quantity.toStringAsFixed(0)}kg', style: const TextStyle(fontSize: 11, color: AppTheme.textGrey)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 11, color: AppTheme.textGrey),
                      Expanded(child: Text(' ${product.location}', style: const TextStyle(fontSize: 10, color: AppTheme.textGrey), maxLines: 1, overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
