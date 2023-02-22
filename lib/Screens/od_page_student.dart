import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:student_task_manager/constant.dart';

void main() {
  runApp(ODStudentScreen());
}

class ODStudentScreen extends StatefulWidget {
  @override
  _ODStudentScreenState createState() => _ODStudentScreenState();
}

class _ODStudentScreenState extends State<ODStudentScreen> {
  File? _imageFile = null;

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }

  Future<void> _uploadImage(File imageFile) async {
    final url = Uri.parse('$kURL/upload');
    final request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));
    final response = await request.send();
    if (response.statusCode == 200) {
      // Image uploaded successfully
    } else {
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
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: kPrimaryLightColor),
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
                  style: ElevatedButton.styleFrom(backgroundColor: kPrimaryLightColor),
                  onPressed: () async {
                    final pickedFile =
                        await ImagePicker().pickImage(source: ImageSource.camera);
                    setState(() {
                      _imageFile = File(pickedFile!.path);
                    });
                  },
                  child: Text('Take Photo'),
                ),
              ],
            ),
            if (_imageFile != null) Image.file(_imageFile!),
            if(_imageFile != null)ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: kPrimaryLightColor),
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
