import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:student_task_manager/Screens/student/od_page_staffs.dart';
import 'package:student_task_manager/component/google_sign_in.dart';
import 'package:student_task_manager/constant.dart';

import '../staff/od_page_student.dart';

class EventScreen extends StatefulWidget {
  @override
  _EventScreenState createState() => _EventScreenState();
}

bool isLoading = false;

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0E21),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Center(child: Text('Student Page')),
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
            children: [
              Listofgames(1, "Events", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventScreen(),
                  ),
                );
              }, Icons.task),
              Listofgames(2, "On Duty", () {
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

class _EventScreenState extends State<EventScreen> {
  late Future<List<dynamic>> _data;
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _data = fetchData(user);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: kMatColor),
      home: WillPopScope(
        onWillPop: () => onBackPressed(context, "Are you sure want to exit"),
        child: Scaffold(
          backgroundColor: Color(0xFF0A0E21),
          appBar: AppBar(
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
                          onLongPress: () async {
                            if (await onBackPressed(
                                context, "Are you sure Mark as complete")) {
                              setState(() {
                                isLoading = true;
                              });
                              // print(user!.displayName);
                              await http.post(Uri.parse(
                                  "$kURL/student/update/${user!.email!.substring(0, user!.email!.indexOf("@"))}/${snapshot.data![index]['eventId']}"));
                              setState(() async {
                                isLoading = false;
                                _data = fetchData(user);
                              });
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(16),
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: kPrimaryLightColor,
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                          snapshot.data![index]['fromDate']
                                                  .toString()
                                                  .substring(8, 10) +
                                              snapshot.data![index]['fromDate']
                                                  .toString()
                                                  .substring(4, 7) +
                                              "-" +
                                              snapshot.data![index]['fromDate']
                                                  .toString()
                                                  .substring(2, 4) +
                                              "  " +
                                              timeText(snapshot.data![index]
                                                      ['fromDate']
                                                  .toString()
                                                  .substring(11, 19)),
                                          style: TextStyle(
                                              color: Colors.green.shade300,
                                              fontWeight: FontWeight.bold)),
                                      Text("|",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20)),
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
                                                .substring(2, 4) +
                                            "  " +
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
            if (isLoading) CircularProgressIndicator(color: Colors.red),
          ]),
        ),
      ),
    );
  }

  Future<List<dynamic>> fetchData(User? user) async {
    final response = await http.post(Uri.parse(
        '$kURL/student/get/${user!.email!.substring(0, user.email!.indexOf("@"))}'));
    setState(() {
      isLoading = false;
    });
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse;
    } else {
      throw Exception('Failed to load post');
    }
  }
}
