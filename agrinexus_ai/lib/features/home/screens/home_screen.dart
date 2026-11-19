// Home Screen — Real-Time Agriculture & Mandi Platform Dashboard
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/services/mock_data_service.dart';
import '../../../widgets/app_logo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    if (user == null) return const SizedBox();
    final isFarmer = user.role == AppConstants.roleFarmer;

    final List<_NavItem> navItems = [
      const _NavItem(icon: Icons.home_outlined, activeIcon: Icons.home_rounded, label: 'Home'),
      const _NavItem(icon: Icons.storefront_outlined, activeIcon: Icons.storefront_rounded, label: 'Mandi'),
      if (isFarmer) const _NavItem(icon: Icons.document_scanner_outlined, activeIcon: Icons.document_scanner_rounded, label: 'Scan'),
      if (isFarmer) const _NavItem(icon: Icons.query_stats_rounded, activeIcon: Icons.query_stats_rounded, label: 'Forecast'),
      const _NavItem(icon: Icons.receipt_long_outlined, activeIcon: Icons.receipt_long_rounded, label: 'Orders'),
      const _NavItem(icon: Icons.support_agent_outlined, activeIcon: Icons.support_agent_rounded, label: 'Advisory'),
      const _NavItem(icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded, label: 'Profile'),
    ];

    final routes = [
      '/home',
      '/marketplace',
      if (isFarmer) '/scan',
      if (isFarmer) '/predict',
      '/orders',
      '/assistant',
      '/profile',
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F6),
      body: _buildDashboard(context, user),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(navItems.length, (i) {
                final item = navItems[i];
                final selected = _currentIndex == i;
                return GestureDetector(
                  onTap: () {
                    if (i == 0) {
                      setState(() => _currentIndex = 0);
                    } else {
                      Navigator.pushNamed(context, routes[i]);
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: selected ? AppTheme.primaryGreen.withOpacity(0.12) : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          selected ? item.activeIcon : item.icon,
                          color: selected ? AppTheme.primaryGreen : AppTheme.textGrey,
                          size: 22,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 10,
                            color: selected ? AppTheme.primaryGreen : AppTheme.textGrey,
                            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, user) {
    final isFarmer = user.role == AppConstants.roleFarmer;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 180,
          pinned: true,
          backgroundColor: AppTheme.primaryGreen,
          title: Row(
            children: [
              const AppLogo(size: 32, backgroundColor: Colors.transparent),
              const SizedBox(width: 8),
              const Text('AgriNexus', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.circle, color: Color(0xFF00E676), size: 7),
                    SizedBox(width: 5),
                    Text('LIVE MANDI', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 0.5)),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryGreen, Color(0xFF1B5E20)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 85, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Welcome back, ${_greeting()}', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                    const SizedBox(height: 2),
                    Text(user.name, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.verified_user_rounded, color: Colors.green.shade200, size: 14),
                        const SizedBox(width: 4),
                        Text(_roleLabel(user.role), style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 12, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Live Mandi Scrolling Rates Banner
        SliverToBoxAdapter(
          child: _buildLiveTicker(),
        ),

        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Live Field Conditions & Weather Card
              _buildFieldTelemetryCard(),
              const SizedBox(height: 16),

              // Key Real-Time Market Stats
              Row(
                children: [
                  _statCard('₹28.50/kg', 'Live Tomato Index', Icons.trending_up_rounded, const Color(0xFF2E7D32), '▲ 3.8% today'),
                  const SizedBox(width: 10),
                  _statCard('1,420 Qtl', 'Active District Bids', Icons.inventory_2_outlined, const Color(0xFF1565C0), 'High Demand'),
                  const SizedBox(width: 10),
                  _statCard('${user.completedOrders}', 'Completed Orders', Icons.local_shipping_outlined, const Color(0xFFE65100), 'Verified'),
                ],
              ),
              const SizedBox(height: 20),

              // Quick Actions
              const Row(
                children: [
                  Text('Core Services', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.textDark)),
                  Spacer(),
                  Text('Real-time Hub', style: TextStyle(fontSize: 12, color: AppTheme.textGrey, fontWeight: FontWeight.w500)),
                ],
              ),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.55,
                children: [
                  _actionCard(
                    context,
                    Icons.storefront_rounded,
                    'Live Marketplace',
                    'Browse crop lots & bids',
                    '/marketplace',
                    const Color(0xFF1565C0),
                    'REAL-TIME',
                  ),
                  if (isFarmer)
                    _actionCard(
                      context,
                      Icons.document_scanner_rounded,
                      'Crop Health Scanner',
                      'Optical disease & grade test',
                      '/scan',
                      const Color(0xFF6A1B9A),
                      'INSTANT',
                    ),
                  if (isFarmer)
                    _actionCard(
                      context,
                      Icons.query_stats_rounded,
                      'Mandi Price Forecast',
                      'Daily rates & harvest trends',
                      '/predict',
                      const Color(0xFFE65100),
                      'LIVE FEED',
                    ),
                  _actionCard(
                    context,
                    Icons.local_shipping_rounded,
                    'Orders & Tracking',
                    'Dispatch & payment status',
                    '/orders',
                    const Color(0xFF00695C),
                    'ACTIVE',
                  ),
                  _actionCard(
                    context,
                    Icons.support_agent_rounded,
                    'Kisan Advisory Desk',
                    'Farming & mandi assistance',
                    '/assistant',
                    const Color(0xFF37474F),
                    '24x7',
                  ),
                  if (isFarmer)
                    _actionCard(
                      context,
                      Icons.add_business_rounded,
                      'List Produce',
                      'Direct farmer mandi listing',
                      '/add_product',
                      AppTheme.primaryGreen,
                      'SELL',
                    ),
                ],
              ),
              const SizedBox(height: 20),

              // Real-Time Mandi Highlights
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.show_chart_rounded, size: 18, color: AppTheme.primaryGreen),
                      SizedBox(width: 6),
                      Text('Today\'s Mandi Highlights', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.textDark)),
                    ],
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/marketplace'),
                    child: const Text('View All Lots', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppTheme.primaryGreen)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ..._buildMarketHighlights(),
              const SizedBox(height: 80),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildLiveTicker() {
    final tickerItems = [
      '🍅 Tomato: ₹28/kg ▲ +3.8%',
      '🧅 Onion: ₹34/kg ▼ -1.2%',
      '🌶️ Guntur Chilli: ₹185/kg ▲ +5.0%',
      '🌾 Telangana Sona Rice: ₹68/kg ▲ +2.1%',
      '🟡 Nizamabad Turmeric: ₹14,200/qtl ▲',
      '⚪ Khammam Cotton: ₹7,250/qtl ▲',
    ];

    return Container(
      color: const Color(0xFFE8F5E9),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            const SizedBox(width: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text('LIVE RATES', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800)),
            ),
            const SizedBox(width: 12),
            ...tickerItems.map((item) => Padding(
              padding: const EdgeInsets.only(right: 18),
              child: Text(
                item,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1B5E20)),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldTelemetryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.sensors_rounded, color: AppTheme.primaryGreen, size: 18),
              ),
              const SizedBox(width: 8),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Field Telemetry & Weather', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppTheme.textDark)),
                  Text('Warangal Region • Station #AG-04', style: TextStyle(fontSize: 11, color: AppTheme.textGrey)),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.circle, color: Color(0xFF2E7D32), size: 6),
                    SizedBox(width: 4),
                    Text('Active', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF2E7D32))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _telemetryItem(Icons.thermostat_rounded, '28°C', 'Air Temp', Colors.orange),
              _telemetryItem(Icons.water_drop_outlined, '64%', 'Humidity', Colors.blue),
              _telemetryItem(Icons.grass_rounded, '72%', 'Soil Moisture', Colors.green),
              _telemetryItem(Icons.air_rounded, '12 km/h', 'Wind Speed', Colors.teal),
            ],
          ),
        ],
      ),
    );
  }

  Widget _telemetryItem(IconData icon, String val, String title, Color color) {
    return Column(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(height: 4),
        Text(val, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppTheme.textDark)),
        Text(title, style: const TextStyle(fontSize: 10, color: AppTheme.textGrey)),
      ],
    );
  }

  Widget _statCard(String value, String label, IconData icon, Color color, String sub) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 18),
                const Spacer(),
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: color)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 10, color: AppTheme.textDark, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text(sub, style: TextStyle(fontSize: 9, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _actionCard(BuildContext ctx, IconData icon, String title, String sub, String route, Color color, String badge) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(ctx, route),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.25)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    badge,
                    style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: color, letterSpacing: 0.5),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: color)),
            const SizedBox(height: 2),
            Text(sub, style: const TextStyle(fontSize: 10, color: AppTheme.textGrey), maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildMarketHighlights() {
    final items = [
      {'crop': 'Desi Tomatoes (Grade A)', 'price': '₹28/kg', 'trend': '+3.8%', 'isUp': true, 'mandi': 'Warangal APMC', 'image': 'assets/images/crops/tomatoes.jpg'},
      {'crop': 'Nashik Red Onions', 'price': '₹34/kg', 'trend': '-1.2%', 'isUp': false, 'mandi': 'Hyderabad APMC', 'image': 'assets/images/crops/onions.jpg'},
      {'crop': 'Telangana Sona Rice', 'price': '₹68/kg', 'trend': '+2.1%', 'isUp': true, 'mandi': 'Karimnagar APMC', 'image': 'assets/images/crops/rice.jpg'},
      {'crop': 'Guntur Teja Red Chilli', 'price': '₹185/kg', 'trend': '+5.0%', 'isUp': true, 'mandi': 'Guntur APMC', 'image': 'assets/images/crops/chilies.jpg'},
    ];

    return items.map((item) {
      final isUp = item['isUp'] as bool;
      final img = item['image'] as String;
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                img,
                width: 44,
                height: 44,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 44,
                  height: 44,
                  color: AppTheme.primaryGreen.withOpacity(0.1),
                  child: const Icon(Icons.agriculture_rounded, color: AppTheme.primaryGreen, size: 22),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['crop'] as String, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppTheme.textDark)),
                  const SizedBox(height: 2),
                  Text(item['mandi'] as String, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(item['price'] as String, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppTheme.primaryGreen)),
                const SizedBox(height: 2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isUp ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                      color: isUp ? const Color(0xFF2E7D32) : Colors.red,
                      size: 16,
                    ),
                    Text(
                      item['trend'] as String,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isUp ? const Color(0xFF2E7D32) : Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    }).toList();
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good Morning';
    if (h < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  String _roleLabel(String role) {
    switch (role) {
      case AppConstants.roleFarmer: return 'Verified Farmer Account';
      case AppConstants.roleBuyer: return 'Registered Mandi Buyer';
      case AppConstants.roleConsumer: return 'Direct Retail Consumer';
      case AppConstants.roleLogistics: return 'Logistics & Fleet Partner';
      case AppConstants.roleAdmin: return 'Platform Administrator';
      default: return role;
    }
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItem({required this.icon, required this.activeIcon, required this.label});
}
