import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mayo_flutter_push_notifications/src/models.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
}

const pushChannels = {
  'notifications': AndroidNotificationChannel(
    'notifications',
    'Android channel for notifications',
    description: 'This channel is used for notifications.',
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

  final initializationSettings = InitializationSettings(
    android: AndroidInitializationSettings('ic_stat_app_icon'),
    iOS: DarwinInitializationSettings(),
  );

  final messagesLocalHistory = <FCMMessageReceived>[];

  Future<String?> getToken() async {
    return _firebaseMessaging.getToken();
  }

  Stream<FCMEvent> initNotifications() async* {
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (resp) async* {
        print('onDidReceiveNotificationResponse');
        print(resp);

        if (resp.payload != null) {
          yield FCMEvent(
            event: FCMMessageEvent.tapped,
            message: _processPayload(resp),
          );

          messagesLocalHistory.add(_processPayload(resp));
        }
      },
      onDidReceiveBackgroundNotificationResponse: (resp) async* {
        print('onDidReceiveBackgroundNotificationResponse');
        print(resp);

        if (resp.payload != null) {
          yield FCMEvent(
            event: FCMMessageEvent.tapped,
            message: _processPayload(resp),
          );

          messagesLocalHistory.add(_processPayload(resp));
        }
      },
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(pushChannels['notifications']!);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Triggers when a message is received
    FirebaseMessaging.onMessage.listen((message) {
      print('onMessage');
      if (message.notification != null) {
        _displayLocalNotification(message);
        messagesLocalHistory.add(_processMessage(message));
      }
    });

    // Set the background messaging handler early on, as a named top-level function
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Also handle any interaction when the app is in the background via a
    FirebaseMessaging.onMessageOpenedApp.map((message) async* {
      print('onMessageOpenedApp');

      yield FCMEvent(
          event: FCMMessageEvent.oppenedApp, message: _processMessage(message));

      messagesLocalHistory.add(_processMessage(message));
    });

    // Get any messages which caused the application to open from
    // a terminated state.
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      print('initialMessage');

      log(
        'Handling a initial message ${initialMessage.messageId}',
        name: 'PushNotificationRepository',
      );

      yield FCMEvent(
        event: FCMMessageEvent.initialMessage,
        message: _processMessage(initialMessage),
      );
    }
  }

  // Display local notification
  void _displayLocalNotification(RemoteMessage message) {
    final notification = message.notification;
    final android = message.notification?.android;
    final apple = message.notification?.apple;

    final channel =
        pushChannels[android?.channelId] ?? pushChannels['notifications'];

    if (Platform.isAndroid && notification != null && android != null) {
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
    } else if (Platform.isIOS &&
        notification != null &&
        apple != null &&
        !messagesLocalHistory
            .any((element) => element.messageId == message.messageId)) {
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

  FCMMessageReceived _processMessage(
    RemoteMessage message,
  ) {
    print('processMessage');

    final data = Map<String, String>.from(message.data);

    return FCMMessageReceived(
      metadata: data,
      messageId: message.messageId,
    );
  }

  FCMMessageReceived _processPayload(NotificationResponse response) {
    print('processPayload');

    return FCMMessageReceived(
      metadata: convertPayload(response.payload!),
      messageId: response.actionId ?? '',
    );
  }

  Map<String, dynamic> convertPayload(String payload) {
    final String _payload = payload.substring(1, payload.length - 1);
    List<String> _split = [];
    _payload.split(",")..forEach((String s) => _split.addAll(s.split(":")));
    Map<String, dynamic> _mapped = {};
    for (int i = 0; i < _split.length + 1; i++) {
      if (i % 2 == 1)
        _mapped.addAll({_split[i - 1].trim().toString(): _split[i].trim()});
    }
    return _mapped;
  }

  Future<void> subscribeToTopic(String topic) async {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
  }
}
