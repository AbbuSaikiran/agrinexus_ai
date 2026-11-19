// Profile Screen
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser!;

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [AppTheme.primaryGreen, Color(0xFF1B5E20)]),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: Text(user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: Colors.white)),
                  ),
                  const SizedBox(height: 14),
                  Text(user.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text(_roleLabel(user.role), style: const TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _statBadge('${user.completedOrders}', 'Orders'),
                      Container(height: 24, width: 1, color: Colors.white30, margin: const EdgeInsets.symmetric(horizontal: 16)),
                      _statBadge('${user.trustScore}⭐', 'Trust Score'),
                      Container(height: 24, width: 1, color: Colors.white30, margin: const EdgeInsets.symmetric(horizontal: 16)),
                      _statBadge('Active', 'Status'),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info Card
                  _sectionCard([
                    _infoTile(Icons.email_outlined, 'Email', user.email.isNotEmpty ? user.email : 'farmer@example.com'),
                    _divider(),
                    _infoTile(Icons.phone_outlined, 'Phone', user.phone.isNotEmpty ? user.phone : '+91 9876543210'),
                    _divider(),
                    _infoTile(Icons.location_on_outlined, 'Location', 'Narsampet, Warangal'),
                  ]),
                  const SizedBox(height: 16),
                  // Language Selector
                  _sectionCard([
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
                      child: Text('Preferred Language', style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: AppConstants.languages.map((lang) {
                          final sel = user.language == lang['code'];
                          return GestureDetector(
                            onTap: () => auth.updateLanguage(lang['code']!),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: sel ? AppTheme.primaryGreen : AppTheme.lightBg,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: sel ? AppTheme.primaryGreen : Colors.grey.shade300),
                              ),
                              child: Text(lang['name']!, style: TextStyle(fontSize: 12, color: sel ? Colors.white : AppTheme.textDark, fontWeight: sel ? FontWeight.w600 : FontWeight.w400)),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 16),
                  // Settings
                  _sectionCard([
                    _actionTile(Icons.notifications_outlined, 'Notifications', onTap: () {}),
                    _divider(),
                    _actionTile(Icons.security_outlined, 'Privacy & Security', onTap: () {}),
                    _divider(),
                    _actionTile(Icons.help_outline, 'Help & Support', onTap: () {}),
                    _divider(),
                    _actionTile(Icons.info_outline, 'About AgriNexus', onTap: () => _showAbout(context)),
                  ]),
                  const SizedBox(height: 16),
                  // Logout
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Sign Out'),
                            content: const Text('Are you sure you want to sign out?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                              TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Sign Out', style: TextStyle(color: AppTheme.errorRed))),
                            ],
                          ),
                        );
                        if (confirm == true && context.mounted) {
                          await auth.logout();
                          Navigator.pushReplacementNamed(context, '/login');
                        }
                      },
                      icon: const Icon(Icons.logout, color: AppTheme.errorRed),
                      label: const Text('Sign Out', style: TextStyle(color: AppTheme.errorRed)),
                      style: OutlinedButton.styleFrom(side: const BorderSide(color: AppTheme.errorRed)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Center(child: Text('AgriNexus Platform v1.0.0 • Real-Time Mandi Network', style: TextStyle(fontSize: 11, color: AppTheme.textGrey))),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statBadge(String val, String label) => Column(
    children: [
      Text(val, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
      Text(label, style: const TextStyle(color: Colors.white60, fontSize: 11)),
    ],
  );

  Widget _sectionCard(List<Widget> children) => Container(
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]),
    child: Column(children: children),
  );

  Widget _infoTile(IconData icon, String label, String value) => ListTile(
    leading: Icon(icon, color: AppTheme.primaryGreen, size: 22),
    title: Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textGrey)),
    subtitle: Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.textDark)),
    dense: true,
  );

  Widget _actionTile(IconData icon, String label, {required VoidCallback onTap}) => ListTile(
    leading: Icon(icon, color: AppTheme.textGrey, size: 22),
    title: Text(label, style: const TextStyle(fontSize: 14)),
    trailing: const Icon(Icons.chevron_right, color: AppTheme.textGrey, size: 20),
    onTap: onTap,
    dense: true,
  );

  Widget _divider() => const Divider(height: 1, indent: 56, endIndent: 16);

  String _roleLabel(String role) {
    switch (role) {
      case AppConstants.roleFarmer: return '🌾 Farmer';
      case AppConstants.roleBuyer: return '🏪 Buyer';
      case AppConstants.roleConsumer: return '🛒 Consumer';
      case AppConstants.roleLogistics: return '🚚 Logistics Partner';
      case AppConstants.roleAdmin: return '⚙️ Administrator';
      default: return role;
    }
  }

  void _showAbout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('About AgriNexus'),
        content: const Text(
          'AgriNexus is a real-time smart agriculture platform and digital mandi network connecting farmers, buyers, and logistics partners.\n\nKey Capabilities:\n• Live Mandi Market Tickers & Price Forecasts\n• Optical Crop Health & Quality Certification\n• Direct Farmer-to-Buyer Marketplace Lots\n• Field Telemetry & Weather Stations\n• Multilingual Kisan Advisory Support',
          style: TextStyle(height: 1.5, fontSize: 13),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
      ),
    );
  }
}
