import 'package:flutter/material.dart';
import 'package:student_task_manager/Screens/Home.dart';
import 'package:student_task_manager/Screens/home_screen_teacher.dart';
import 'package:student_task_manager/Screens/profile.dart';

import '../component/RoundedButton.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String isSelected = "";

class CommonWelcome extends StatefulWidget {
  @override
  State<CommonWelcome> createState() => _CommonWelcomeState();
}

class _CommonWelcomeState extends State<CommonWelcome> {
  var _selectedPage;

  @override
  void initState() {
    _loadSelectedPage();
    super.initState();
  }

  _loadSelectedPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedPage = prefs.getString("selected_page");
    });
  }

  _saveSelectedPage(String page) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("selected_page", page);
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedPage == null) {
      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RoundedButton(
              text: "Teacher",
              press: () {
                _saveSelectedPage("teacher");
                setState(() {
                  _selectedPage = "teacher";
                });
              },
            ),
            SizedBox(
              height: 20,
            ),
            RoundedButton(
              text: "Student",
              press: () async {
                _saveSelectedPage("student");
                setState(() {
                  _selectedPage = "student";
                });
              },
            ),
          ],
        ),
      );
    } else if (_selectedPage == "teacher") {
      return HomeScreenTeacher();
    } else {
      return HomeScreenStudent();
    }
  }
}

