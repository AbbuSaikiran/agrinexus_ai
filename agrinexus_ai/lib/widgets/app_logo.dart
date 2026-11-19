import 'package:flutter/material.dart';

/// App logo displaying the official AgriNexus AI emblem
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
        borderRadius: BorderRadius.circular(size * 0.22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.12),
            blurRadius: size * 0.2,
            offset: Offset(0, size * 0.08),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(size * 0.06),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(size * 0.18),
              child: Image.asset(
                'assets/images/logo.png',
                width: size * 0.88,
                height: size * 0.88,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.agriculture_rounded,
                    size: size * 0.5,
                    color: const Color(0xFF1B5E20),
                  );
                },
              ),
            ),
          ),
          if (showBadge)
            Positioned(
              right: size * 0.04,
              top: size * 0.04,
              child: Container(
                width: size * 0.2,
                height: size * 0.2,
                decoration: BoxDecoration(
                  color: const Color(0xFF16A34A),
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
