import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:student_task_manager/component/google_sign_in.dart';

import '../../constant.dart';

bool isLoading = false;

class ODListScreen extends StatefulWidget {
  @override
  _ODListScreenState createState() => _ODListScreenState();
}

class _ODListScreenState extends State<ODListScreen> {
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
      theme: ThemeData(primarySwatch: kMatColor),
      debugShowCheckedModeBanner: false,
      home: WillPopScope(
        onWillPop: () => onBackPressed(context, "Are you sure want to exit"),
        child: Scaffold(
          backgroundColor: kMatColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            leading: GestureDetector(
              child: const Icon(
                Icons.refresh,
              ),
              onTap: () {
                setState(() {
                  _data = fetchData(user);
                });
              },
            ),
            title: const Center(child: Text('OD list')),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    final provider = Provider.of<GoogleSignInProvider>(context,
                        listen: false);
                    provider.logout();
                  },
                  child: const Text(
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
                            setState(() {
                              isLoading = true;
                            });
                            if (await onBackPressed(
                                context, "Are you sure want to cancel OD")) {
                              final response = await http.post(Uri.parse(
                                  '$kURL/od/cancel/${snapshot.data![index]['id']}/${user!.email!.substring(0, user!.email!.indexOf("@"))}'));
                              // print(response.body);
                              if (response.statusCode == 200) {
                                // If the call to the server was successful, parse the JSON
                                print("removed od");
                              } else {
                                // If that call was not successful, throw an error.
                                throw Exception('404 Error');
                              }
                            }
                            _data = fetchData(user);
                            setState(() {
                              isLoading = false;
                            });
                          },
                          onTap: () async {
                            setState(() {
                              isLoading = true;
                            });

                            setState(() {
                              isLoading = false;
                            });
                            String studentSet = "";
                            for (String x in snapshot.data![index]
                                ['studentSet']) {
                              studentSet += x + ", ";
                            }
                            // for (Map<String, dynamic> x in snapshot.data![index]
                            //     ['studentSet']) {
                            //   x.forEach((key, value) {
                            //     if (key == "rollNo") studentSet += value + ", ";
                            //   });
                            // }
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => SingleChildScrollView(
                                child: Container(
                                  width: 500,
                                  height: 500,
                                  child: OdDetails(
                                    studentId: snapshot.data![index]
                                            ['studentSet'][0]
                                        .toString(),
                                    // studentName: snapshot.data![index]
                                    //         ['studentSet'][0]
                                    //     .toString(),
                                    description: snapshot.data![index]
                                        ['description'],
                                    documentImg: (snapshot.data![index]
                                                ['document'] !=
                                            null)
                                        ? snapshot.data![index]['document']
                                            ['data']
                                        : "",
                                    studentList: studentSet,
                                    fromDate: snapshot.data![index]['fromDate'],
                                    endDate: snapshot.data![index]['endDate'],
                                  ),
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
                              border: Border.all(
                                  width: 4,
                                  color: snapshot.data![index]['canceledBy'] != null
                                               && snapshot.data![index]['canceledBy'].length > 1
                                      ? Colors.red.shade300
                                      : (snapshot.data![index]['signatures'] != null && snapshot.data![index]['signatures'].length > 0
                                                  )
                                          ? Colors.green.shade300
                                          : Colors.grey.shade200),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // crossAxisAlignment: CrossAxisAlignment.,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          "${snapshot.data![index]['studentSet'][0].toString()}",
                                          style: TextStyle(
                                              color: Colors.orange.shade300,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                      // Text(
                                      //   snapshot.data![index]['id'].toString(),
                                      //   style: const TextStyle(
                                      //       color: Colors.white,
                                      //       fontSize: 20,
                                      //       fontWeight: FontWeight.bold),
                                      // ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      snapshot.data![index]['description'],
                                      style: const TextStyle(
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
                                      const Text("|",
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
            if (isLoading)
              CircularProgressIndicator(
                color: Colors.red,
              )
          ]),
        ),
      ),
    );
  }

  Future<List<dynamic>> fetchData(User? user) async {
    final response = await http.post(Uri.parse(
        '$kURL/od/list/${user!.email!.substring(0, user.email!.indexOf("@"))}'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse;
    } else {
      throw Exception('404 Error');
    }
  }
}

class OdDetails extends StatefulWidget {
  String studentId;
  String? documentImg;
  String description;
  String fromDate;
  String endDate;
  String studentList;
  OdDetails(
      {required this.studentId,
      required this.documentImg,
      required this.description,
      required this.fromDate,
      required this.endDate,
      required this.studentList});

  @override
  _OdDetailsState createState() => _OdDetailsState();
}

class _OdDetailsState extends State<OdDetails> {
  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF0A0E21),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Color(0xFF0A0E21),
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.studentId,
                        style: TextStyle(
                            color: Colors.green.shade300,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    widget.description,
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    widget.studentList
                        .substring(0, widget.studentList.length - 2),
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          widget.fromDate.toString().substring(8, 10) +
                              widget.fromDate.toString().substring(4, 7) +
                              "-" +
                              widget.fromDate.toString().substring(2, 4) +
                              "  " +
                              timeText(
                                  widget.fromDate.toString().substring(11, 19)),
                          style: TextStyle(
                              color: Colors.green.shade300,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                      Text("|",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24)),
                      Text(
                        widget.endDate.toString().substring(8, 10) +
                            widget.endDate.toString().substring(4, 7) +
                            "-" +
                            widget.endDate.toString().substring(2, 4) +
                            "  " +
                            timeText(
                              widget.endDate.toString().substring(11, 19),
                            ),
                        style: TextStyle(
                            color: Colors.red.shade300,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ],
                  ),
                  widget.documentImg != ""
                      ? Container(
                          child: Image.memory(
                            base64Decode(widget.documentImg!),
                            height: 400,
                            width: 400,
                          ),
                        )
                      : Container(),
                  // // TextField(controller: textEditingController,),
                  // Text(
                  //   widget.documentImg!.substring(40),
                  //   style: TextStyle(color: Colors.white),
                  // ),
                  SizedBox(height: 8),
                  // if (widget.documentImg != null)
                  //   Image(
                  //       image: Image.memory(base64
                  //               .decode(widget.documentImg!.substring(40)))
                  //           .image)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
