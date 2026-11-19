import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:agrinexus_ai/core/theme/app_theme.dart';
import 'package:agrinexus_ai/providers/auth_provider.dart';
import 'package:agrinexus_ai/providers/marketplace_provider.dart';
import 'package:agrinexus_ai/providers/orders_provider.dart';
import 'package:agrinexus_ai/data/models/models.dart';
import 'package:agrinexus_ai/features/auth/screens/splash_screen.dart';
import 'package:agrinexus_ai/features/auth/screens/login_screen.dart';
import 'package:agrinexus_ai/features/home/screens/home_screen.dart';
import 'package:agrinexus_ai/features/marketplace/screens/marketplace_screen.dart';
import 'package:agrinexus_ai/features/scan/screens/scan_screen.dart';
import 'package:agrinexus_ai/features/predict/screens/predict_screen.dart';
import 'package:agrinexus_ai/features/assistant/screens/assistant_screen.dart';
import 'package:agrinexus_ai/features/orders/screens/orders_screen.dart';

Future<void> _capture(WidgetTester tester, GlobalKey key, String name) async {
  RenderRepaintBoundary boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
  ui.Image image = await boundary.toImage(pixelRatio: 1.5);
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  final pngBytes = byteData!.buffer.asUint8List();
  final outDir = Directory('C:/Users/abbus/Desktop/sreeja/agrinexus_ai/documentation_screenshots');
  if (!outDir.existsSync()) outDir.createSync(recursive: true);
  File('${outDir.path}/$name').writeAsBytesSync(pngBytes);
  // Also copy to documentation_assets for easy inclusion
  final assetDir = Directory('C:/Users/abbus/Desktop/sreeja/agrinexus_ai/documentation_assets');
  if (!assetDir.existsSync()) assetDir.createSync(recursive: true);
  File('${assetDir.path}/$name').writeAsBytesSync(pngBytes);
}

Widget _buildWrapper({required Widget child, required GlobalKey key, bool isLoggedIn = true}) {
  final auth = AuthProvider();
  if (isLoggedIn) {
    auth.setCurrentUserForTesting(
      const UserModel(
        id: 'f1',
        name: 'Ramesh Reddy',
        email: 'farmer@test.com',
        phone: '+91 98765 43210',
        role: 'FARMER',
        language: 'en',
        trustScore: 4.8,
        completedOrders: 14,
      ),
    );
  }

  final marketplace = MarketplaceProvider();
  final orders = OrdersProvider();

  return MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: auth),
      ChangeNotifierProvider.value(value: marketplace),
      ChangeNotifierProvider.value(value: orders),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: RepaintBoundary(key: key, child: child),
      routes: {
        '/home': (_) => const HomeScreen(),
        '/login': (_) => const LoginScreen(),
        '/marketplace': (_) => const MarketplaceScreen(),
        '/scan': (_) => const ScanScreen(),
        '/predict': (_) => const PredictScreen(),
        '/orders': (_) => const OrdersScreen(),
        '/assistant': (_) => const AssistantScreen(),
      },
    ),
  );
}

void main() {
  testWidgets('Capture All Screen Images', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2160);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // 1. Splash Screen
    final k1 = GlobalKey();
    await tester.pumpWidget(_buildWrapper(child: const SplashScreen(), key: k1, isLoggedIn: false));
    await tester.pump(const Duration(milliseconds: 500));
    await _capture(tester, k1, '01_Splash_Screen.png');
    await tester.pump(const Duration(seconds: 3));

    // 2. Login Screen
    final k2 = GlobalKey();
    await tester.pumpWidget(_buildWrapper(child: const LoginScreen(), key: k2, isLoggedIn: false));
    await tester.pumpAndSettle();
    await _capture(tester, k2, '02_Login_Screen.png');

    // 3. Home Dashboard
    final k3 = GlobalKey();
    await tester.pumpWidget(_buildWrapper(child: const HomeScreen(), key: k3, isLoggedIn: true));
    await tester.pumpAndSettle();
    await _capture(tester, k3, '03_Home_Dashboard.png');

    // 4. Live Mandi Marketplace
    final k4 = GlobalKey();
    await tester.pumpWidget(_buildWrapper(child: const MarketplaceScreen(), key: k4, isLoggedIn: true));
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    await _capture(tester, k4, '04_Live_Mandi_Marketplace.png');

    // 5. Crop Health Scanner
    final k5 = GlobalKey();
    await tester.pumpWidget(_buildWrapper(child: const ScanScreen(), key: k5, isLoggedIn: true));
    await tester.pumpAndSettle();
    await _capture(tester, k5, '05_Crop_Health_Scanner.png');

    // 6. Mandi Price Forecast
    final k6 = GlobalKey();
    await tester.pumpWidget(_buildWrapper(child: const PredictScreen(), key: k6, isLoggedIn: true));
    await tester.pumpAndSettle();
    await _capture(tester, k6, '06_Mandi_Price_Forecast.png');

    // 7. Kisan Advisory Desk
    final k7 = GlobalKey();
    await tester.pumpWidget(_buildWrapper(child: const AssistantScreen(), key: k7, isLoggedIn: true));
    await tester.pumpAndSettle();
    await _capture(tester, k7, '07_Kisan_Advisory_Desk.png');

    // 8. Orders Tracking
    final k8 = GlobalKey();
    await tester.pumpWidget(_buildWrapper(child: const OrdersScreen(), key: k8, isLoggedIn: true));
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    await _capture(tester, k8, '08_Orders_and_Logistics.png');
  });
}
