import 'dart:io';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_restaurant_app/common/style.dart';
import 'package:flutter_restaurant_app/data/api/api_controller.dart';
import 'package:flutter_restaurant_app/data/db/database_helper.dart';
import 'package:flutter_restaurant_app/data/preferences/preferences_helper.dart';
import 'package:flutter_restaurant_app/provider/bottom_nav_provider.dart';
import 'package:flutter_restaurant_app/provider/database_provider.dart';
import 'package:flutter_restaurant_app/provider/preferences_provider.dart';
import 'package:flutter_restaurant_app/provider/restaurant_provider.dart';
import 'package:flutter_restaurant_app/provider/scheduling_provider.dart';
import 'package:flutter_restaurant_app/ui/home_page.dart';
import 'package:flutter_restaurant_app/ui/restaurant_detail_page.dart';
import 'package:flutter_restaurant_app/utils/background_service.dart';
import 'package:flutter_restaurant_app/utils/notification_helper.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationHelper notificationHelper = NotificationHelper();
  final BackgroundService service = BackgroundService();

  service.initializeIsolate();

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  } else {
    await notificationHelper.initNotification(flutterLocalNotificationsPlugin);
  }
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RestaurantProvider>(
          create: (context) => RestaurantProvider(
            apiService: ApiService(),
            httpClient: Client(),
          ),
        ),
        ChangeNotifierProvider<BottomNavProvider>(
          create: (context) => BottomNavProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SchedulingProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => DatabaseProvider(
            databaseHelper: DatabaseHelper(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => PreferencesProvider(
            preferencesHelper: SharedpreferencesHelper(
              sharedPreferences: SharedPreferences.getInstance(),
            ),
          ),
        ),
      ],
      child: GetMaterialApp(
        theme: ThemeData(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: primaryColor,
                onPrimary: Colors.black,
                secondary: secondaryColor,
              ),
          textTheme: myTextTheme,
          appBarTheme: const AppBarTheme(
            elevation: 0,
            centerTitle: true,
          ),
        ),
        initialRoute: HomePage.routeName,
        routes: {
          HomePage.routeName: (context) => HomePage(),
          RestaurantDetailPage.routeName: (context) => RestaurantDetailPage(
                id: ModalRoute.of(context)?.settings.arguments as String,
              ),
        },
      ),
    );
  }
}
