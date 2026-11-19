import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

/// Professional vector-based logo for AgriNexus
/// Replaces placeholder emojis with an authentic AgriTech emblem.
class AppLogo extends StatelessWidget {
  final double size;
  final bool showBadge;
  final Color? backgroundColor;

  const AppLogo({
    super.key,
    this.size = 80,
    this.showBadge = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(size * 0.26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: size * 0.25,
            offset: Offset(0, size * 0.1),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background organic leaf gradient ring
          Container(
            margin: EdgeInsets.all(size * 0.12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(size * 0.2),
            ),
          ),
          // Clean custom icon: Interconnected sprout / leaf network
          Icon(
            Icons.spa_rounded,
            size: size * 0.52,
            color: const Color(0xFFC8E6C9),
          ),
          Positioned(
            bottom: size * 0.24,
            child: Container(
              width: size * 0.28,
              height: 2.5,
              decoration: BoxDecoration(
                color: const Color(0xFFFDD835),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Live pulse dot indicator when showBadge is enabled
          if (showBadge)
            Positioned(
              right: size * 0.08,
              top: size * 0.08,
              child: Container(
                width: size * 0.18,
                height: size * 0.18,
                decoration: BoxDecoration(
                  color: const Color(0xFF00E676),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
