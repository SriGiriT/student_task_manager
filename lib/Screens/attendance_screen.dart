import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:student_task_manager/constant.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  @override
  Widget build(BuildContext context) {
    return AttendancePage();
  }
}

class ApiService {
  static String baseUrl = kURL;
  static Future<List<Student>> fetchStudents() async {
    final response = await http
        .post(Uri.parse('$baseUrl/teacher/student/getList/III CSE C'));
    var data = json.decode(response.body);
    List<Student> students = [];
    data.forEach((key, value) {
      students.add(Student(id: key, name: value, present: false));
    });
    return students;
  }

  static Future<void> updateAttendance(Student student) async {
    final response = await http.post(
        Uri.parse('$baseUrl/teacher/student/attendance/${student.id}'),
        body: json.encode({'present': student.present}));
    // student.present = !student.present;
    if (response.statusCode != 200) {
      throw Exception('Failed to update attendance.');
    }
  }

  static Future<void> submitAttendance(List<Student> students) async {
    final data = List<dynamic>.from(students.map((student) => {
          'id': student.id,
          'present': student.present,
        }));
    print(data);
    final response = await http.post(Uri.parse('$baseUrl/attendance'),
        body: json.encode(data));
    if (response.statusCode != 200) {
      throw Exception('Failed to submit attendance.');
    }
  }
}

class AttendancePage extends StatefulWidget {
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  List<Student> _students = [];

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    final students = await ApiService.fetchStudents();
    setState(() {
      _students = students;
    });
  }

  Future<void> _updateAttendance(int index, bool present) async {
    final student = _students[index];
    student.present = present;
    // await ApiService.updateAttendance(student);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0E21),
      appBar: AppBar(title: Text('Attendance')),
      body: _students == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _students.length,
              itemBuilder: (context, index) {
                final student = _students[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      student.present = !student.present;
                    });
                  },
                  child: ListTile(
                    tileColor: student.present ? Colors.green.shade300 : Colors.red.shade300 ,
                    title: Text(
                      "${student.id} - ${student.name}",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    trailing: Checkbox(
                      value: student.present,
                      onChanged: (value) {
                        student.present = value!;
                        _updateAttendance(index, value!);
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await ApiService.submitAttendance(_students);
        },
        child: Icon(Icons.check),
      ),
    );
  }
}

class Student {
  String id;
  String name;
  bool present;
  Student({required this.id, required this.name, this.present = false});
}
