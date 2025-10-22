import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle heading = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 24,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.bold,
    letterSpacing: 0.5,
  );

  static const TextStyle subheading = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle body = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 16,
  );

  static const TextStyle timer = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 48,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle buttonText = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );
}