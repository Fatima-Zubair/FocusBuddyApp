import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../../core/constants/app_colors.dart';
import '../services/focus_timer_service.dart';
import '../core/widgets/timer_circle.dart';
import '../core/widgets/timer_controls.dart';
import '../core/widgets/sound_selection_modal.dart';
import '../core/widgets/session_complete_dialog.dart';

class FocusTimerScreen extends StatefulWidget {
  const FocusTimerScreen({super.key});

  @override
  State<FocusTimerScreen> createState() => _FocusTimerScreenState();
}

class _FocusTimerScreenState extends State<FocusTimerScreen> with TickerProviderStateMixin {
  static const int focusDuration = 1 * 60; // 1 minute for testing
  int remainingSeconds = focusDuration;
  Timer? timer;
  bool isRunning = false;
  bool isPaused = false;

  final AudioPlayer _player = AudioPlayer();
  String selectedSound = 'rainsound.mp3';
  final List<String> sounds = ['nature.mp3', 'rainsound.mp3', 'water.mp3'];

  final FocusTimerService _timerService = FocusTimerService();

  // Animation controllers
  late AnimationController _glowController;
  late AnimationController _progressController;
  late AnimationController _buttonController;
  late Animation<double> _glowAnimation;
  late Animation<double> _progressAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _timerService.init();

    // Initialize animation controllers - SLOWED DOWN
    _glowController = AnimationController(
      duration: const Duration(seconds: 4), // Changed from 2 to 4 seconds
      vsync: this,
    )..repeat(reverse: true);

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1000), // Increased from 800ms
      vsync: this,
    );

    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 200), // Slightly increased
      vsync: this,
    );

    // Define animations
    _glowAnimation = Tween<double>(begin: 0.9, end: 1.1).animate( // Reduced range for subtler effect
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeOut),
    );
  }

  void startTimer() async {
    if (isRunning) return;

    timer?.cancel();

    setState(() {
      isRunning = true;
      isPaused = false;
    });

    // Start progress animation
    _progressController.forward(from: 0.0);

    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (!mounted) return;
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        completeSession();
      }
    });

    try {
      if (_player.audioSource == null) {
        await _player.setAsset('assets/sounds/$selectedSound');
        await _player.setLoopMode(LoopMode.one);
      }
      if (!_player.playing) await _player.play();
    } catch (e) {
      debugPrint("Audio error: $e");
    }
  }

  void pauseTimer() {
    if (!isRunning) return;
    timer?.cancel();
    _player.pause();
    _progressController.stop();
    setState(() {
      isRunning = false;
      isPaused = true;
    });
  }

  void resumeTimer() async {
    if (isRunning || !isPaused) return;

    timer?.cancel();

    setState(() {
      isRunning = true;
      isPaused = false;
    });

    // Resume progress animation
    _progressController.forward();

    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (!mounted) return;
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        completeSession();
      }
    });

    await _player.play();
  }

  void resetTimer() {
    timer?.cancel();
    _player.stop();
    _progressController.reset();
    setState(() {
      remainingSeconds = focusDuration;
      isRunning = false;
      isPaused = false;
    });
  }

  Future<void> completeSession() async {
    timer?.cancel();
    await _player.stop();
    _progressController.reset();
    setState(() {
      isRunning = false;
      isPaused = false;
    });

    final result = await _timerService.saveSessionData();


    if (!mounted) return;

    SessionCompleteDialog.show(
      context: context,
      xp: result['xp'],
      streak: result['streak'],
    );
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final sec = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  Future<void> selectSound() async {
    final selected = await SoundSelectionModal.show(
      context: context,
      sounds: sounds,
      selectedSound: selectedSound,
      player: _player,
      isRunning: isRunning,
      isPaused: isPaused,
    );

    if (!mounted) return;

    if (selected != null && selected != selectedSound) {
      setState(() {
        selectedSound = selected;
      });

      await _player.setAsset('assets/sounds/$selectedSound');
      await _player.setLoopMode(LoopMode.one);
    }

    if (isRunning) {
      await _player.play();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    _player.dispose();
    _glowController.dispose();
    _progressController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress = 1 - (remainingSeconds / focusDuration);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        title: const Text(
          "Focus Session",
          style: TextStyle(color: AppColors.textPrimary),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.music_note,
              color: AppColors.textPrimary
            ),
            onPressed: (isRunning || isPaused) ? selectSound : null,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TimerCircle(
              progress: progress,
              timeText: formatTime(remainingSeconds),
              isRunning: isRunning,
              glowAnimation: _glowAnimation,
            ),
            const SizedBox(height: 55),
            TimerControls(
              isRunning: isRunning,
              isPaused: isPaused,
              onStartPause: isRunning ? pauseTimer : (isPaused ? resumeTimer : startTimer),
              onReset: resetTimer,
            ),
          ],
        ),
      ),
    );
  }
}