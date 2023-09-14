import 'dart:developer';

import 'package:example/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mayo_flutter_push_notifications/mayo_flutter_push_notifications.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final pushNotificationsRepository = PushNotificationRepository();

  await pushNotificationsRepository.initNotifications();
  runApp(MyApp(
    pushNotificationsRepository: pushNotificationsRepository,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.pushNotificationsRepository});

  final PushNotificationRepository pushNotificationsRepository;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mayo example app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(
          title: 'Mayo example app',
          pushNotificationsRepository: pushNotificationsRepository),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {super.key,
      required this.title,
      required this.pushNotificationsRepository});

  final String title;
  final PushNotificationRepository pushNotificationsRepository;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var token = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
                child: const Text(
                  'Get FCM token',
                ),
                onPressed: () async => await widget.pushNotificationsRepository
                        .getToken()
                        .then((value) {
                      print('token: $value');

                      setState(() => token = value ?? '');
                    })),
            Text(
              token,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}
