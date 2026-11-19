// Marketplace Screen — Real-Time Mandi Lots & Trading
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
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Live Mandi Marketplace'),
        backgroundColor: AppTheme.primaryGreen,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded, color: Colors.white),
            onPressed: () => _showFilters(context, mp),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter header
          Container(
            color: AppTheme.primaryGreen,
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: TextField(
              controller: _searchCtrl,
              onChanged: mp.search,
              decoration: InputDecoration(
                hintText: 'Search crops, mandi, farmer names...',
                prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.textGrey, size: 22),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          _searchCtrl.clear();
                          mp.search('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          // Horizontal Category Filter Pills
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SizedBox(
              height: 38,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                physics: const BouncingScrollPhysics(),
                children: ['All', ...AppConstants.cropCategories].map((cat) {
                  final sel = mp.selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(cat),
                      selected: sel,
                      onSelected: (_) => mp.filterByCategory(cat),
                      selectedColor: AppTheme.brandGreen,
                      checkmarkColor: Colors.white,
                      backgroundColor: const Color(0xFFF1F5F9),
                      side: BorderSide(color: sel ? AppTheme.brandGreen : const Color(0xFFE2E8F0)),
                      labelStyle: TextStyle(
                        color: sel ? Colors.white : AppTheme.darkSlate,
                        fontSize: 12,
                        fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const Divider(height: 1, color: Color(0xFFE2E8F0)),

          // Products Count & Grade Filter Chip summary
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                Text(
                  '${mp.products.length} Active Lots Available',
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppTheme.textDark),
                ),
                const Spacer(),
                if (mp.selectedGrade != 'All')
                  Chip(
                    label: Text('Grade ${mp.selectedGrade}'),
                    deleteIcon: const Icon(Icons.close_rounded, size: 14),
                    onDeleted: () => mp.filterByGrade('All'),
                    visualDensity: VisualDensity.compact,
                    backgroundColor: AppTheme.brandGreen.withValues(alpha: 0.1),
                    labelStyle: const TextStyle(fontSize: 11, color: AppTheme.brandGreen, fontWeight: FontWeight.w700),
                  ),
              ],
            ),
          ),

          // Products Grid
          Expanded(
            child: mp.isLoading
                ? const Center(child: CircularProgressIndicator(color: AppTheme.brandGreen))
                : mp.products.isEmpty
                    ? _emptyState()
                    : RefreshIndicator(
                        onRefresh: mp.loadProducts,
                        color: AppTheme.brandGreen,
                        child: GridView.builder(
                          padding: const EdgeInsets.all(14),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 14,
                            crossAxisSpacing: 14,
                            childAspectRatio: 0.68,
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
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Filter Mandi Lots', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: AppTheme.darkSlate)),
                const Spacer(),
                IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const SizedBox(height: 14),
            const Text('Quality Grade Standard', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppTheme.textGrey)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: ['All', ...AppConstants.qualityGrades].map((g) {
                final sel = mp.selectedGrade == g;
                return ChoiceChip(
                  label: Text('Grade $g'),
                  selected: sel,
                  onSelected: (_) {
                    mp.filterByGrade(g);
                    Navigator.pop(ctx);
                  },
                  selectedColor: AppTheme.brandGreen,
                  labelStyle: TextStyle(color: sel ? Colors.white : AppTheme.darkSlate, fontWeight: FontWeight.w600),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
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
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.inventory_2_outlined, size: 48, color: AppTheme.textGrey),
          ),
          const SizedBox(height: 14),
          const Text('No Mandi Lots Found', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppTheme.darkSlate)),
          const SizedBox(height: 4),
          const Text('Try adjusting your search or category filters', style: TextStyle(color: AppTheme.textGrey, fontSize: 12)),
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
      case 'A+': return const Color(0xFF15803D);
      case 'A': return const Color(0xFF16A34A);
      case 'B': return const Color(0xFFD97706);
      default: return const Color(0xFF64748B);
    }
  }

  IconData get _cropIcon {
    final lower = product.name.toLowerCase();
    if (lower.contains('tomato')) return Icons.circle;
    if (lower.contains('rice') || lower.contains('grain')) return Icons.grass_rounded;
    if (lower.contains('mango') || lower.contains('fruit')) return Icons.eco_rounded;
    if (lower.contains('onion') || lower.contains('potato')) return Icons.spa_rounded;
    if (lower.contains('chili') || lower.contains('spice')) return Icons.local_fire_department_rounded;
    return Icons.agriculture_rounded;
  }

  Color get _cropColor {
    final lower = product.name.toLowerCase();
    if (lower.contains('tomato')) return Colors.red.shade600;
    if (lower.contains('rice')) return Colors.amber.shade700;
    if (lower.contains('mango')) return Colors.orange.shade700;
    if (lower.contains('onion')) return Colors.purple.shade600;
    if (lower.contains('chili')) return Colors.red.shade700;
    return AppTheme.brandGreen;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product))),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Crop Visual Header
            Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                gradient: LinearGradient(
                  colors: [_cropColor.withValues(alpha: 0.1), _cropColor.withValues(alpha: 0.22)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (product.imageUrl != null)
                      (product.imageUrl!.startsWith('http')
                          ? Image.network(
                              product.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Center(child: Icon(_cropIcon, size: 44, color: _cropColor)),
                            )
                          : Image.asset(
                              product.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Center(child: Icon(_cropIcon, size: 44, color: _cropColor)),
                            ))
                    else
                      Center(child: Icon(_cropIcon, size: 44, color: _cropColor)),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.black.withValues(alpha: 0.45), Colors.transparent],
                            begin: Alignment.topCenter,
                            end: const Alignment(0, 0.2),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          product.category,
                          style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _gradeColor,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 4),
                          ],
                        ),
                        child: Text(
                          product.qualityGrade,
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Card Body Details
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppTheme.darkSlate),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.verified_rounded, size: 12, color: AppTheme.brandGreen),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          product.farmerName,
                          style: const TextStyle(fontSize: 11, color: AppTheme.textGrey, fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₹${product.unitPrice.toStringAsFixed(0)}/kg',
                        style: const TextStyle(fontWeight: FontWeight.w800, color: AppTheme.brandGreen, fontSize: 14),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${product.quantity.toStringAsFixed(0)} kg',
                          style: const TextStyle(fontSize: 10, color: AppTheme.textDark, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 12, color: AppTheme.textGrey),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          product.location,
                          style: const TextStyle(fontSize: 10, color: AppTheme.textGrey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
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
