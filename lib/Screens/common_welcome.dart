import 'package:flutter/material.dart';
import 'package:student_task_manager/Screens/Home.dart';
import 'package:student_task_manager/Screens/home_screen_teacher.dart';
import 'package:student_task_manager/Screens/profile.dart';
import 'package:student_task_manager/constant.dart';

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
      _selectedPage = prefs.getString("${kSaveKey}");
    });
  }

  _saveSelectedPage(String page) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("${kSaveKey}", page);
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedPage == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Welcome"),
          centerTitle: true,
        ),
        body: Container(
          color: Colors.blueGrey.shade900,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RoundedButton(
                  sizee: 1,
                  text: "Teacher",
                  press: () async {
                    if (await onBackPressed(
                        context, "Are you sure want to select Teacher")) {
                      _saveSelectedPage("teacher");
                      setState(() {
                        _selectedPage = "teacher";
                      });
                    }
                  }),
              RoundedButton(
                sizee: 1,
                text: "Student",
                press: () async {
                  if(await onBackPressed(context, "Are you sure want to select Student"))
                    _saveSelectedPage("student");
                    setState(() {
                      _selectedPage = "student";
                    });
                }
              ),
            ],
          ),
        ),
      );
    } else if (_selectedPage == "teacher") {
      return HomeScreenTeacher();
    } else {
      return HomeScreenStudent();
    }
  }
}
