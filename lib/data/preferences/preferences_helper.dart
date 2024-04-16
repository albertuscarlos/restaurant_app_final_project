import 'package:shared_preferences/shared_preferences.dart';

class SharedpreferencesHelper {
  final Future<SharedPreferences> sharedPreferences;
  static const dailyReminder = 'DAILY_REMINDER';

  SharedpreferencesHelper({required this.sharedPreferences});

  Future<bool> get isDailyReminderActive async {
    final prefs = await sharedPreferences;
    return prefs.getBool(dailyReminder) ?? false;
  }

  void setDailyReminder(bool value) async {
    final prefs = await sharedPreferences;
    prefs.setBool(dailyReminder, value);
  }
}
