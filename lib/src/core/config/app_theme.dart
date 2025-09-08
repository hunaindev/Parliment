// lib/src/core/config/app_theme.dart

import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Museo-Bold',
      primaryColor: AppColors.primaryLightGreen,
      scaffoldBackgroundColor: const Color.fromARGB(255, 246, 247, 252),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.oliveGreen,
        titleTextStyle: TextStyle(color: AppColors.lightTeal, fontSize: 20),
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: AppColors.lightTeal),
        titleLarge: TextStyle(color: AppColors.darkBrown),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.primaryLightGreen,
        selectionColor: AppColors.primaryLightGreen.withOpacity(0.3),
        selectionHandleColor: AppColors.primaryLightGreen,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryLightGreen,
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            fontFamily: 'Museo-Bold',
          ),
          overlayColor: AppColors.primaryLightGreen.withOpacity(0.1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryLightGreen,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.primaryLightGreen.withOpacity(0.5),
          disabledForegroundColor: Colors.white.withOpacity(0.5),
          overlayColor: AppColors.primaryLightGreen.withOpacity(0.2),
        ),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: AppColors.primaryLightGreen,
      ),
    );
  }
}
