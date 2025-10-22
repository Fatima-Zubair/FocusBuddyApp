import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../../core/constants/app_colors.dart';

class SoundSelectionModal {
  static Future<String?> show({
    required BuildContext context,
    required List<String> sounds,
    required String selectedSound,
    required AudioPlayer player,
    required bool isRunning,
    required bool isPaused,
  }) async {
    if (!isRunning && !isPaused) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Start a session to change focus sound"),
          duration: Duration(seconds: 2),
        ),
      );
      return null;
    }

    final wasPlaying = player.playing;
    await player.pause();

    final selected = await showModalBottomSheet<String?>(
      backgroundColor: AppColors.cardDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Select Focus Sound",
              style: TextStyle(
                color: AppColors.neonYellow,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...sounds.map(
                  (sound) => ListTile(
                title: Text(
                  sound.replaceAll('.mp3', ''),
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
                trailing: sound == selectedSound
                    ? const Icon(Icons.check, color: AppColors.neonYellow)
                    : null,
                onTap: () {
                  Navigator.pop(ctx, sound);
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );

    return selected;
  }
}