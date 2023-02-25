import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:student_task_manager/constant.dart';

import '../component/RoundedInputFeild.dart';


class ODStudentScreen extends StatefulWidget {
  @override
  _ODStudentScreenState createState() => _ODStudentScreenState();
}

class _ODStudentScreenState extends State<ODStudentScreen> {
  File? _imageFile = null;
  String description = "";
    String stu = "";
    String te = "";
    DateTime? startDate;
    DateTime? endDate;

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }

  Future<void> _uploadImage(File imageFile) async {
    final url = Uri.parse('$kURL/student/addOd/20eucs137');
    final request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));
    print(http.MultipartFile.fromPath('image', imageFile.path).runtimeType);
    print(imageFile.path);
    final response = await request.send();
    if (response.statusCode == 200) {
      // Image uploaded successfully
      print('done');
    } else {
      print('fail');
      // Failed to upload image
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Color(0xFF0A0E21),
      appBar: AppBar(title: Text('Image Picker Demo')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RoundedInputField(
              isDT: false,
              isList: false,
              isDes: true,
              times: 0.9,
              hintText: "Description",
              onChanged: (value) {
                description = value;
              },
              icon: Icons.description,
              onTap: () {},
            ),
            Column(
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
                RoundedInputField(
                  isList: false,
                    hintText: "student rno",
                    isDT: false,
                    onTap: () {},
                    icon: Icons.abc,
                    onChanged: (value) {
                      stu = value;
                    },
                    times: 0.8,
                    isDes: true),
                RoundedInputField(
                  isList: false,
                    hintText: "teacher rno",
                    isDT: false,
                    onTap: () {},
                    icon: Icons.abc,
                    onChanged: (value) {
                      te = value;
                    },
                    times: 0.8,
                    isDes: true)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryLightColor),
                  onPressed: () async {
                    final pickedFile = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    setState(() {
                      _imageFile = File(pickedFile!.path);
                    });
                  },
                  child: Text('Select File'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryLightColor),
                  onPressed: () async {
                    final pickedFile = await ImagePicker()
                        .pickImage(source: ImageSource.camera);
                    setState(() {
                      _imageFile = File(pickedFile!.path);
                    });
                  },
                  child: Text('Take Photo'),
                ),
              ],
            ),
            if (_imageFile != null) Image.file(_imageFile!),
            if (_imageFile != null)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryLightColor),
                onPressed: () async {
                  if (_imageFile == null) {
                    return;
                  }
                  await _uploadImage(_imageFile!);
                  // Navigate to another page to display the image and the API response
                },
                child: Text('Upload Image'),
              ),
          ],
        ),
      ),
    );
  }
}
