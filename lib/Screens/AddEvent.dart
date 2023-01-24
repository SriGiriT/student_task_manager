import 'dart:math';

import 'package:flutter/material.dart';
import 'package:student_task_manager/component/RoundedInputFeild.dart';

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

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
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
                onChanged: (value) {},
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
                        : widget.startDate.toString().substring(0, 10),
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

                    // () async {
                    //   final DateTime dateTime = await selectDateTime(context);
                    //   if (dateTime != null) {
                    //     setState(() {
                    //       widget.startDate = dateTime;
                    //       print(widget.startDate);
                    //     });
                    //   }
                    // }
                  ),
                  RoundedInputField(
                    times: 0.4,
                    hintText: widget.endDate == null
                        ? "End Date and Time"
                        : widget.endDate.toString().substring(0, 10),
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
              )
            ]),
      ),
    );
  }
}
