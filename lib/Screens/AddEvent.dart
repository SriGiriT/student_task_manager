import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_task_manager/component/RoundedButton.dart';
import 'package:student_task_manager/component/RoundedInputFeild.dart';
import 'package:student_task_manager/component/TextFieldContainer.dart';
import 'package:student_task_manager/constant.dart';
import 'package:http/http.dart' as http;

import '../component/google_sign_in.dart';

const List<String> yearList = ['I', 'II', 'III', 'IV', 'V'];
const List<String> deptList = ['CSE', 'IT', 'ECE', 'EEE', 'MTECH'];
const List<String> classList = ['A', 'B', 'C'];

Future<DateTime> selectDateTime(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101));
  if (picked != null) {
    final TimeOfDay? pickedTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (pickedTime != null) {
      return DateTime(picked.year, picked.month, picked.day, pickedTime.hour,
          pickedTime.minute);
    }
  }
  return DateTime.now();
}

class AddEvent extends StatefulWidget {
  AddEvent({super.key});
  var startDate = null;
  var endDate = null;
  String selectedYear = 'III';
  String selectedDept = 'CSE';
  String selectedClass = 'C';
  String description = "";
  String title = "";

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  DropdownButton<String> dropDown(
      List<String> yearList, String selectedYear, ValueChanged fun) {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in yearList) {
      var newItem = DropdownMenuItem(
        value: currency,
        child: Container(
            margin: EdgeInsets.all(5),
            width: 50,
            child: Text(
              currency,
              style: kButtonTextStyle,
            )),
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
        dropdownColor: kPrimaryColor,
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(color: kPrimaryLightColor),
        underline: Container(
          height: 2,
          color: kPrimaryColor,
        ),
        value: selectedYear,
        items: dropdownItems,
        onChanged: fun);
  }

  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFF0A0E21),
      appBar: AppBar(
        title: Center(child: Text('Add Events')),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.logout();
              },
              child: Text(
                "Logout",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
              ),
              RoundedInputField(
                isList: false,
                  isDT: false,
                  hintText: "Title",
                  onTap: () {},
                  icon: Icons.title,
                  onChanged: (value) {
                    widget.title = value;
                  },
                  times: 0.9,
                  isDes: false),
              RoundedInputField(
                isDT: false,
                isList: false,
                isDes: true,
                times: 0.9,
                hintText: "Description",
                onChanged: (value) {
                  widget.description = value;
                },
                icon: Icons.description,
                onTap: () {},
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RoundedInputField(
                    isList: false,
                    isDT: true,
                    isDes: false,
                    times: 0.45,
                    hintText: widget.startDate == null
                        ? "Select Date and Time"
                        : widget.startDate.toString().substring(0, 19),
                    icon: Icons.date_range,
                    onChanged: (value) async {
                      // value =
                      // await widget.startDate.toString().substring(0, 10);
                    },
                    onTap: () async {
                      final DateTime? selectedDateTime = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2015),
                        lastDate: DateTime(2100),
                      );
                      if (selectedDateTime != null) {
                        final TimeOfDay? selectedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (selectedTime != null) {
                          setState(() {
                            print(selectedDateTime.toString());
                            widget.startDate = DateTime(
                                selectedDateTime.year,
                                selectedDateTime.month,
                                selectedDateTime.day,
                                selectedTime.hour,
                                selectedTime.minute);
                          });
                        }
                      }
                    },
                  ),
                  RoundedInputField(
                    isList: false,
                    isDT: true,
                    isDes: false,
                    times: 0.45,
                    hintText: widget.endDate == null
                        ? "End Date and Time"
                        : widget.endDate.toString().substring(0, 19),
                    icon: Icons.date_range_outlined,
                    onChanged: (value) async {
                      
                    },
                    onTap: () async {
                      final DateTime? selectedDateTime = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2015),
                        lastDate: DateTime(2100),
                      );
                      if (selectedDateTime != null) {
                        final TimeOfDay? selectedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (selectedTime != null) {
                          setState(() {
                            widget.endDate = DateTime(
                                selectedDateTime.year,
                                selectedDateTime.month,
                                selectedDateTime.day,
                                selectedTime.hour,
                                selectedTime.minute);
                          });
                        }
                      }
                    },
                  ),
                ],
              ),
              TextFieldContainer(
                isLis: false,
                width: 0.9,
                isDescription: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    dropDown(
                      yearList,
                      widget.selectedYear,
                      (value) {
                        setState(() {
                          widget.selectedYear = value!;
                        });
                      },
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    dropDown(
                      deptList,
                      widget.selectedDept,
                      (value) {
                        setState(() {
                          widget.selectedDept = value!;
                        });
                      },
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    dropDown(
                      classList,
                      widget.selectedClass,
                      (value) {
                        setState(() {
                          widget.selectedClass = value!;
                        });
                      },
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              RoundedButton(
                sizee: 0.7,
                text: "Add Event",
                press: () async {
                  String st = widget.startDate.toString();
                  String ed = widget.endDate.toString();
                  var body = {
                    'title': widget.title,
                    'description': widget.description.toString(),
                    'fromDate':
                        '${st.substring(0, 10)} IST ${st.substring(11, 19)}',
                    'endDate':
                        '${ed.substring(0, 10)} IST ${ed.substring(11, 19)}',
                    'classCode':
                        '${widget.selectedYear} ${widget.selectedDept} ${widget.selectedClass}'
                  };
                  // var encodedBody = body.keys.map((key) => "$key=${body[key]}").join("&");
                  // var encodedBody =
                  //     body.keys.map((e) => '$e=${body[e]}').join("&");
                  http.post(Uri.parse('$kURL/teacher/event/new'), body: body);
                  print(body);
                  print(
                      "$kURL/${widget.title}/${widget.description}/${st.substring(0, 10)} IST ${st.substring(11, 19)}/${ed.substring(0, 10)} IST ${ed.substring(11, 19)}/${widget.selectedYear} ${widget.selectedDept} ${widget.selectedClass}");
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                  Navigator.pushNamed(context, '/eventte');
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
