import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFFEDE9E3);
  static const surface = Color(0xFFE2DDD5);
  static const surfaceBorder = Color(0xFFC8C0B4);
  static const cardBg = Color(0xFFE8E3DB);

  static const primary = Color(0xFF7A2E2B);    // dark red
  static const primaryLight = Color(0xFFE8DDD5);

  static const green = Color(0xFF8AAA78);       // sage green
  static const greenDark = Color(0xFF5A7A4A);
  static const greenCard = Color(0xFFD4DBC8);
  static const greenBorder = Color(0xFFB8C4A8);

  static const darkBrown = Color(0xFF2A1F1A);   // bottom nav
  static const textDark = Color(0xFF3A2A1A);
  static const textMid = Color(0xFF5A4A3A);
  static const textLight = Color(0xFF9A8A7A);
  static const textMuted = Color(0xFFB0A098);

  static const navActive = Color(0xFFC8B89A);
  static const navInactive = Color(0xFF6A5A4A);
}

class AppTheme {
  static ThemeData get theme => ThemeData(
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.green,
      surface: AppColors.surface,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: InputBorder.none,
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF9A8A7A), width: 1.5),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.green, width: 1.5),
      ),
      hintStyle: TextStyle(color: Color(0xFFB0A098), fontSize: 13),
      isDense: true,
      contentPadding: EdgeInsets.symmetric(vertical: 6),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: AppColors.textDark, fontSize: 13),
    ),
  );
}
