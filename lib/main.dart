import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/controllers/firestore_controller.dart';
import 'package:todo_app/helpers/ads_helper.dart';
import 'package:todo_app/helpers/auth_helper.dart';
import 'package:todo_app/helpers/notification_helper.dart';
import 'package:todo_app/views/screens/detail_page.dart';
import 'package:todo_app/views/screens/home_page.dart';
import 'package:todo_app/views/screens/login_screen.dart';
import 'package:todo_app/views/screens/new_task_page.dart';
import 'package:todo_app/views/screens/signup_screen.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final flutterLocalNotificationsPlugin =
      NotificationHelper.notificationHelper.flutterLocalNotificationsPlugin;

  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();

  const initializationAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final initializationIos = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
    onDidReceiveLocalNotification:
        (int? id, String? title, String? body, String? payload) async {},
  );

  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationAndroid, iOS: initializationIos);

  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: (response) async {
    String? payload = response.payload;

    if (response.payload != null) {
      log("Notification Payload : $payload");
    }
  });

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await AdHelper.adHelper.loadBannerAd();

  runApp(
    ChangeNotifierProvider(
      create: (context) => FireStoreController(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      initialRoute:
          Auth.auth.firebaseAuth.currentUser != null ? 'home_page' : '/',
      routes: {
        '/': (context) => LoginPage(),
        'signup_screen': (context) => SignUpPage(),
        'home_page': (context) => HomePage(),
        'new_task_page': (context) => NewTaskPage(),
        'detail_page': (context) => DetailPage(),
      },
    );
  }
}
