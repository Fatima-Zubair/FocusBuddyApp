import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../core/widgets/reusable_complete_dialog.dart'; // adjust path if needed

class BreathingScreen extends StatefulWidget {
  const BreathingScreen({Key? key}) : super(key: key);

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen> {
  double _scale = 1.0;
  String _instruction = "Get Ready...";
  int _elapsed = 0;
  final int _sessionDuration = 60; // seconds
  Timer? _timer;
  Timer? _phaseTimer;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), _startBreathingCycle);
  }

  void _startBreathingCycle() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _elapsed++);
      if (_elapsed >= _sessionDuration) {
        _timer?.cancel();
        _phaseTimer?.cancel();
        _showCompletionDialog();
      }
    });

    _nextPhase();
  }

  void _nextPhase() {
    const inhale = Duration(seconds: 4);
    const hold = Duration(seconds: 2);
    const exhale = Duration(seconds: 4);

    // 🌬 Inhale phase
    setState(() {
      _instruction = "Inhale…";
      _scale = 1.4; // expand
    });

    _phaseTimer = Timer(inhale, () {
      setState(() => _instruction = "Hold…");

      _phaseTimer = Timer(hold, () {
        setState(() {
          _instruction = "Exhale…";
          _scale = 1.0; // contract
        });

        _phaseTimer = Timer(exhale, _nextPhase);
      });
    });
  }

  Future<void> _showCompletionDialog() async {
    await ReusableCompleteDialog.show(
      context: context,
      title: "Breathing Complete 🌿",
      subtitle: "You’re calm and ready to focus again.",
      icon: Icons.self_improvement,
      iconColor: AppColors.neonYellow,
      primaryButtonText: "Start Next Session",
      onPrimaryPressed: () => Navigator.pushReplacementNamed(context, '/focusTimer'),
      secondaryButtonText: "Back to Home",
      onSecondaryPressed: () => Navigator.pushReplacementNamed(context, '/home'),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _phaseTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        title: const Text(
          "Breathing Session",
          style: TextStyle(color: AppColors.textPrimary),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.darkBackground, AppColors.cardDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🧘 Breathing Image that scales with breathing phases
              AnimatedScale(
                scale: _scale,
                duration: const Duration(seconds: 4),
                curve: Curves.easeInOut,
                child: Image.asset(
                  'assets/images/breathing_img.png', // 👈 your breathing image path
                  height: 180,
                  width: 180,
                  color: AppColors.neonYellow.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 40),

              // 🌬 Instruction Text
              AnimatedOpacity(
                opacity: 1.0,
                duration: const Duration(milliseconds: 600),
                child: Text(
                  _instruction,
                  style: const TextStyle(
                    color: AppColors.neonYellow,
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ⏱ Remaining Time
              Text(
                "${(_sessionDuration - _elapsed).clamp(0, _sessionDuration)}s left",
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
