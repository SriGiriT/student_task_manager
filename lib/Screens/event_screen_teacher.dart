import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:student_task_manager/Screens/AddEvent.dart';
import 'package:student_task_manager/component/google_sign_in.dart';
import 'package:student_task_manager/constant.dart';

class EventScreenTeacher extends StatefulWidget {
  @override
  _EventScreenTeacherState createState() => _EventScreenTeacherState();
}

class _EventScreenTeacherState extends State<EventScreenTeacher> {
  late Future<List<dynamic>> _data;

  @override
  void initState() {
    super.initState();
    _data = fetchData();
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
                _data = fetchData();
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
                            ElevatedButton(
                              onPressed: () async {
                                if (await onBackPressed(
                                    context, "Are you sure Mark as complete")) {
                                  setState(() {
                                    _data = fetchData();
                                    http.post(Uri.parse(
                                        "$kURL/event/update/20eucs147/${snapshot.data![index]['eventId']}"));
                                  });
                                }
                              },
                              child: Text("view report"),
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
            child: Icon(Icons.add, color: Colors.white,),
          ),
        ),
      ),
    );
  }

  Future<List<dynamic>> fetchData() async {
    final response = await http.post(Uri.parse('$kURL/event/get/20eucs147'));
    print(response.body);
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