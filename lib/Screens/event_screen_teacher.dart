import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:student_task_manager/Screens/AddEvent.dart';
import 'package:student_task_manager/Screens/attendance_screen.dart';
import 'package:student_task_manager/Screens/od_page_staffs.dart';
import 'package:student_task_manager/Screens/od_page_student.dart';
import 'package:student_task_manager/component/google_sign_in.dart';
import 'package:student_task_manager/constant.dart';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

bool isLoading = false;

class TeacherScreen extends StatefulWidget {
  const TeacherScreen({super.key});

  @override
  State<TeacherScreen> createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  @override
  void initState() {
    ApiService.fetchStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0E21),
      appBar: AppBar(
        title: Center(child: Text('Staff Page')),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.logout();
              },
              child: Text(
                "Logout",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            padding: const EdgeInsets.all(8),
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Listofgames(1, "Events", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventScreenTeacher(),
                  ),
                );
              }, Icons.task),
              Listofgames(2, "Attendance", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TakeOrRefer(),
                  ),
                );
              }, Icons.check),
              Listofgames(3, "On Duty", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OdStudent(),
                  ),
                );
              }, Icons.add)
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }
}

class TakeOrRefer extends StatefulWidget {
  const TakeOrRefer({super.key});

  @override
  State<TakeOrRefer> createState() => _TakeOrReferState();
}

class _TakeOrReferState extends State<TakeOrRefer> {
  @override
  Widget build(BuildContext context) {
    ApiService.fetchStudents();
    return Scaffold(
      backgroundColor: Color(0xFF0A0E21),
      appBar: AppBar(
        title: Center(child: Text('Staff Page')),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.logout();
              },
              child: Text(
                "Logout",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            padding: const EdgeInsets.all(8),
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Listofgames(1, "Take Attendance", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AttendancePage(),
                  ),
                );
              }, Icons.task),
              Listofgames(2, "Attendance data", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AbsenteesPage(
                      absentees: ab, odList: od,
                    ),
                  ),
                );
              }, Icons.check)
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }
}

class EventScreenTeacher extends StatefulWidget {
  @override
  _EventScreenTeacherState createState() => _EventScreenTeacherState();
}

class _EventScreenTeacherState extends State<EventScreenTeacher> {
  // void showNotification() {
  //   flutterLocalNotificationsPlugin.show(
  //       0,
  //       "Testing",
  //       "test ",
  //       NotificationDetails(
  //           android: AndroidNotificationDetails(
  //         channel.id,
  //         channel.name,
  //         channel.description,
  //         importance: Importance.high,
  //         color: Colors.blue,
  //         playSound: true,
  //       )));
  // }

