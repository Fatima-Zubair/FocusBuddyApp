import 'dart:async';
import 'package:hive/hive.dart';

class FocusTimerService {
  late Box box;

  Future<void> init() async {
    box = await Hive.openBox('focusData');
  }

  Future<Map<String, dynamic>> saveSessionData() async {
    int xp = box.get('xp', defaultValue: 0);
    int streak = box.get('streak', defaultValue: 0);
    DateTime? lastSession = box.get('lastSession');
    DateTime now = DateTime.now();

    bool isConsecutive =
        lastSession != null && now.difference(lastSession).inDays == 1;

    xp += 10;
    streak = isConsecutive ? streak + 1 : 1;

    await box.put('xp', xp);
    await box.put('streak', streak);
    await box.put('lastSession', now);

    return {'xp': xp, 'streak': streak};
  }

  int get xp => box.get('xp', defaultValue: 0);
  int get streak => box.get('streak', defaultValue: 0);
}