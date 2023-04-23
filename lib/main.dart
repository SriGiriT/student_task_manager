import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:student_task_manager/Screens/attendance_screen.dart';
import 'package:student_task_manager/Screens/common_welcome.dart';
import 'package:student_task_manager/Screens/event_screen_teacher.dart';
import 'package:student_task_manager/Screens/home_screen_teacher.dart';
import 'package:student_task_manager/component/google_sign_in.dart';
import 'package:student_task_manager/constant.dart';
import 'package:student_task_manager/Screens/EventScreen.dart';
import 'package:student_task_manager/Screens/Home.dart';
import 'package:student_task_manager/Screens/AddEvent.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:student_task_manager/nyapp.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'Screens/test.dart';

const AndroidNotificationChannel channel =
    AndroidNotificationChannel('high_importance_channel', 'High Importance',
        // 'This channel is used for important notifications.',
        importance: Importance.high,
        playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up : ${message.messageId}');
  showFlutterNotification(message);
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  // AttendancePage();

  if (notification != null && android != null && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          // TODO add a proper drawable resource to android, for now using
          //      one that already exists in example app.
          icon: 'launch_background',
        ),
      ),
    );
  }
}
// class MyHttpOverrides extends HttpOverrides{
//   @override
//   HttpClient createHttpClient(SecurityContext? context){
//     return super.createHttpClient(context)
//       ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
//   }
// }
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // HttpOverrides.global = MyHttpOverrides();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
  String? token = await FirebaseMessaging.instance.getToken();
  // print(token);
  to = token!;
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _token;
  String? initialMessage;
  bool _resolved = false;
  @override
  void initState() {
    super.initState();

    FirebaseMessaging.instance.getInitialMessage().then(
          (value) => setState(
            () {
              _resolved = true;
              initialMessage = value?.data.toString();
              Navigator.pushNamed(context, '/attendance');
            },
          ),
        );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      // AttendancePage();

      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ),
        );
      }
      Navigator.pushNamed(context, '/attendance');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      Navigator.pushNamed(
        context,
        '/attendance',
        // arguments: MessageArguments(message, true),
      );
    });
  }

  // @override
  // void initState(){
  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //   print('A new onMessageOpenedApp event was published!');
  //   RemoteNotification notification = message.notification!;
  //   AndroidNotification android = message.notification!.android!;
  //   if (notification != null && android != null) {
  //     showDialog(
  //         context: context,
  //         builder: (_) {
  //           return AlertDialog(
  //             title: Text(notification.title!),
  //             content: SingleChildScrollView(
  //                 child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [Text(notification.body!)],
  //             )),
  //           );
  //         });
  //   }
  // });
  // }
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: MaterialApp(
          theme: ThemeData(primarySwatch: kMatColor),
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {
            '/':(context) => CommonWelcome(),
            '/timeTable': (context) => StaffTimetable(timetable: {
    "id": 24,
    "staff": {
      "staffId": "sugankpms",
      "name": "sugankpms",
      "mail": "sugankpms@gmail.com",
      "mobile": "8477822052",
      "classCode": "CSE",
      "present": false,
      "presentKt": false
    },
    "dayOne": [
      "'Free",
      "Free",
      "JAVA",
      "Free",
      "Free",
      "Free",
      "Free'"
    ],
    "dayTwo": [
      "'Free",
      "Free",
      "Free",
      "Free",
      "Free",
      "Free",
      "Free'"
    ],
    "dayThree": [
      "'Free",
      "Free",
      "Free",
      "Free",
      "Free",
      "Free",
      "Free'"
    ],
    "dayFour": [
      "'Free",
      "Free",
      "Free",
      "Free",
      "Free",
      "Free",
      "Free'"
    ],
    "dayFive": [
      "'Free",
      "Free",
      "Free",
      "Free",
      "Free",
      "Free",
      "PCD'"
    ]
  },),
            '/event': (context) => EventScreen(),
            '/eventte': (context) => EventScreenTeacher(),
            '/tescreen': (context) => HomeScreenTeacher(),
            '/stscreen': (context) => HomeScreenStudent(),
            '/addEvent': (context) => AddEvent(),
            'text': (context) => MyApp(),
            '/attendance': (context) => AttendancePage()
          },
        ),
      );
}
