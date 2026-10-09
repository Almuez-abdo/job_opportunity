import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const primary = Color(0xFF0F172A);
  static const primaryLight = Color(0xFF1E293B);
  static const accent = Color(0xFF2563EB);
  static const accent2 = Color(0xFF06B6D4);
  static const bg = Color(0xFFF8FAFC);
  static const card = Colors.white;
  static const text = Color(0xFF0F172A);
  static const textLight = Color(0xFF64748B);
  static const border = Color(0xFFE2E8F0);
  static const muted = Color(0xFFF1F5F9);
  static const success = Color(0xFF10B981);
  static const warning = Color(0xFFF59E0B);
  static const danger = Color(0xFFEF4444);
}

ThemeData appTheme() {
  final base = ThemeData(useMaterial3: true, scaffoldBackgroundColor: AppColors.bg, colorScheme: ColorScheme.fromSeed(seedColor: AppColors.accent, primary: AppColors.accent));
  return base.copyWith(
    textTheme: GoogleFonts.tajawalTextTheme(base.textTheme),
    appBarTheme: const AppBarTheme(backgroundColor: Colors.white, elevation: 0, centerTitle: true, titleTextStyle: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 18)),
    cardTheme: CardThemeData(color: Colors.white, elevation: 2, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: AppColors.border))),
  );
}
