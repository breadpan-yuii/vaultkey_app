import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FontLoader;
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:vaultkey_app/models/models.dart';
import 'package:vaultkey_app/providers/password_provider.dart';
import 'package:vaultkey_app/theme/app_colors.dart';
import 'package:vaultkey_app/screens/splash_screen.dart';
import 'package:vaultkey_app/screens/onboarding_screen.dart';
import 'package:vaultkey_app/screens/login_screen.dart';
import 'package:vaultkey_app/screens/signup_screen.dart';
import 'package:vaultkey_app/screens/forgot_password_screen.dart';
import 'package:vaultkey_app/screens/home_screen.dart';
import 'package:vaultkey_app/screens/vault_screen.dart';
import 'package:vaultkey_app/screens/detail_screen.dart';
import 'package:vaultkey_app/screens/add_edit_screen.dart';
import 'package:vaultkey_app/screens/search_screen.dart';
import 'package:vaultkey_app/screens/generator_screen.dart';
import 'package:vaultkey_app/screens/notifications_screen.dart';
import 'package:vaultkey_app/screens/profile_screen.dart';
import 'package:vaultkey_app/screens/settings_screen.dart';
import 'package:vaultkey_app/screens/about_screen.dart';
import 'package:vaultkey_app/screens/help_screen.dart';

Widget wrap(Widget child) {
  return ChangeNotifierProvider(
    create: (_) => PasswordProvider()..debugSetPasswords(mockPasswords),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Nunito',
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.surface,
          background: AppColors.background,
          error: AppColors.error,
        ),
      ),
      home: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: child,
            ),
          ),
        ),
      ),
    ),
  );
}

Future<void> checkScreen(WidgetTester tester, Widget screen, {String? name}) async {
  await tester.pumpWidget(wrap(screen));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
  final ex = tester.takeException();
  expect(ex, isNull, reason: '${name ?? screen.runtimeType} overflowed/errored:\n$ex');
}

void main() {
  setUpAll(() async {
    for (final (family, file) in [('Nunito', 'assets/fonts/Nunito.ttf'), ('JetBrains Mono', 'assets/fonts/JetBrainsMono.ttf')]) {
      final bytes = File(file).readAsBytesSync();
      final loader = FontLoader(family)..addFont(Future.value(ByteData.view(bytes.buffer)));
      await loader.load();
    }
  });

  Future<void> setPhone(WidgetTester tester, {Size size = const Size(411, 890)}) async {
    tester.view.devicePixelRatio = 3.0;
    tester.view.physicalSize = size * 3.0;
    tester.view.padding = const FakeViewPadding(top: 24, bottom: 16, left: 0, right: 0);
    addTearDown(tester.view.reset);
  }

  Future<void> runAll(WidgetTester tester) async {
    await checkScreen(tester, const SplashScreen(onNext: null), name: 'splash');

    await checkScreen(tester, const OnboardingScreen(onNext: null), name: 'onboarding-1');
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull, reason: 'onboarding-2');
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull, reason: 'onboarding-3');

    await checkScreen(tester, const LoginScreen(), name: 'login');
    await checkScreen(tester, const ForgotPasswordScreen(), name: 'forgot');

    await checkScreen(tester, const SignupScreen(), name: 'signup-empty');
    await tester.tap(find.text('Create Vault'));
    await tester.pump();
    expect(tester.takeException(), isNull, reason: 'signup-validated (errors shown)');
    await tester.enterText(find.byType(TextField).at(0), 'Alex Morgan');
    await tester.enterText(find.byType(TextField).at(1), 'alex@test.com');
    await tester.enterText(find.byType(TextField).at(2), 'MyStr0ng!Pass');
    await tester.enterText(find.byType(TextField).at(3), 'MyStr0ng!Pass');
    await tester.pump();
    expect(tester.takeException(), isNull, reason: 'signup-typed');

    await checkScreen(tester, const HomeScreen(), name: 'home');
    await checkScreen(tester, const VaultScreen(), name: 'vault');
    await tester.tap(find.text('Social'));
    await tester.pump();
    expect(tester.takeException(), isNull, reason: 'vault-filter');
    await tester.tap(find.text('All'));
    await tester.pump();

    await checkScreen(tester, DetailScreen(pw: mockPasswords.first), name: 'detail');
    await checkScreen(tester, AddEditScreen(pw: mockPasswords.first), name: 'addEdit-edit');
    await checkScreen(tester, const AddEditScreen(), name: 'addEdit-new');

    await checkScreen(tester, const SearchScreen(), name: 'search');

    await checkScreen(tester, const GeneratorScreen(), name: 'generator');
    await checkScreen(tester, const NotificationsScreen(), name: 'notifications');

    await checkScreen(tester, const ProfileScreen(), name: 'profile');
    await checkScreen(tester, const SettingsScreen(), name: 'settings');
    await checkScreen(tester, const AboutScreen(), name: 'about');
    await checkScreen(tester, const HelpScreen(), name: 'help');
  }

  testWidgets('all screens fit a large phone (Pixel ~411x890)', (tester) async {
    await setPhone(tester);
    await runAll(tester);
  });

  testWidgets('all screens fit a compact phone (360x640)', (tester) async {
    await setPhone(tester, size: const Size(360, 640));
    await runAll(tester);
  });

  testWidgets('full app boots to home without errors at phone size', (tester) async {
    await setPhone(tester);
    await tester.pumpWidget(wrap(const SplashScreen()));
    await tester.tap(find.text('Tap to continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();
  });
}