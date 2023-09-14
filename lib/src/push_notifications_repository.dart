import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
}

Future<void> _firebaseMessagingBackgroundHandler2(
    NotificationResponse message) async {
  print('Handling a background message ${message.id}');
}

const pushChannels = {
  'notifications': AndroidNotificationChannel(
      'notifications', // id
      'Android channel for notifications', // title
      description: 'This channel is used for notifications.', // description
      importance: Importance.max,
      playSound: true,
      // sound: RawResourceAndroidNotificationSound('debug'),
      enableLights: true,
      enableVibration: true,
      showBadge: true),
  // 'debug': AndroidNotificationChannel(
  //     'debug', // id
  //     'Debug alerts from Ramos server', // title
  //     description: 'This channel is used for debug.', // description
  //     importance: Importance.max,
  //     playSound: true,
  //     sound: RawResourceAndroidNotificationSound('debug'),
  //     enableLights: true,
  //     enableVibration: true,
  //     showBadge: true),
  // 'warnings': AndroidNotificationChannel(
  //     'warnings', // id
  //     'Warning alerts from Ramos server', // title
  //     description: 'This channel is used for warnings.', // description
  //     importance: Importance.max,
  //     playSound: true,
  //     sound: RawResourceAndroidNotificationSound('warnings'),
  //     enableLights: true,
  //     enableVibration: true,
  //     showBadge: true),
  // 'errors': AndroidNotificationChannel(
  //     'errors', // id
  //     'Errors alerts from Ramos server', // title
  //     description: 'This channel is used for errors.', // description
  //     importance: Importance.max,
  //     playSound: true,
  //     sound: RawResourceAndroidNotificationSound('errors'),
  //     enableLights: true,
  //     enableVibration: true,
  //     showBadge: true)
};

class PushNotificationRepository {
  final FirebaseMessaging _firebaseMessaging;

  PushNotificationRepository({FirebaseMessaging? firebaseMessaging})
      : _firebaseMessaging = firebaseMessaging ?? FirebaseMessaging.instance;

  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }

  initNotifications() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    // One for each channel
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(pushChannels['notifications']!);

    // await flutterLocalNotificationsPlugin
    //     .resolvePlatformSpecificImplementation<
    //         AndroidFlutterLocalNotificationsPlugin>()
    //     ?.createNotificationChannel(pushChannels['warnings']!);
    // await flutterLocalNotificationsPlugin
    //     .resolvePlatformSpecificImplementation<
    //         AndroidFlutterLocalNotificationsPlugin>()
    //     ?.createNotificationChannel(pushChannels['errors']!);

    const initializationSettingsAndroid =
        AndroidInitializationSettings('ic_stat_app_icon');

    const initializationSettingsIOS = DarwinInitializationSettings();

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveBackgroundNotificationResponse:
            _firebaseMessagingBackgroundHandler2,
        onDidReceiveNotificationResponse: onSelectLocalNotification);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    // Set the background messaging handler early on, as a named top-level function
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((message) {
      print('onMessage: $message}');
      print(message.messageId);

      final notification = message.notification;
      final android = message.notification?.android;
      final apple = message.notification?.apple;

      if (notification != null && android != null) {}

      // Get the channel id for the notification
      final channel =
          pushChannels[android?.channelId] ?? pushChannels['notifications'];

      print('notification: $notification');
      print('android: $android');
      print('data: ${message.data}');

      if (notification != null && android != null) {
        print('local notification');
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(channel!.id, channel.name,
                  channelDescription: channel.description,
                  importance: Importance.max,
                  priority: Priority.high,
                  color: Colors.red,
                  playSound: true,
                  enableLights: true,
                  colorized: true,
                  // sound: RawResourceAndroidNotificationSound(
                  //     message.data['sound'] ?? 'debug'),
                  ticker: 'ticker'),
            ),
            payload: jsonEncode(message.data));
      } else if (notification != null && apple != null) {
        print('local notification');
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              iOS: DarwinNotificationDetails(
                presentAlert: true,
                presentBadge: true,
                presentSound: true,
              ),
            ),
            payload: jsonEncode(message.data));
      } else {
        print('no local notification');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _processMessage(message);
    });

    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      print('Handling a initial message ${initialMessage.messageId}');

      _processMessage(initialMessage);
    }
  }

  Future<void> onSelectLocalNotification(NotificationResponse? payload) async {
    print('onSelectLocalNotification');
    print(payload);

    final data = jsonDecode(payload!.payload!);
    // final type = data['notification_type'];
    // final alertId = data['alertId'] as String;

    // if (type == 'alert' && _ctx != null) {
    //   await _navigateToAlertScreen(alertId);
    // }
  }

  void _processMessage(RemoteMessage message) {
    print('processMessage');
    // final data = Map<String, String>.from(message.data);

    // final type = data['notification_type'];
    // final alertId = data['alertId'];

    // if (type == 'alert' && _ctx != null) {
    //   _navigateToAlertScreen(alertId);
    // }
  }

  subscribeToTopic(String topic) async {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
  }

  unsubscribeFromTopic(String topic) async {
    await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
  }
}
