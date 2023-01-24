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
  const AddEvent({super.key});

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  @override
  Widget build(BuildContext context) {
    DateTime startDate = new DateTime.now();
    DateTime endDate = new DateTime.now();

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
                      hintText: "start date",
                      icon: Icons.date_range,
                      onChanged: (value) async {
                        value =  await startDate.toString().substring(0, 10);
                      },
                      onTap: () async {
                        final DateTime dateTime = await selectDateTime(context);
                      
                      
                      
                      
                        if (dateTime != null) {
                          setState(() {
                            startDate = dateTime;
                            print(startDate);
                          });
                        }
                      }),
                  RoundedInputField(
                    times: 0.4,
                    hintText: "end date",
                    icon: Icons.date_range,
                    onChanged: (value) async{
                      value = await endDate.toString().substring(0, 10);
                    },
                    onTap: () async {
                      final DateTime? dateTime = await selectDateTime(context);
                      if (dateTime != null) {
                        setState(() {
                          // print(picked);
                          endDate = dateTime;
                          print(endDate);
                        });
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
