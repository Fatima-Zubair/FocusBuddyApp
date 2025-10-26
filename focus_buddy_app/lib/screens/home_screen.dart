import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../providers/timer_provider.dart';
import '../../core/widgets/stats_card.dart';
import '../../core/widgets/session_card.dart';
import '../../core/widgets/quote_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<String> _quotes = [
    "Focus on the journey, not the destination.",
    "Small daily improvements lead to stunning results.",
    "Your mind is a powerful thing. Fill it with positive thoughts.",
    "The secret of getting ahead is getting started.",
    "Success is the sum of small efforts repeated day in and day out.",
    "Don't watch the clock; do what it does. Keep going.",
    "Believe you can and you're halfway there.",
    "The only way to do great work is to love what you do."
  ];

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        title: Text(
          'How Progress Works',
          style: AppTextStyles.heading.copyWith(color: AppColors.neonYellow),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('- XP: Earn XP after each focus session.', style: TextStyle(color: Colors.white),),
            Text('- Level: Gain levels as XP increases.', style: TextStyle(color: Colors.white),),
            Text('- Streak: Complete consecutive days to maintain streak.', style: TextStyle(color: Colors.white),),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Got it!',
              style: TextStyle(color: AppColors.neonYellow, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final randomQuote = _quotes[DateTime.now().second % _quotes.length];

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('FocusBuddy'),
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        titleTextStyle: AppTextStyles.heading.copyWith(
          color: AppColors.textPrimary,
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: AppColors.neonBlue),
            onPressed: () => _showInfoDialog(context),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Stats Card
            Consumer<TimerProvider>(
              builder: (context, timerProvider, child) {
                return SizedBox(
                  height: screenHeight * 0.25, // responsive height
                  child: StatsCard(timerProvider: timerProvider),
                );
              },
            ),
            SizedBox(height: screenHeight * 0.03),

            // Session Cards
            Row(
              children: [
                Expanded(
                  child: SessionCard(
                    title: 'Focus Timer',
                    icon: Icons.timer,
                    color: AppColors.neonYellow,
                    bgColor: AppColors.btnYellowFocus.withOpacity(0.15),
                    onTap: () => Navigator.pushNamed(context, '/focusTimer'),
                  ),
                ),
                SizedBox(width: screenWidth * 0.04),
                Expanded(
                  child: SessionCard(
                    title: 'Breathing Session',
                    icon: Icons.self_improvement,
                    color: AppColors.neonPurple,
                    bgColor: AppColors.btnPurpleFocus.withOpacity(0.15),
                    onTap: () => Navigator.pushNamed(context, '/breathing'),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.03),

            // Quote Card
            SizedBox(
              height: screenHeight * 0.18,
              child: QuoteCard(quote: randomQuote),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
