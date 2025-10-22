import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';



ThemeData buildAppTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    fontFamily: 'Poppins',
    textTheme: const TextTheme(
      headlineMedium: AppTextStyles.heading,
      bodyMedium: AppTextStyles.body,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.neonYellow,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        textStyle: AppTextStyles.buttonText,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.cardDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      elevation: 4,
    ),
  );
}
