import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:student_task_manager/Screens/AddEvent.dart';
import 'package:student_task_manager/Screens/EventScreen.dart';
import 'package:student_task_manager/Screens/Welcome_signup.dart';
import 'package:student_task_manager/Screens/profile.dart';
import 'package:student_task_manager/component/google_sign_in.dart';
import 'package:student_task_manager/Screens/profile.dart';

class HomeScreenStudent extends StatefulWidget {
  @override
  State<HomeScreenStudent> createState() => _HomeScreenStudentState();
}

class _HomeScreenStudentState extends State<HomeScreenStudent> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator());
              else if (snapshot.hasError)
                return Center(
                  child: Text("Something went wrong!"),
                );
              else if (snapshot.hasData) {
                return StudentScreen();
              } else
                return WelcomeScreenSignUp();
            }),
      );
}
