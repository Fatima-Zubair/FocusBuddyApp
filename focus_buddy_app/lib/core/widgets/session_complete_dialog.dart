import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class SessionCompleteDialog {
  static Future<void> show({
    required BuildContext context,
    required int xp,
    required int streak,
  }) async {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.7),
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (ctx, anim1, anim2) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        title: const Text(
          "Session Complete!",
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(
          "🎉 You earned +10 XP\nStreak: $streak days",
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushNamed(context, '/break');
            },
            child: const Text("Take Break"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushNamed(context, '/breathing');
            },
            child: const Text("Breathing Session"),
          ),
        ],
      ),
      transitionBuilder: (ctx, anim1, anim2, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: anim1,
            curve: Curves.elasticOut,
          ),
          child: child,
        );
      },
    );
  }
}