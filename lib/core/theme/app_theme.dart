import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    scaffoldBackgroundColor: AppColors.background,

    textTheme: GoogleFonts.interTextTheme(),

    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryBlue),

    cardTheme: CardThemeData(
      color: AppColors.card,

      elevation: 2,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,

      fillColor: Colors.white,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),

        borderSide: BorderSide(color: AppColors.border),
      ),
    ),
  );
}
