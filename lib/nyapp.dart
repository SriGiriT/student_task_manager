// // Import the firebase_messaging package
// import 'package:firebase_messaging/firebase_messaging.dart';

// import 'package:flutter/material.dart';
// class MyNotificationHandler {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

//   void init() {
//     _firebaseMessaging.configure(
//       onMessage: (Map<String, dynamic> message) async {
//         print("onMessage: $message");
//         // Show the notification to the user
//       },
//       onLaunch: (Map<String, dynamic> message) async {
//         print("onLaunch: $message");
//         // Navigate to the desired page when the app is launched from the notification
//       },
//       onResume: (Map<String, dynamic> message) async {
//         print("onResume: $message");
//         // Navigate to the desired page when the app is resumed from the notification
//       },
//     );
//   }
// }
