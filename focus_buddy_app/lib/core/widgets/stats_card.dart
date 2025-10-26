import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../providers/timer_provider.dart';

class StatsCard extends StatelessWidget {
  final TimerProvider timerProvider;
  final VoidCallback? onInfoPressed;

  const StatsCard({
    super.key,
    required this.timerProvider,
    this.onInfoPressed,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 360;

    // Reduced scale factors for smaller text
    final padding = screenWidth * 0.04; // Reduced padding
    final smallText = screenWidth * 0.025 + 6; // Reduced small text size
    final mediumText = screenWidth * 0.03 + 6; // Reduced medium text size
    final largeText = screenWidth * 0.035 + 6; // Reduced large text size
    final iconSize = screenWidth * 0.04 + 10; // Reduced icon size

    // Safely calculate progress percentage
    double progressPercentage = 0.0;
    try {
      progressPercentage = timerProvider.getProgressPercentage().clamp(0.0, 1.0);
    } catch (e) {
      debugPrint('Error calculating progress: $e');
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardLight, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Prevent overflow
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'YOUR STATS',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: smallText,
                  letterSpacing: 1.2,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.02, // Reduced padding
                  vertical: screenHeight * 0.004, // Reduced padding
                ),
                decoration: BoxDecoration(
                  color: AppColors.neonYellow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'LVL ${timerProvider.getCurrentLevel()}',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.darkBackground,
                    fontWeight: FontWeight.bold,
                    fontSize: smallText,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.015), // Reduced spacing

          // XP Progress
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'XP PROGRESS',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: smallText,
                      letterSpacing: 1.0,
                    ),
                  ),
                  Text(
                    '${timerProvider.getCurrentLevelXP()}/${timerProvider.getXPForNextLevel()}',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.neonYellow,
                      fontWeight: FontWeight.bold,
                      fontSize: mediumText,
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.008), // Reduced spacing

              // Replaced FractionallySizedBox with LinearProgressIndicator
              Container(
                height: screenHeight * 0.012, // Reduced height
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.cardLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progressPercentage,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.neonYellow),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.02), // Reduced spacing

          // Streak & Total XP
          IntrinsicHeight( // Prevent overflow
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Streak
                Flexible( // Prevent overflow
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min, // Prevent overflow
                        children: [
                          Icon(Icons.local_fire_department,
                              color: Colors.orange[400], size: iconSize),
                          SizedBox(width: screenWidth * 0.01), // Reduced spacing
                          Flexible(
                            child: Text(
                              '${timerProvider.streak}',
                              style: AppTextStyles.heading.copyWith(
                                color: AppColors.textPrimary,
                                fontSize: largeText + 2, // Reduced size
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis, // Prevent overflow
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'STREAK',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: smallText - 1, // Reduced size
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),

                // Divider
                Container(
                  height: screenHeight * 0.04, // Reduced height
                  width: 1,
                  color: AppColors.cardLight,
                ),

                // Total XP
                Flexible( // Prevent overflow
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min, // Prevent overflow
                        children: [
                          Icon(Icons.star,
                              color: AppColors.neonYellow, size: iconSize),
                          SizedBox(width: screenWidth * 0.01), // Reduced spacing
                          Flexible(
                            child: Text(
                              '${timerProvider.xp}',
                              style: AppTextStyles.heading.copyWith(
                                color: AppColors.textPrimary,
                                fontSize: largeText + 2, // Reduced size
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis, // Prevent overflow
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'TOTAL XP',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: smallText - 1, // Reduced size
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}