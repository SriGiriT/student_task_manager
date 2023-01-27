import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:student_task_manager/component/RoundedButton.dart';
import 'package:student_task_manager/component/RoundedInputFeild.dart';
import 'package:student_task_manager/constant.dart';
import 'package:http/http.dart' as http;

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
  return new DateTime.now();
}

class AddEvent extends StatefulWidget {
  AddEvent({super.key});
  var startDate = null;
  var endDate = null;
  String selectedYear = 'III';
  String selectedDept = 'CSE';
  String selectedClass = 'C';
  String description = "";

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
        child: Text(currency),
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RoundedInputField(
              times: 0.8,
              hintText: "description",
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
                  times: 0.4,
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
                  times: 0.4,
                  hintText: widget.endDate == null
                      ? "End Date and Time"
                      : widget.endDate.toString().substring(0, 19),
                  icon: Icons.date_range,
                  onChanged: (value) async {
                    // value = await widget.endDate.toString().substring(0, 10);
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
            Row(
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
                dropDown(
                  deptList,
                  widget.selectedDept,
                  (value) {
                    setState(() {
                      widget.selectedDept = value!;
                    });
                  },
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
            RoundedButton(
              text: "Add Event",
              press: () async {
                var body = {
                  'description': widget.description.toString(),
                  'fromDate': widget.startDate.toString().substring(0, 19),
                  'endDate': widget.endDate.toString().substring(0, 19),
                  'classCode':
                      '${widget.selectedYear} ${widget.selectedDept} ${widget.selectedClass}'
                };
                // var encodedBody = body.keys.map((key) => "$key=${body[key]}").join("&");
                var encodedBody =
                    body.keys.map((e) => '$e=${body[e]}').join("&");
                http.post(Uri.parse('$kURL/event/new'), body: encodedBody);
                print(
                    "$kURL/${widget.description}/${widget.startDate.toString().substring(0, 19)}/${widget.endDate.toString().substring(0, 19)}/${widget.selectedYear} ${widget.selectedDept} ${widget.selectedClass}");
              },
            )
          ],
        ),
      ),
    );
  }
}
