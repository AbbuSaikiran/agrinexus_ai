import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:agrinexus_ai/core/theme/app_theme.dart';
import 'package:agrinexus_ai/providers/auth_provider.dart';
import 'package:agrinexus_ai/providers/marketplace_provider.dart';
import 'package:agrinexus_ai/providers/orders_provider.dart';
import 'package:agrinexus_ai/features/auth/screens/login_screen.dart';

void main() {
  testWidgets('Capture Login Screen', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const LoginScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final dir = Directory('documentation_screenshots');
    if (!dir.existsSync()) dir.createSync(recursive: true);

    await expectLater(
      find.byType(LoginScreen),
      matchesGoldenFile('../documentation_screenshots/02_Login_Screen.png'),
    );
  });
}
