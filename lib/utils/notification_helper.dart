import 'dart:convert';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_restaurant_app/common/navigation.dart';
import 'package:flutter_restaurant_app/data/models/restaurant.dart';
import 'package:rxdart/rxdart.dart';

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper {
  static NotificationHelper? _instance;

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = const DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse details) async {
      final payload = details.payload;
      if (payload != null) {
      } else {
        selectNotificationSubject.add(payload ?? 'Empty Payload');
      }
    });
  }

  Future<void> showNotification(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    RestaurantResponse restaurants,
  ) async {
    var channelId = '1';
    var channelName = 'channel_01';
    var channelDescription = 'restaurants channel';

    var androidPlatformSpecifics = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      icon: "app_icon",
      ticker: 'ticker',
      styleInformation: const DefaultStyleInformation(
        true,
        true,
      ),
    );

    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    var randomIndex = Random().nextInt(restaurants.restaurants!.length);

    var titleNotification = "<b>Recommended Restaurants</b>";
    var titleReminder = restaurants.restaurants![randomIndex].name;

    await flutterLocalNotificationsPlugin.show(
      0,
      titleNotification,
      titleReminder,
      platformChannelSpecifics,
      payload: jsonEncode(
        restaurants.toJson(),
      ),
    );
  }

  void configureSelectNotificationSubject(String route) {
    selectNotificationSubject.stream.listen((String payload) async {
      var data = RestaurantResponse.fromJson(json.decode(payload));
      var restaurant = data.restaurants![0];
      Navigation.intentWithData(route, restaurant);
    });
  }
}
