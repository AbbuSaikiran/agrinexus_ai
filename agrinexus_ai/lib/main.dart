// main.dart — AgriNexus AI Entry Point
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/marketplace_provider.dart';
import 'providers/orders_provider.dart';

import 'features/auth/screens/splash_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/marketplace/screens/marketplace_screen.dart';
import 'features/marketplace/screens/add_product_screen.dart';
import 'features/scan/screens/scan_screen.dart';
import 'features/predict/screens/predict_screen.dart';
import 'features/orders/screens/orders_screen.dart';
import 'features/assistant/screens/assistant_screen.dart';
import 'features/profile/screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const AgriNexusApp());
}

class AgriNexusApp extends StatelessWidget {
  const AgriNexusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MarketplaceProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
      ],
      child: MaterialApp(
        title: 'AgriNexus',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: '/',
        routes: {
          '/': (_) => const SplashScreen(),
          '/login': (_) => const LoginScreen(),
          '/register': (_) => const RegisterScreen(),
          '/home': (_) => const HomeScreen(),
          '/marketplace': (_) => const MarketplaceScreen(),
          '/add_product': (_) => const AddProductScreen(),
          '/scan': (_) => const ScanScreen(),
          '/predict': (_) => const PredictScreen(),
          '/orders': (_) => const OrdersScreen(),
          '/assistant': (_) => const AssistantScreen(),
          '/profile': (_) => const ProfileScreen(),
        },
      ),
    );
  }
}
