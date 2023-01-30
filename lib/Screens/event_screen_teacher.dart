import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:student_task_manager/Screens/AddEvent.dart';
import 'package:student_task_manager/component/google_sign_in.dart';
import 'package:student_task_manager/constant.dart';

import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

class EventScreenTeacher extends StatefulWidget {
  @override
  _EventScreenTeacherState createState() => _EventScreenTeacherState();
}

class _EventScreenTeacherState extends State<EventScreenTeacher> {
  late Future<List<dynamic>> _data;
  List<Map<String, dynamic>> reports = [];
  final user = FirebaseAuth.instance.currentUser;
  void fetchReports(String path) async {
    final response = await http.post(Uri.parse(path));
    if (response.statusCode == 200) {
      setState(() {
        print(jsonDecode(response.body));
        print(jsonDecode(response.body).runtimeType);
        reports = [];
        for (var item in jsonDecode(response.body)) {
          print(item.runtimeType);
          if (item is Map) {
            Map<String, dynamic> newMap = {};
            item.forEach((key, value) {
              newMap[key] = value;
            });
            reports.add(newMap);
          }
        }
        // reports = jsonDecode(response.body)
        //     .map((student) => json.decode(student))
        //     .toList();
        // print(reports.runtimeType);
        // print(reports.toString());
      });
    } else {
      print("error");
    }
  }

  @override
  void initState() {
    super.initState();
    _data = fetchData(user);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WillPopScope(
        onWillPop: () => onBackPressed(context, "Are you sure want to exit"),
        child: Scaffold(
          appBar: AppBar(
            title: Center(child: Text('Events')),
            actions: <Widget>[
              GestureDetector(
                child: Icon(
                  Icons.refresh,
                ),
                onTap: () {
                  setState(() {
                    _data = fetchData(user);
                  });
                },
              ),
              TextButton(
                  onPressed: () {
                    final provider = Provider.of<GoogleSignInProvider>(context,
                        listen: false);
                    provider.logout();
                  },
                  child: Text(
                    "Logout",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _data = fetchData(user);
              });
              _data;
            },
            child: FutureBuilder(
              future: _data,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.all(16),
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: kPrimaryLightColor,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              children: [
                                Text(
                                    snapshot.data![index]['eventId'].toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(snapshot.data![index]['description']),
                              ],
                            ),
                            Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    setState(
                                      () {
                                        fetchReports(
                                            "$kURL/teacher/event/stats-list/${snapshot.data![index]['eventId']}/III CSE C");
                                        _data = fetchData(user);
                                        // print(
                                        //     jsonDecode(value.body).runtimeType);
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context) =>
                                              SingleChildScrollView(
                                            child: Container(
                                              width: 500,
                                              height: 500,
                                              child: StudentList(
                                                  studentData: reports),
                                              padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom),
                                            ),
                                          ),
                                        );
                                        // print(data);
                                      },
                                    );
                                  },
                                  child: Text("view report"),
                                ),
                              ],
                            ),
                            // Text("Mark as done"),
                          ],
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEvent(),
                ),
              );
            },
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Future<List<dynamic>> fetchData(User? user) async {
    final response = await http.post(Uri.parse(
        '$kURL/teacher/events/pending/${user!.email!.substring(0, user.email!.indexOf("@"))}'));
    // print(response.body);
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      List jsonResponse = json.decode(response.body);
      return jsonResponse;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }
}

class StudentList extends StatefulWidget {
  final List<Map<String, dynamic>> studentData;

  StudentList({required this.studentData});

  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.studentData.length,
      itemBuilder: (context, index) {
        Map<String, dynamic> student = widget.studentData[index];
        return Card(
          color: student['isCompleted'] ? Colors.green[100] : Colors.red[100],
          child: ListTile(
            leading: Text(student['studentRollNo'],
                style: TextStyle(fontWeight: FontWeight.bold)),
            title: Text(student['name'],
                style: TextStyle(fontWeight: FontWeight.bold)),
            trailing: IconButton(
              icon: Icon(CupertinoIcons.phone),
              onPressed: () => launch("tel:${student['mobile']}"),
            ),
          ),
        );
      },
    );
  }
}
