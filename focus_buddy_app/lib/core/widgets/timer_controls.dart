import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class TimerControls extends StatelessWidget {
  final bool isRunning;
  final bool isPaused;
  final VoidCallback onStartPause;
  final VoidCallback onReset;

  const TimerControls({
    super.key,
    required this.isRunning,
    required this.isPaused,
    required this.onStartPause,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildAnimatedButton(
          icon: isRunning
              ? Icons.pause
              : (isPaused ? Icons.play_arrow : Icons.play_arrow),
          label: isRunning
              ? "Pause"
              : (isPaused ? "Resume" : "Start"),
          color: isRunning
              ? AppColors.btnPurpleFocus
              : AppColors.btnYellowFocus,
          onPressed: onStartPause,
        ),
        const SizedBox(width: 16),
        _buildAnimatedButton(
          icon: Icons.refresh,
          label: "Reset",
          color: AppColors.btnDisabled,
          onPressed: onReset,
        ),
      ],
    );
  }

  Widget _buildAnimatedButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: AppColors.textSecondary,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        elevation: 6,
        shadowColor: color.withOpacity(0.6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      icon: Icon(icon, size: 22),
      label: Text(label, style: AppTextStyles.buttonText),
      onPressed: onPressed,
    );
  }
}