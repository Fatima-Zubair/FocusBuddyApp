import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class TimerProvider extends ChangeNotifier {
  static const int xpPerSession = 10; // Public constant for XP per session
  int xp = 0;
  int streak = 0;
  DateTime? lastSession;
  late Box _box; // Store the Hive box reference

  // Constants for level progression
  static const int baseXP = 100;  // XP needed for level 1
  static const int xpIncrement = 50;  // Additional XP needed per level

  // Initialize the provider and load data
  Future<void> initializeUser() async {
    // Open the box if not already opened
    _box = await Hive.openBox('focusData');

    // Check if it's a new user
    bool isNewUser = _box.get('isNewUser', defaultValue: true);

    if (isNewUser) {
      // Reset for new user
      xp = 0;
      streak = 0;
      lastSession = null;

      // Save initial state
      await _box.put('isNewUser', false);
      await _box.put('xp', 0);
      await _box.put('streak', 0);
      await _box.put('lastSession', null);
    } else {
      // Load existing data
      xp = _box.get('xp', defaultValue: 0);
      streak = _box.get('streak', defaultValue: 0);
      lastSession = _box.get('lastSession');
    }

    notifyListeners();
  }

  Future<void> loadStats() async {
    // Ensure the box is open
    if (!Hive.isBoxOpen('focusData')) {
      _box = await Hive.openBox('focusData');
    }

    xp = _box.get('xp', defaultValue: 0);
    streak = _box.get('streak', defaultValue: 0);
    lastSession = _box.get('lastSession');
    notifyListeners();
  }

  Future<void> completeSession() async {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    if (lastSession == null) {
      // First session ever
      streak = 1;
    } else {
      DateTime last = DateTime(lastSession!.year, lastSession!.month, lastSession!.day);
      int diffDays = today.difference(last).inDays;

      if (diffDays == 1) {
        // Consecutive day → increment streak
        streak += 1;
      } else if (diffDays == 0) {
        // Already did a session today → DO NOT increment streak
        // streak remains the same
      } else {
        // Missed 1+ day → reset streak
        streak = 1;
      }
    }

    // Add XP
    xp += xpPerSession;

    // Save updated values
    await _box.put('xp', xp);
    await _box.put('streak', streak);
    await _box.put('lastSession', now);

    lastSession = now; // update in memory
    notifyListeners();
  }

  // Calculate current level based on XP
  int getCurrentLevel() {
    if (xp <= 0) return 1; // Ensure minimum level is 1

    // Calculate level: each level requires baseXP + (level-1)*xpIncrement
    // For level 1: 0-99 XP
    // For level 2: 100-149 XP
    // For level 3: 150-199 XP, etc.
    int level = 1;
    int xpRequired = baseXP;

    while (xp >= xpRequired) {
      level++;
      xpRequired += xpIncrement;
    }

    return level;
  }

  // Calculate XP needed for next level
  int getXPForNextLevel() {
    int currentLevel = getCurrentLevel();

    // XP needed for next level is baseXP + (currentLevel-1)*xpIncrement
    return baseXP + (currentLevel - 1) * xpIncrement;
  }

  // Calculate current XP progress in current level
  int getCurrentLevelXP() {
    int currentLevel = getCurrentLevel();

    if (currentLevel == 1) {
      return xp; // For level 1, return all XP
    }

    // Calculate the XP threshold for the current level
    int currentLevelThreshold = baseXP + (currentLevel - 2) * xpIncrement;

    // Return XP earned in current level
    return xp - currentLevelThreshold;
  }

  // Calculate progress percentage for progress bar
  double getProgressPercentage() {
    final int currentLevelXP = getCurrentLevelXP();
    final int xpForNextLevel = getXPForNextLevel();

    // Calculate the XP needed for the next level from the current level
    int xpNeededForNextLevel;
    if (getCurrentLevel() == 1) {
      // For level 1, need baseXP to reach level 2
      xpNeededForNextLevel = baseXP;
    } else {
      // For other levels, need xpIncrement to reach next level
      xpNeededForNextLevel = xpIncrement;
    }

    // Prevent division by zero
    if (xpNeededForNextLevel <= 0) return 0.0;

    // Calculate progress
    final double progress = currentLevelXP / xpNeededForNextLevel;

    // Prevent NaN, negative, or >1.0 values
    if (progress.isNaN || progress.isInfinite) return 0.0;

    return progress.clamp(0.0, 1.0);
  }

  // Method to reset user data (for testing or user request)
  Future<void> resetUserData() async {
    xp = 0;
    streak = 0;
    lastSession = null;

    await _box.put('xp', 0);
    await _box.put('streak', 0);
    await _box.put('lastSession', null);

    notifyListeners();
  }
}