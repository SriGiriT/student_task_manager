import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_task_manager/component/RoundedButton.dart';
import 'package:student_task_manager/constant.dart';

import '../component/RoundedInputFeild.dart';

class OnDutyFormCommand {
  String description;
  Uint8List document;
  List<String> studentRollNoList;
  List<String> mentorNameList;
  String fromDate;
  String endDate;

  OnDutyFormCommand({
    required this.description,
    required this.document,
    required this.studentRollNoList,
    required this.mentorNameList,
    required this.fromDate,
    required this.endDate,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'description': description,
      'document': base64.encode(document),
      'fromDate': fromDate.toString(),
      'endDate': endDate.toString(),
    };
    for (int i = 0; i < studentRollNoList.length; i++) {
      map['studentRollNoList[$i]'] = studentRollNoList[i];
    }
    for (int i = 0; i < mentorNameList.length; i++) {
      map['mentorNameList[$i]'] = mentorNameList[i];
    }
    return map;
  }
}

final String apiUrl = '$kURL/student/addOd/20eucs137';

class OdStudent extends StatefulWidget {
  @override
  _OdStudentState createState() => _OdStudentState();
}

class _OdStudentState extends State<OdStudent> {
  var startDate = null;
  var endDate = null;
  String studentRegNoList = "";
  String mentorNameListString = "";
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  Uint8List? _document = null;
  Future<Uint8List> platformFileToUint8List(PlatformFile file) async {
    final bytes = await File(file.path!).readAsBytes();
    return Uint8List.fromList(bytes);
  }

  Future<void> _pickDocument() async {
    // final pickedFile =
    //     await ImagePicker().pickImage(source: ImageSource.gallery);
    final result = await FilePicker.platform.pickFiles();
    // final document = await xFileToUint8List(pickedFile!);
    if (result != null) {
      final file = result.files.single;
      final document = await platformFileToUint8List(file);
      setState(() {
        _document = document;
      });
    }
  }

  late String text;
  Future<void> _submitForm(
      String text, List<String> studentList, List<String> mentorList) async {
    if (_formKey.currentState!.validate()) {
      print(
          '${startDate.toString().substring(0, 10)} IST ${startDate.toString().substring(11, 19)}');
      final formCommand = OnDutyFormCommand(
        description: text,
        document: _document!,
        studentRollNoList: studentList,
        mentorNameList: mentorList,
        fromDate:
            '${startDate.toString().substring(0, 10)} IST ${startDate.toString().substring(11, 19)}',
        endDate:
            "${endDate.toString().substring(0, 10)} IST ${endDate.toString().substring(11, 19)}",
      );

      final response = await http.post(
        Uri.parse(apiUrl),
        // headers: {'Content-Type': 'application/json'},
        body: formCommand.toJson(),
      );

      if (response.statusCode == 200) {
        print('Form command sent successfully! :${response.body}');
      } else {
        print('Failed to send form command: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error occurred while making the POST request."),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0E21),
      appBar: AppBar(
        title: Text('Apply OD'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 50,
                ),
                RoundedInputField(
                    isList: false,
                    isDT: false,
                    hintText: "Description",
                    onTap: () {},
                    icon: Icons.title,
                    onChanged: (value) {
                      text = value;
                    },
                    times: 0.9,
                    isDes: false),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RoundedInputField(
                      isList: false,
                      isDT: true,
                      isDes: false,
                      times: 0.45,
                      hintText: startDate == null
                          ? "Select Date and Time"
                          : startDate.toString().substring(0, 19),
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
                              startDate = DateTime(
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
                      hintText: endDate == null
                          ? "End Date and Time"
                          : endDate.toString().substring(0, 19),
                      icon: Icons.date_range_outlined,
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
                              endDate = DateTime(
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
                RoundedInputField(
                    isList: true,
                    hintText: "Students Reg No",
                    isDT: false,
                    onTap: () {},
                    icon: Icons.description,
                    onChanged: (value) {
                      studentRegNoList = value;
                    },
                    times: 0.9,
                    isDes: true),
                SizedBox(height: 8.0),
                RoundedInputField(
                    isList: true,
                    hintText: "Mentor Name List",
                    isDT: false,
                    onTap: () {},
                    icon: Icons.description,
                    onChanged: (value) {
                      mentorNameListString = value;
                    },
                    times: 0.9,
                    isDes: true),
                SizedBox(height: 8.0),
                RoundedButton(
                    sizee: 0.9,
                    text: _document == null
                        ? "Select Document"
                        : "Document Selected",
                    press: () {
                      _pickDocument();
                    }),
                SizedBox(height: 8.0),
                RoundedButton(
                  sizee: 0.8,
                  text: "Submit",
                  press: () {
                    _submitForm(text, studentRegNoList.split(", "),
                        mentorNameListString.split(", "));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
