import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final Random _random = Random();
  late AnimationController _controller;
  late List<Offset> _sparkPositions;

  @override
  void initState() {
    super.initState();

    // Generate spark positions
    _sparkPositions = List.generate(
      12,
      (_) => Offset(_random.nextDouble(), _random.nextDouble()), 
      // index is not used so _
    );

    // Animate spark twinkle
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: true);


    // Navigate to Home after delay
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 🌟 Random Neon Sparks
          ..._sparkPositions.map(
            (pos) => AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                double opacity =
                    0.5 + 0.5 * sin(_controller.value * 2 * pi);
                return Positioned(
                  left: pos.dx * size.width,
                  top: pos.dy * size.height,
                  child: Opacity(
                    opacity: opacity,
                    child: Icon(
                      Icons.brightness_1,
                      color: [
                        AppColors.neonPurple,
                        AppColors.neonBlue,
                        AppColors.neonYellow
                      ][_random.nextInt(3)]
                          .withOpacity(0.8),
                      size: 5 + _random.nextDouble() * 6,
                    ),
                  ),
                );
              },
            ),
          ),

          // 🧠 Center Content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated GIF logo
                Image.asset(
                  'assets/images/yellow2.gif',
                  height: 140,
                ),
                const SizedBox(height: 20),

                // FocusBuddy text with neon glow
                Text(
                  "FocusBuddy",
                  style: AppTextStyles.heading.copyWith(
                    fontSize: 34,
                    color: AppColors.neonYellow,
                    shadows: [
                      Shadow(
                        blurRadius: 15,
                        color: AppColors.neonYellow.withOpacity(0.9),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Single tagline
                Text(
                  "Sharpen your focus. Build your streak.",
                  style: AppTextStyles.subheading.copyWith(
                    fontSize: 14,
                    color: AppColors.neonBlue,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
