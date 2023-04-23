import 'package:flutter/material.dart';
import 'package:student_task_manager/Screens/student/Home.dart';
import 'package:student_task_manager/Screens/staff/attendance_screen.dart';
import 'package:student_task_manager/Screens/admin/event_screen_admin.dart';
import 'package:student_task_manager/Screens/staff/home_screen_teacher.dart';
import 'package:student_task_manager/Screens/student/od_page_staffs.dart';
import 'package:student_task_manager/Screens/temp/profile.dart';
import 'package:student_task_manager/constant.dart';

import '../component/RoundedButton.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String isSelected = "";

class CommonWelcome extends StatefulWidget {
  @override
  State<CommonWelcome> createState() => _CommonWelcomeState();
}

class _CommonWelcomeState extends State<CommonWelcome>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  var _selectedPage;

  @override
  void initState() {
    _loadSelectedPage();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..forward();
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
        body: Center(
          child: AnimatedBuilder(
            animation: _animation,
            builder: (BuildContext context, Widget? child) {
              return Opacity(
                opacity: _animation.value,
                child: child,
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Color(0xFF0A0E21),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RoundedButton(
                      sizee: 0.8,
                      text: "HOD",
                      press: () async {
                        if (await onBackPressed(
                            context, "Are you sure want to select HOD")) {
                          _saveSelectedPage("hod");
                          setState(() {
                            _selectedPage = "hod";
                          });
                        }
                      }),
                  RoundedButton(
                      sizee: 0.8,
                      text: "Admin",
                      press: () async {
                        if (await onBackPressed(
                            context, "Are you sure want to select Admin")) {
                          _saveSelectedPage("admin");
                          setState(() {
                            _selectedPage = "admin";
                          });
                        }
                      }),
                  RoundedButton(
                      sizee: 0.8,
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
                      sizee: 0.8,
                      text: "Student",
                      press: () async {
                        if (await onBackPressed(
                            context, "Are you sure want to select Student"))
                          _saveSelectedPage("student");
                        setState(() {
                          _selectedPage = "student";
                        });
                      }),
                ],
              ),
            ),
          ),
        ),
      );
    } else if (_selectedPage == "hod") {
      return HomeScreenTeacher();
    } else if (_selectedPage == "admin") {
      return HomeScreenAdmin();
    } else if (_selectedPage == "teacher") {
      return HomeScreenTeacher();
    } else {
      return HomeScreenStudent();
    }
  }
}
