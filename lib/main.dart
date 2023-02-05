import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:student_task_manager/Screens/common_welcome.dart';
import 'package:student_task_manager/Screens/event_screen_teacher.dart';
import 'package:student_task_manager/component/google_sign_in.dart';
import 'package:student_task_manager/constant.dart';
import 'package:student_task_manager/Screens/EventScreen.dart';
import 'package:student_task_manager/Screens/Home.dart';
import 'package:student_task_manager/Screens/AddEvent.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:student_task_manager/nyapp.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  // firebaseMessaging.requestNotificationPermissions();
  // firebaseMessaging.configure();
  // await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

int count = 0;

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: MaterialApp(
          theme: ThemeData.light(),
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {
            '/': (context) => CommonWelcome(),
            '/event': (context) => EventScreen(),
            '/eventte': (context) => EventScreenTeacher(),
            '/addEvent': (context) => AddEvent(),
            'text': (context) => MyApp()
          },
        ),
      );
}
