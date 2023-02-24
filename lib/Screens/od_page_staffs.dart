import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_task_manager/constant.dart';

class OnDutyFormCommand {
  String description;
  Uint8List document;
  Set<String> studentRollNoSet;
  Set<String> mentorNameSet;
  DateTime fromDate;
  DateTime endDate;

  OnDutyFormCommand({
    required this.description,
    required this.document,
    required this.studentRollNoSet,
    required this.mentorNameSet,
    required this.fromDate,
    required this.endDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'document': base64.encode(document),
      'studentRollNoSet': studentRollNoSet.toList(),
      'mentorNameSet': mentorNameSet.toList(),
      'fromDate': fromDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }
}

final String apiUrl = '$kURL/addOd/20eucs137';

class OdStudent extends StatefulWidget {
  @override
  _OdStudentState createState() => _OdStudentState();
}

class _OdStudentState extends State<OdStudent> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  Uint8List? _document = null;
  Future<Uint8List> xFileToUint8List(XFile file) async {
  final bytes = await file.readAsBytes();
  return Uint8List.fromList(bytes);
}

  Future<void> _pickDocument() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    // final result = await FilePicker.platform.pickFiles();
    final document = await xFileToUint8List(pickedFile!);
  setState(() {
    _document = document;
  });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final formCommand = OnDutyFormCommand(
        description: _descriptionController.text,
        document: _document!,
        studentRollNoSet: {"20eucs147", "20eucs125"},
        mentorNameSet: {"Renuga devi", "viji kaveri", "gowthamani"},
        fromDate: DateTime.now(),
        endDate: DateTime.now(),
      );

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(formCommand.toJson()),
      );

      if (response.statusCode == 200) {
        print('Form command sent successfully!');
      } else {
        print('Failed to send form command: ${response.body}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Spring POST Request Demo'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Description is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _pickDocument,
                child: Text(_document == null
                    ? 'Select Document'
                    : 'Document Selected'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
