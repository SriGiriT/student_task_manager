import 'dart:convert';

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
                            Column(children: [
                              Text(snapshot.data![index]['eventId'].toString(),
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(snapshot.data![index]['description']),
                            ],),
                            ElevatedButton(onPressed: () async{
                              if(await onBackPressed(context, "Are you sure Mark as complete")){
                              setState(() {
                                  _data = fetchData();
                                  http.post(
                                    Uri.parse(
                                        "$kURL/student/update/20eucs147/${snapshot.data![index]['eventId']}")
                                  );
                                }
                                );
                    }}, child: Text("Mark as done"),),
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
        ),
      ),
    );
  }

  Future<List<dynamic>> fetchData() async {
    final response = await http.post(Uri.parse(
        '$kURL/student/get/20eucs147'));
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


