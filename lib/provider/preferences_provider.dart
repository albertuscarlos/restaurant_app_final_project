import 'package:flutter/material.dart';
import 'package:flutter_restaurant_app/data/preferences/preferences_helper.dart';

class PreferencesProvider extends ChangeNotifier {
  bool _isDailyReminderActive = false;
  bool get isDailyReminderActive => _isDailyReminderActive;

  SharedpreferencesHelper preferencesHelper;

  PreferencesProvider({
    required this.preferencesHelper,
  }) {
    _getDailyNewsPreferences();
  }

  void _getDailyNewsPreferences() async {
    _isDailyReminderActive = await preferencesHelper.isDailyReminderActive;
    notifyListeners();
  }

  void enableDailyNews(bool value) {
    preferencesHelper.setDailyReminder(value);
    _getDailyNewsPreferences();
  }
}
