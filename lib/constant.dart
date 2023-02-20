import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_sign_in/google_sign_in.dart';

String kURL = "https://tidy-puma-7.telebit.io";
const kPrimaryColor = Color(0xFF1D1E33);
const kPrimaryLightColor = Color(0xFF282E45);
const kButtonColor = Color(0xFF111328);
const kSaveKey = "selected_page111111111";
TextStyle kButtonTextStyle =
    TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold);
Future<bool> onBackPressed(BuildContext context, String text) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(text),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text("No"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text("Yes"),
        ),
      ],
    ),
  ).then((value) => value ?? false);
}

class Description extends StatefulWidget {
  final String descriptionData;
  const Description({required this.descriptionData});

  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Container(child: Text(widget.descriptionData)));
  }
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance',
    'This channel is used for important notifications.',
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up : ${message.messageId}');
}

String to = "";

MaterialColor kMatColor = MaterialColor(
              0xFF1D1E33,
              <int, Color>{
                50: Color(0xFF1D1E33),
                100: Color(0xFF1D1E33),
                200: Color(0xFF1D1E33),
                300: Color(0xFF1D1E33),
                400: Color(0xFF1D1E33),
                500: Color(0xFF1D1E33),
                600: Color(0xFF1D1E33),
                700: Color(0xFF1D1E33),
                800: Color(0xFF1D1E33),
                900: Color(0xFF1D1E33),
              },
            );