  late Future<List<dynamic>> _data;
  List<Map<String, dynamic>> reports = [];
  Map<String, int> reports_stats = {};
  final user = FirebaseAuth.instance.currentUser;
  Future<void> fetchReports(String path) async {
    final response = await http.post(Uri.parse(path));
    if (response.statusCode == 200) {
      setState(() {
        // print(jsonDecode(response.body));
        // print(jsonDecode(response.body).runtimeType);
        reports = [];
        for (var item in jsonDecode(response.body)) {
          // print(item.runtimeType);
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

  Future<void> fetchReportsStats(String path) async {
    final response = await http.post(Uri.parse(path));
    if (response.statusCode == 200) {
      setState(() {
        print(jsonDecode(response.body));
        reports_stats = {};
        // jsonDecode(response.body).forEach((key, value)){
        //   reports_stats[key] = value;
        // }
        reports_stats = jsonDecode(response.body).cast<String, int>();
      });
    } else {
      print("error");
    }
  }

  @override
  void initState() {
    // super.initState();
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   RemoteNotification notification = message.notification!;
    //   AndroidNotification? android = message.notification!.android;
    //   if (notification != null && android != null) {
    //     flutterLocalNotificationsPlugin.show(
    //         notification.hashCode,
    //         notification.title,
    //         notification.body,
    //         NotificationDetails(
    //             android: AndroidNotificationDetails(
    //           channel.id,
    //           channel.name,
    //           channel.description,
    //           color: Colors.blue,
    //         )));
    //   }
    // });
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   print('A new onMessageOpenedApp event was published!');
    //   RemoteNotification notification = message.notification!;
    //   AndroidNotification android = message.notification!.android!;
    //   if (notification != null && android != null) {
    //     showDialog(
    //         context: context,
    //         builder: (_) {
    //           return AlertDialog(
    //             title: Text(notification.title!),
    //             content: SingleChildScrollView(
    //                 child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [Text(notification.body!)],
    //             )),
    //           );
    //         });
    //   }
    // });
    super.initState();
    _data = fetchData(user);
  }

  @override
  Widget build(BuildContext context) {
    fetchData(user);
    return MaterialApp(
      theme: ThemeData(primarySwatch: kMatColor),
      debugShowCheckedModeBanner: false,
      home: WillPopScope(
        onWillPop: () => onBackPressed(context, "Are you sure want to exit"),
        child: Scaffold(
          backgroundColor: kMatColor,
          appBar: AppBar(
            leading: GestureDetector(
              child: Icon(
                Icons.refresh,
              ),
              onTap: () {
                setState(() {
                  _data = fetchData(user);
                });
              },
            ),
            title: Center(child: Text('Events')),
            actions: <Widget>[
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
          body: Stack(alignment: Alignment.center, children: [
            RefreshIndicator(
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
                        return GestureDetector(
                          onTap: () async {
                            setState(() {
                              isLoading = true;
                            });
                            await fetchReportsStats(
                                "$kURL/teacher/event/stats/${snapshot.data![index]['eventId']}/III CSE C");
                            await fetchReports(
                                "$kURL/teacher/event/stats-list/${snapshot.data![index]['eventId']}/III CSE C");
                            setState(() {
                              isLoading = false;
                              _data = fetchData(user);
                            });
                            // print(
                            //     jsonDecode(value.body).runtimeType);
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => SingleChildScrollView(
                                child: Container(
                                  width: 500,
                                  height: 500,
                                  child: StudentList(
                                    studentData: reports,
                                    stats: reports_stats,
                                  ),
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                ),
                              ),
                            );
                          },
                          child: Expanded(
                            child: Container(
                              padding: EdgeInsets.all(16),
                              margin: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: kPrimaryLightColor,
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                // crossAxisAlignment: CrossAxisAlignment.,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            (snapshot.data![index]['title']
                                                    .toString()) +
                                                " ",
                                            style: TextStyle(
                                                color: Colors.orange.shade300,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                          snapshot.data![index]['eventId']
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        snapshot.data![index]['description'],
                                        style: TextStyle(
                                            color: Colors.blueAccent,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            
                                                snapshot.data![index]
                                                        ['fromDate']
                                                    .toString()
                                                    .substring(8, 10) +
                                                snapshot.data![index]
                                                        ['fromDate']
                                                    .toString()
                                                    .substring(4, 7) +
                                                "-" +
                                                snapshot.data![index]
                                                        ['fromDate']
                                                    .toString()
                                                    .substring(2, 4) +"  "+
                                                timeText(snapshot.data![index]
                                                        ['fromDate']
                                                    .toString()
                                                    .substring(11, 19)) ,
                                            style: TextStyle(
                                                color: Colors.green.shade300,
                                                fontWeight: FontWeight.bold)),
                                                Text("|", style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                          snapshot.data![index]['endDate']
                                                  .toString()
                                                  .substring(8, 10) +
                                              snapshot.data![index]['endDate']
                                                  .toString()
                                                  .substring(4, 7) +
                                              "-" +
                                              snapshot.data![index]['endDate']
                                                  .toString()
                                                  .substring(2, 4) +"  "+
                                              timeText(
                                                snapshot.data![index]['endDate']
                                                    .toString()
                                                    .substring(11, 19),
                                              ),
                                          style: TextStyle(
                                              color: Colors.red.shade300,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Container(
                        child: Center(
                            child: Text(
                      "${snapshot.error}",
                      style: TextStyle(color: Colors.white, fontSize: 50),
                    )));
                  }
                  return Center(
                      child: CircularProgressIndicator(
                    color: Colors.red,
                  ));
                },
              ),
            ),
            if (isLoading)
              CircularProgressIndicator(
                color: Colors.red,
              )
          ]),
          floatingActionButton: FloatingActionButton(
            backgroundColor: kPrimaryLightColor,
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
    setState(() {
      CircularProgressIndicator(
        color: Colors.red,
      );
    });
    final response = await http.post(Uri.parse(
        '$kURL/teacher/events/pending/${user!.email!.substring(0, user.email!.indexOf("@"))}'));
    // print(response.body);
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      List jsonResponse = json.decode(response.body);
      return jsonResponse;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('404 Error');
    }
  }

  String timeText(String string) {
    String timeString = "14:30:00";
    DateTime time = DateTime.parse("1970-01-01 $string");

    String formattedTime = DateFormat('h:mm a').format(time);
    return formattedTime;
  }
}

class StudentList extends StatefulWidget {
  final List<Map<String, dynamic>> studentData;
  final Map<String, int> stats;
  StudentList({required this.studentData, required this.stats});

  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF0A0E21),
      child: Column(
        children: [
          Container(
            color: Color(0xFF0A0E21),
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "pending - ${widget.stats['pending']}",
                  style: TextStyle(
                      color: Colors.red.shade300,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                Text(
                  "${(widget.stats['completed'])}/${widget.stats['total']}",
                  style: TextStyle(
                      color: Colors.green.shade300,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.studentData.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> student = widget.studentData[index];
                return Card(
                  color: student['isCompleted']
                      ? Colors.green[100]
                      : Colors.red[100],
                  child: ListTile(
                      leading: Text(student['studentRollNo'],
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      title: Text(student['name'],
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.whatsapp),
                            onPressed: () => launch(
                                "whatsapp://send?phone=+91${student['mobile']}"),
                          ),
                          IconButton(
                            icon: Icon(CupertinoIcons.phone),
                            onPressed: () => launch("tel:${student['mobile']}"),
                          ),
                        ],
                      )),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
