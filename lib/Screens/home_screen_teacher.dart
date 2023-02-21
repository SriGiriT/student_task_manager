import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:student_task_manager/Screens/AddEvent.dart';
import 'package:student_task_manager/Screens/EventScreen.dart';
import 'package:student_task_manager/Screens/Welcome_signup.dart';
import 'package:student_task_manager/Screens/event_screen_teacher.dart';
import 'package:student_task_manager/Screens/profile.dart';
import 'package:student_task_manager/component/google_sign_in.dart';
import 'package:student_task_manager/Screens/profile.dart';

//import 'package:flutter_svg/svg.dart';

class HomeScreenTeacher extends StatefulWidget {
  @override
  State<HomeScreenTeacher> createState() => _HomeScreenTeacherState();
}

class _HomeScreenTeacherState extends State<HomeScreenTeacher> {
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
                return TeacherScreen();
              } else
                return WelcomeScreenSignUp();
            }),
      );
}
