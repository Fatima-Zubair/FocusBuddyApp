import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class TimerProvider extends ChangeNotifier {
  int xp = 0;
  int streak = 0;
  DateTime? lastSession;

  Future<void> loadStats() async {
    var box = await Hive.openBox('focusData');
    xp = box.get('xp', defaultValue: 0);
    streak = box.get('streak', defaultValue: 0);
    lastSession = box.get('lastSession');
    notifyListeners();
  }

  Future<void> completeSession() async {
    var box = await Hive.openBox('focusData');
    DateTime now = DateTime.now();
    bool isConsecutive = lastSession != null && now.difference(lastSession!).inDays == 1;

    xp += 10;
    streak = isConsecutive ? streak + 1 : 1;

    await box.put('xp', xp);
    await box.put('streak', streak);
    await box.put('lastSession', now);

    notifyListeners();
  }
}
