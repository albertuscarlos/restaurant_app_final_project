import 'package:flutter/material.dart';
import 'package:flutter_restaurant_app/provider/preferences_provider.dart';
import 'package:flutter_restaurant_app/provider/scheduling_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<PreferencesProvider>(
        builder: (context, provider, child) {
          return ListView(
            children: [
              Material(
                child: ListTile(
                  title: const Text('Daily Notification'),
                  subtitle: const Text('Recommended Restaurant'),
                  trailing: Consumer<SchedulingProvider>(
                    builder: (context, scheduled, _) {
                      return Switch.adaptive(
                        value: provider.isDailyReminderActive,
                        onChanged: (value) async {
                          scheduled.scheduledNews(value);
                          provider.enableDailyNews(value);
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
