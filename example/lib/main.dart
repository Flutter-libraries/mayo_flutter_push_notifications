import 'dart:developer';

import 'package:example/firebase_options.dart';
import 'package:example/second_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mayo_flutter_push_notifications/mayo_flutter_push_notifications.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final fcmCubit = FCMCubit();

  fcmCubit.init();

  runApp(MyApp(
    fcmCubit: fcmCubit,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.fcmCubit});

  final FCMCubit fcmCubit;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: fcmCubit,
      child: MaterialApp(
        title: 'Mayo example app',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: MyHomePage(
          title: 'Mayo example app',
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FCMCubit, FCMState>(
      listener: (context, state) async {
        log('FCM token: ${state.token}');
        if (state.event == FCMMessageEvent.tapped) {
          log('FCM message tapped notification');
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SecondPage(),
            ),
          );
        } else if (state.event == FCMMessageEvent.oppenedApp) {
          log('FCM message oppened app');
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            Future.delayed(const Duration(milliseconds: 1000), () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SecondPage(),
                ),
              );
            });
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(widget.title),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  child: const Text(
                    'Get FCM token',
                  ),
                  onPressed: () => context.read<FCMCubit>().getToken(),
                ),
                Text(
                  state.token.isEmpty
                      ? 'FCM token not available'
                      : 'FCM token: ${state.token}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
