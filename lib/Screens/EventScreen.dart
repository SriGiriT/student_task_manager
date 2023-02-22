import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:student_task_manager/component/google_sign_in.dart';
import 'package:student_task_manager/constant.dart';

class EventScreen extends StatefulWidget {
  @override
  _EventScreenState createState() => _EventScreenState();
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
                      return GestureDetector(
                        onTap: () {
                          snapshot.data![index].runtimeType;
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => SingleChildScrollView(
                              child: Container(
                                width: 500,
                                height: 500,
                                color: Color(0xFF0A0E21),
                                child: Description(
                                    descriptionData: snapshot.data![index]
                                        ['description']),
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                              ),
                            ),
                          );
                        },
                        child: Container(
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
                              Row(
                                children: [
                                  Text(
                                      (snapshot.data![index]['eventId']
                                              .toString()) +
                                          " ",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                    snapshot.data![index]['title'],
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  if (await onBackPressed(context,
                                      "Are you sure Mark as complete")) {
                                    setState(() {
                                      _data = fetchData(user);
                                      print(user!.displayName);
                                      http.post(Uri.parse(
                                          "$kURL/student/update/${user!.email!.substring(0, user!.email!.indexOf("@"))}/${snapshot.data![index]['eventId']}"));
                                    });
                                  }
                                },
                                child: Text("Mark as done"),
                              ),
                              // Text("Mark as done"),
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
        ),
      ),
    );
  }

  Future<List<dynamic>> fetchData(User? user) async {
    final response = await http.post(Uri.parse(
        '$kURL/student/get/${user!.email!.substring(0, user.email!.indexOf("@"))}'));
    print('${user.email!.substring(0, user.email!.indexOf("@"))}');
    // print(user!.displayName);
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
