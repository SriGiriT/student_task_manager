import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:student_task_manager/Screens/EventScreen.dart';
import 'dart:convert';
import 'package:student_task_manager/constant.dart';
import 'package:url_launcher/url_launcher.dart';

import '../component/RoundedInputFeild.dart';

bool isLoading = false;
List<String> abse = [];
List<String> ods = [];

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
  static User? user = FirebaseAuth.instance.currentUser;
  static Future<List<Student>> fetchStudents() async {
    final response = await http.post(Uri.parse(
        '$baseUrl/attendance/list/${user!.email!.substring(0, user!.email!.indexOf("@"))}/${DateTime.now().toString().substring(0, 10)}'));

    // print(DateTime.now().toString().substring(0, 10));
    var data = json.decode(response.body);
    List<Student> students = [];
    // print(data);
    data.forEach((key, value) {
      value.forEach((key1, value1) {
        students.add(Student(
            id: key,
            name: key1,
            present: value1['isPresent'],
            od: value1['onOd']));
      });
    });
    abse = await students
        .where((student) => !student.present)
        .toList()
        .map((student) => student.id.substring(6))
        .toList();
    ods = await students
        .where((student) => student.od)
        .toList()
        .map((e) => e.id.substring(6))
        .toList();
    ab = abse;
    od = ods;
    return students;
  }

  static Future<void> submitAttendance(List<Student> students) async {
    final data = List<dynamic>.from(students.map((student) => {
          student.id: student.present,
        }));
    // print(data);
    Map<String, bool> res = {};
    for (var item in data) {
      if (item is Map) {
        item.forEach((key, value) {
          res.putIfAbsent(key, () => value);
        });
      }
    }
    // print(res);
    DateTime date = DateTime.now();
    // print(date.toString().substring(0, 10));
    final response = await http.post(
        Uri.parse(
            '$baseUrl/attendance/put/${user!.email!.substring(0, user!.email!.indexOf("@"))}/${date.toString().substring(0, 10)}'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(res));
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
  int period = 0;
  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<int> fetchDateAndPeriod() async {
    final response = await http.post(Uri.parse('$kURL/teacher/getPeriod'));
    var data = json.decode(response.body);
    // print(data);
    // print(data.runtimeType);
    period = await data;
    return period;
  }

  Future<void> _fetchStudents() async {
    setState(() {
      isLoading = true;
    });
    final students = await ApiService.fetchStudents();
    setState(() {
      _students = students;
      isLoading = false;
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
      appBar: AppBar(
        title: Text('Attendance'),
        actions: [
          IconButton(
            tooltip: 'Select all',
            onPressed: () => SelectAll(),
            icon: Icon(Icons.select_all),
          ),
          Center(
              child: GestureDetector(
                  onTap: SelectAll, child: Text("Select all  ")))
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateTime.now().toString().substring(8, 10) +
                            DateTime.now().toString().substring(4, 7) +
                            "-" +
                            DateTime.now().toString().substring(2, 4),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      Text(
                        'Period - ${period.toString()}',
                        style: TextStyle(
                            color: Colors.green.shade300,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ]),
              ),
              Expanded(
                child: ListView.builder(
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
                        tileColor: student.present
                            ? Colors.green.shade300
                            : student.od
                                ? Colors.orange.shade300
                                : Colors.red.shade300,
                        title: Text(
                          "${student.id} - ${student.name}",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        trailing: Checkbox(
                          value: student.present,
                          onChanged: (value) {
                            student.present = value!;
                            _updateAttendance(index, value);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          if (isLoading)
            CircularProgressIndicator(
              color: Colors.red,
            )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryLightColor,
        onPressed: () async {
          setState(() {
            isLoading = true;
          });
          await ApiService.submitAttendance(_students);
          final absentStudents =
              _students.where((student) => !student.present).toList();
          final odStudents = _students.where((element) => element.od);
          final absentIds =
              absentStudents.map((student) => student.id.substring(6)).toList();
          final odIds =
              odStudents.map((student) => student.id.substring(6)).toList();
          setState(() {
            isLoading = false;
          });
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AbsenteesPage(absentees: absentIds, odList: odIds)));
        },
        child: Icon(Icons.check),
      ),
    );
  }

  SelectAll() {
    for (int i = 0; i < _students.length; i++) {
      _students[i].present = true;
    }
    setState(() {
      _students;
    });
  }
}

class Student {
  String id;
  String name;
  bool present;
  bool od;
  Student(
      {required this.id,
      required this.name,
      this.present = false,
      this.od = false});
}

class AbsenteesPage extends StatefulWidget {
  final List<String> absentees;
  final List<String> odList;

  AbsenteesPage({required this.absentees, required this.odList});

  @override
  State<AbsenteesPage> createState() => _AbsenteesPageState();
}

class _AbsenteesPageState extends State<AbsenteesPage> {
  final user = FirebaseAuth.instance.currentUser;
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    setState(() {
      isLoading = true;
    });
    final students = await ApiService.fetchStudents();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> copyToClipboard(BuildContext context) async {
    final String ids = widget.absentees.join(", ");
    final String ods = widget.odList.join(", ");
    String clip = "Absentees Ids\n" + ids + "\n\nOd Ids" + ods;
    await Clipboard.setData(ClipboardData(text: clip));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Absentees' And Od IDs copied to clipboard"),
    ));
  }

  Future<void> shareOnWhatsApp() async {
    final user = FirebaseAuth.instance.currentUser;
    String ids = "Absentees%27%20IDs:%20\n";
    ids += widget.absentees.join(", ");
    ids += "\n\nOd:\n";
    ids += widget.odList.join(", ");
    final String url = "whatsapp://send?text=${ids}";
    // if (await canLaunch(url)) {
    await launch(url);
    // } else {
    //   throw "Could not launch $url";
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0A0E21),
        title: Text("Absentees"),
        actions: [
          IconButton(
            onPressed: () => copyToClipboard(context),
            icon: Icon(Icons.copy),
          ),
          IconButton(
            onPressed: () => shareOnWhatsApp(),
            icon: Icon(Icons.share),
          ),
        ],
      ),
      body: Container(
        color: Color(0xFF0A0E21),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Absentees' IDs",
                            style:
                                TextStyle(fontSize: 24.0, color: Colors.white),
                          ),
                          SizedBox(height: 16.0),
                          GestureDetector(
                            onTap: () {
                              copyToClipboard(context);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 24.0),
                              decoration: BoxDecoration(
                                color: Colors.red.shade300,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                widget.absentees.join(", "),
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            "OD IDs",
                            style:
                                TextStyle(fontSize: 24.0, color: Colors.white),
                          ),
                          SizedBox(height: 16.0),
                          GestureDetector(
                            onTap: () {
                              copyToClipboard(context);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 24.0),
                              decoration: BoxDecoration(
                                color: Colors.red.shade300,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                widget.odList.join(", "),
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              shareOnWhatsApp();
                            },
                            child: Container(
                              margin: EdgeInsets.all(20),
                              width: 150,
                              height: 38,
                              decoration: BoxDecoration(
                                  color: Colors.green.shade300,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.whatsapp,
                                  ),
                                  Container(
                                    child: Text(" Whatsapp"),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    if (isLoading)
                      CircularProgressIndicator(
                        color: Colors.red,
                      )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ReportGeneration extends StatefulWidget {
  ReportGeneration({super.key});

  var startDate = null;
  var endDate = null;
  @override
  State<ReportGeneration> createState() => _ReportGenerationState();
}

class _ReportGenerationState extends State<ReportGeneration> {
  bool isShow = false;
  List<Map<String, dynamic>> persentage = [];
  List<String> code = [];
  User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    fetchStudentsReports();
  }

  Future<List<Map<String, dynamic>>> fetchStudentsReports() async {
    final response = await http.post(Uri.parse(
        '$kURL/attendance/all/${DateTime.now().toString().substring(0, 10)}'));

    var data = json.decode(response.body);
    code = [];
    persentage = [];
    print(data);
    print(data.runtimeType);
    for (dynamic i in data) {
      Map<String, dynamic> map = {};
      i.forEach((key, value) {
        code.add(key);
        print("$key");
        value.forEach((key1, value1) {
          map[key1] = value1;
        });
      });
      persentage.add(map);
    }
    return persentage;
  }

  Future<List<Map<String, dynamic>>> fetchStudentsByDate(
      DateTime startDate, DateTime endDate) async {
    final response = await http.post(Uri.parse(
        '$kURL/attendance/percentage-daily/${user!.email!.substring(0, user!.email!.indexOf("@"))}/${DateTime.now().subtract(Duration(days: 5)).millisecondsSinceEpoch}/${DateTime.now().millisecondsSinceEpoch}'));
    var data = json.decode(response.body);
    List<Map<String, dynamic>> students = [];
    data.forEach((key, value) {
      Map<String, dynamic> te = {};
      te['sName'] = key;
      te['value'] = value;
      students.add(te);
    });
    return students;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryConstColor,
      appBar: AppBar(
        title: Center(child: Text("Report")),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 8,
          ),
          Text(
            "Attendance Report",
            style: TextStyle(fontSize: 24.0, color: Colors.white),
          ),
          SizedBox(
            height: 8,
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
                    initialDate: DateTime.now().subtract(Duration(days: 30)),
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
                onChanged: (value) async {},
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
          SizedBox(
            height: 8,
          ),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: kPrimaryLightColor),
            onPressed: () async {
              var data =
                  await fetchStudentsByDate(widget.startDate, widget.endDate);
              showModalBottomSheet(
                context: context,
                builder: (context) => SingleChildScrollView(
                  child: Container(
                    width: 500,
                    height: 500,
                    child: FilterAttendance(
                      students: data,
                    ),
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                  ),
                ),
              );
            },
            child: const Text("Get Date wise Attendance"),
          ),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                isShow = true;
              });
            },
            child: const Text("Get Overall Report"),
          ),
          SizedBox(
            height: 30,
          ),
          if (isShow == true)
            Container(
              child: Expanded(
                child: ListView.builder(
                  itemCount: persentage.length,
                  itemBuilder: (context, index) {
                    final report = persentage[index];
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ListTile(
                        tileColor: Color.fromARGB(255, 35, 93, 122),
                        title: Text(
                          " ${code[index]} present:${report['present']} absent:${report['absent']}",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        trailing: Text(
                          "od:${report['od']}",
                          style: TextStyle(
                              // color: students[index]['value'] <= 74 ? Colors.red : Colors.green,
                              color: Colors.white,
                              fontSize: 18),
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
        ],
      ),
    );
  }
}

class FilterAttendance extends StatelessWidget {
  List<Map<String, dynamic>> students;
  FilterAttendance({super.key, required this.students});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF0A0E21),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: ListTile(
                  tileColor: Colors.blueGrey,
                  title: Text(
                    "${students[index]['sName']}",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  trailing: Text(
                    "${students[index]['value']}",
                    style: TextStyle(
                        // color: students[index]['value'] <= 74 ? Colors.red : Colors.green,
                        color: Colors.white,
                        fontSize: 18),
                  ),
                ),
              );
            },
          ),
          // if (isLoading)
          //   CircularProgressIndicator(
          //     color: Colors.red,
          //   )
        ],
      ),
    );
  }
}
