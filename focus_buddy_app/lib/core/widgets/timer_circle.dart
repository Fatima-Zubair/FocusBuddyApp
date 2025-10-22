import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class TimerCircle extends StatelessWidget {
  final double progress;
  final String timeText;
  final bool isRunning;
  final Animation<double> glowAnimation;

  const TimerCircle({
    super.key,
    required this.progress,
    required this.timeText,
    required this.isRunning,
    required this.glowAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: glowAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: isRunning ? glowAnimation.value : 1.0,
          child: Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: isRunning
                      ? AppColors.neonPurple.withOpacity(0.6)
                      : AppColors.neonBlue.withOpacity(0.2),
                  blurRadius: isRunning ? 25 * glowAnimation.value : 10,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Progress ring
                SizedBox(
                  width: 220,
                  height: 220,
                  child: AnimatedBuilder(
                    animation: glowAnimation,
                    builder: (context, child) {
                      return CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 12,
                        backgroundColor: AppColors.cardLight.withOpacity(0.3),
                        valueColor: const AlwaysStoppedAnimation(AppColors.neonPurple),
                      );
                    },
                  ),
                ),
                // Timer text
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  child: Text(
                    timeText,
                    key: ValueKey<String>(timeText),
                    style: AppTextStyles.timer.copyWith(
                      color: AppColors.neonYellow,
                      fontSize: 46,
                      shadows: [
                        Shadow(
                          color: AppColors.neonYellow.withOpacity(0.8),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}