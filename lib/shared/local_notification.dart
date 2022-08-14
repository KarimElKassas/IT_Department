import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification{
  static AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.', // description
      importance: Importance.high,
      playSound: true);

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  static Future<void> showNotification(RemoteMessage payload) async {

    var android = AndroidInitializationSettings('logo_rs');
    var initiallizationSettingsIOS = IOSInitializationSettings();
    var initialSetting = new InitializationSettings(android: android, iOS: initiallizationSettingsIOS);
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initialSetting);



    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'default_notification_channel_id',
        'Notification',
        channelDescription: 'All Notification is Here',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        icon: "logo_rs",
        playSound: true,
        sound: RawResourceAndroidNotificationSound("notification")
    );
    const iOSDetails = IOSNotificationDetails();
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidDetails, iOS: iOSDetails);

    await flutterLocalNotificationsPlugin.show(0, payload.notification!.title, payload.notification!.body, platformChannelSpecifics);
  }
  static void showLocalNotification() {

    flutterLocalNotificationsPlugin.show(
        0,
        "Testing",
        "How you doin ?",
        NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name, channelDescription: channel.description,
                importance: Importance.high,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher')));
  }

}