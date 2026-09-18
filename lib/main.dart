import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'theme/app_colors.dart';
import 'providers/password_provider.dart';
import 'widgets/bottom_nav.dart';
import 'models/models.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/home_screen.dart';
import 'screens/vault_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/add_edit_screen.dart';
import 'screens/search_screen.dart';
import 'screens/generator_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/about_screen.dart';
import 'screens/help_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.background,
    ),
  );
  runApp(const VaultKeyApp());
}

class VaultKeyApp extends StatelessWidget {
  const VaultKeyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => PasswordProvider())],
      child: MaterialApp(
        title: 'VaultKey',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.background,
          fontFamily: 'Nunito',
          colorScheme: const ColorScheme.dark(
            primary: AppColors.primary,
            secondary: AppColors.secondary,
            surface: AppColors.surface,
            error: AppColors.error,
          ),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: AppColors.textPrimary),
          ),
        ),
        home: const PasswordOrganizerApp(),
      ),
    );
  }
}

class PasswordOrganizerApp extends StatefulWidget {
  const PasswordOrganizerApp({super.key});

  @override
  State<PasswordOrganizerApp> createState() => _PasswordOrganizerAppState();
}

enum AppScreen {
  splash,
  onboarding,
  login,
  signup,
  forgot,
  home,
  vault,
  detail,
  add,
  edit,
  search,
  generator,
  notifications,
  profile,
  settings,
  about,
  help,
}

class _PasswordOrganizerAppState extends State<PasswordOrganizerApp> {
  AppScreen _screen = AppScreen.splash;
  PasswordEntry? _selectedPw;
  AppScreen _prevScreen = AppScreen.home;

  @override
  void initState() {
    super.initState();
    // Seed sample data if DB is empty
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PasswordProvider>().seedIfEmpty();
    });
  }

  void _go(AppScreen s) {
    setState(() {
      _prevScreen = _screen;
      _screen = s;
    });
  }

  void _goBack() {
    setState(() {
      _screen = _prevScreen;
    });
  }

  void _handleDetail(PasswordEntry pw) {
    setState(() {
      _selectedPw = pw;
      _prevScreen = _screen;
      _screen = AppScreen.detail;
    });
  }

  void _handleEdit() {
    setState(() {
      _screen = AppScreen.edit;
    });
  }

  bool get _showNav {
    return _screen == AppScreen.home ||
        _screen == AppScreen.vault ||
        _screen == AppScreen.generator ||
        _screen == AppScreen.notifications ||
        _screen == AppScreen.profile;
  }

  NavScreen _toNavScreen(AppScreen s) {
    switch (s) {
      case AppScreen.home:
        return NavScreen.home;
      case AppScreen.vault:
        return NavScreen.vault;
      case AppScreen.generator:
        return NavScreen.generator;
      case AppScreen.notifications:
        return NavScreen.notifications;
      case AppScreen.profile:
        return NavScreen.profile;
      default:
        return NavScreen.home;
    }
  }

  void _onNavTap(NavScreen nav) {
    final map = {
      NavScreen.home: AppScreen.home,
      NavScreen.vault: AppScreen.vault,
      NavScreen.generator: AppScreen.generator,
      NavScreen.notifications: AppScreen.notifications,
      NavScreen.profile: AppScreen.profile,
    };
    _go(map[nav]!);
  }

  Widget _buildScreen() {
    switch (_screen) {
      case AppScreen.splash:
        return SplashScreen(onNext: () => _go(AppScreen.onboarding));
      case AppScreen.onboarding:
        return OnboardingScreen(onNext: () => _go(AppScreen.login));
      case AppScreen.login:
        return LoginScreen(
          onLogin: () => _go(AppScreen.home),
          onSignup: () => _go(AppScreen.signup),
          onForgot: () => _go(AppScreen.forgot),
        );
      case AppScreen.signup:
        return SignupScreen(
          onBack: () => _go(AppScreen.login),
          onSignup: () => _go(AppScreen.login),
        );
      case AppScreen.forgot:
        return ForgotPasswordScreen(onBack: () => _go(AppScreen.login));
      case AppScreen.home:
        return HomeScreen(
          onNav: (s) => _go(_parseScreen(s)),
          onDetail: _handleDetail,
        );
      case AppScreen.vault:
        return VaultScreen(
          onNav: (s) => _go(_parseScreen(s)),
          onDetail: _handleDetail,
        );
      case AppScreen.detail:
        return DetailScreen(
          pw: _selectedPw ?? mockPasswords.first,
          onBack: _goBack,
          onEdit: _handleEdit,
        );
      case AppScreen.add:
        return AddEditScreen(onBack: _goBack, onSave: _goBack);
      case AppScreen.edit:
        return AddEditScreen(pw: _selectedPw, onBack: _goBack, onSave: _goBack);
      case AppScreen.search:
        return SearchScreen(onBack: _goBack, onDetail: _handleDetail);
      case AppScreen.generator:
        return const GeneratorScreen();
      case AppScreen.notifications:
        return NotificationsScreen(onBack: _goBack);
      case AppScreen.profile:
        return ProfileScreen(onNav: (s) => _go(_parseScreen(s)));
      case AppScreen.settings:
        return SettingsScreen(onBack: _goBack);
      case AppScreen.about:
        return AboutScreen(onBack: _goBack);
      case AppScreen.help:
        return HelpScreen(onBack: _goBack);
    }
  }

  AppScreen _parseScreen(String s) {
    switch (s) {
      case 'search':
        return AppScreen.search;
      case 'add':
        return AppScreen.add;
      case 'generator':
        return AppScreen.generator;
      case 'notifications':
        return AppScreen.notifications;
      case 'settings':
        return AppScreen.settings;
      case 'about':
        return AppScreen.about;
      case 'help':
        return AppScreen.help;
      case 'vault':
        return AppScreen.vault;
      default:
        return AppScreen.home;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Stack(
              children: [
                Positioned.fill(child: _buildScreen()),
                if (_showNav)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: BottomNav(
                      active: _toNavScreen(_screen),
                      onTap: _onNavTap,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
