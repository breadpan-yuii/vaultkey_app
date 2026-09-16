import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF00BCB4);
  static const secondary = Color(0xFF0077B6);
  static const background = Color(0xFF0D1121);
  static const surface = Color(0xFF141A2E);
  static const cardBg = Color(0x0AFFFFFF);
  static const cardBorder = Color(0x12FFFFFF);
  static const textPrimary = Color(0xFFE8EAF0);
  static const textSecondary = Color(0xFF73798A);
  static const textMuted = Color(0x73FFFFFF);
  static const success = Color(0xFF22C55E);
  static const error = Color(0xFFEF4444);
  static const warning = Color(0xFFF97316);
  static const info = Color(0xFF60A5FA);

  // Category colors
  static const social = Color(0xFFA78BFA);
  static const banking = Color(0xFF34D399);
  static const email = Color(0xFF60A5FA);
  static const shopping = Color(0xFFF472B6);
  static const work = Color(0xFFFCD34D);
  static const other = Color(0xFF94A3B8);

  // Strength colors
  static const strengthWeak = Color(0xFFEF4444);
  static const strengthFair = Color(0xFFF97316);
  static const strengthStrong = Color(0xFFEAB308);
  static const strengthExcellent = Color(0xFF22C55E);
}

class AppGradients {
  static const primary = LinearGradient(
    colors: [AppColors.primary, AppColors.secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const splash = LinearGradient(
    colors: [AppColors.background, Color(0xFF0F2027), AppColors.background],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const header = LinearGradient(
    colors: [Color(0xFF0F1E35), AppColors.background],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const detailHeader = LinearGradient(
    colors: [Color(0xFF0F2027), AppColors.background],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

class AppBorderRadius {
  static const double xs = 8.0;
  static const double sm = 10.0;
  static const double md = 12.0;
  static const double lg = 14.0;
  static const double xl = 16.0;
  static const double xxl = 18.0;
  static const double xxxl = 20.0;
  static const double card = 24.0;
}
