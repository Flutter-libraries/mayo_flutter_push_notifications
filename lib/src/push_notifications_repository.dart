import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushMessage {
  PushMessage({required this.page, required this.id});

  final String page;
  final String id;
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
}

Future<void> _firebaseMessagingBackgroundHandler2(
  NotificationResponse message,
) async {
  print('Handling a background message ${message.id}');
}

const pushChannels = {
  'notifications': AndroidNotificationChannel(
    'notifications', // id
    'Android channel for notifications', // title
    description: 'This channel is used for notifications.', // description
    importance: Importance.max,
    enableLights: true,
    playSound: true,
    showBadge: true,
    enableVibration: true,
  ),
};

class PushNotificationRepository {
  PushNotificationRepository({FirebaseMessaging? firebaseMessaging})
      : _firebaseMessaging = firebaseMessaging ?? FirebaseMessaging.instance;

  final FirebaseMessaging _firebaseMessaging;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<String?> getToken() async {
    return _firebaseMessaging.getToken();
  }

  Future<void> initNotifications() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(pushChannels['notifications']!);

    const initializationSettingsAndroid =
        AndroidInitializationSettings('ic_stat_app_icon');

    final initializationSettingsIOS = DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) {
        print('onDidReceiveLocalNotification');
        print(id);
        print(title);
        print(body);
        print(payload);
      },
    );

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse:
          _firebaseMessagingBackgroundHandler2,
      onDidReceiveNotificationResponse: (message) =>
          onSelectLocalNotification(message).then((value) async* {
        // yield PushNotificationData('onDidReceiveNotificationResponse',
        //     {'chatId': 'uknqZKrwHpnYReoSnoJR'});
      }),
    );

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await _firebaseMessaging.setForegroundNotificationPresentationOptions();

    // Set the background messaging handler early on, as a named top-level function
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Triggers when a message is received
    FirebaseMessaging.onMessage.listen((message) {
      print('onMessage');
      final pushMessage = _processMessage(message);
    });

    // Get any messages which caused the application to open from
    // a terminated state.
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      log(
        'Handling a initial message ${initialMessage.messageId}',
        name: 'PushNotificationRepository',
      );

      print('initialMessage');
      // yield _processMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.map((message) {
      log(
        'Handling a message opened app ${message.messageId}',
        name: 'PushNotificationRepository',
      );

      print('onMessageOpenedApp');
      return _processMessage(message);
    });
  }

  // Display local notification
  void _displayLocalNotification(RemoteMessage message) {
    final notification = message.notification;
    final android = message.notification?.android;
    final apple = message.notification?.apple;

    // Get the channel id for the notification
    print('Android channel id: ${android?.channelId}');

    final channel =
        pushChannels[android?.channelId] ?? pushChannels['notifications'];

    print('notification: $notification');
    print('android: $android');
    print('android: $apple');
    print('data: ${message.data}');

    if (notification != null && android != null) {
      print('android local notification');
      flutterLocalNotificationsPlugin.show(
        DateTime.now().microsecond,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel!.id, channel.name,
            channelDescription: channel.description,
            importance: Importance.max,
            priority: Priority.high,

            enableLights: true,
            colorized: true,
            // sound: RawResourceAndroidNotificationSound(
            //     message.data['sound'] ?? 'debug'),
            ticker: 'ticker',
          ),
        ),
        payload: jsonEncode(message.data),
      );
    } else if (notification != null && apple != null) {
      print('apple local notification');
      try {
        flutterLocalNotificationsPlugin.show(
          DateTime.now().microsecond,
          notification.title,
          notification.body,
          const NotificationDetails(
            iOS: DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
          payload: jsonEncode(message.data),
        );
      } catch (e) {
        print(e);
      }
    } else {
      print('no local notification');
    }
  }

  /// On tap notification
  Future<void> onSelectLocalNotification(NotificationResponse? payload) async {
    log('onDidReceiveNotificationResponse', name: 'PushNotificationRepository');
    print(payload);

    final data = jsonDecode(payload!.payload!);
    // final type = data['notification_type'];
    // final alertId = data['alertId'] as String;

    // if (type == 'alert' && _ctx != null) {
    //   await _navigateToAlertScreen(alertId);
    // }
  }

  PushMessage _processMessage(RemoteMessage message) {
    print('processMessage');

    final data = Map<String, String>.from(message.data);

    return PushMessage(
      page: data['page']!,
      id: data['chatId'] != null
          ? data['chatId']!
          : data['orderId'] != null
              ? data['orderId']!
              : '',
    );
  }

  Future<void> subscribeToTopic(String topic) async {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
  }
}
