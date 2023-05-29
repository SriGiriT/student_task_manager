import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

String kURL = "https://tidy-puma-7.telebit.io";
const kPrimaryColor = Color(0xFF1D1E33);
const kPrimaryLightColor = Color(0xFF282E45);
const kButtonColor = Color(0xFF111328);
const kSaveKey = "selected_page111111111";
TextStyle kButtonTextStyle =
    TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold);
Future<bool> onBackPressed(BuildContext context, String text) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(text),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text("No"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text("Yes"),
        ),
      ],
    ),
  ).then((value) => value ?? false);
}

class Description extends StatefulWidget {
  final String descriptionData;
  const Description({required this.descriptionData});

  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            child: Text(widget.descriptionData,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold))));
  }
}

List<String> ab = [];
List<String> od = [];
String to = "";

MaterialColor kMatColor = MaterialColor(
  0xFF0A0E21,
  <int, Color>{
    50: Color(0xFF0A0E21),
    100: Color(0xFF0A0E21),
    200: Color(0xFF0A0E21),
    300: Color(0xFF0A0E21),
    400: Color(0xFF0A0E21),
    500: Color(0xFF0A0E21),
    600: Color(0xFF0A0E21),
    700: Color(0xFF0A0E21),
    800: Color(0xFF0A0E21),
    900: Color(0xFF0A0E21),
  },
);

String timeText(String string) {
  String timeString = "14:30:00";
  DateTime time = DateTime.parse("1970-01-01 $string");

  String formattedTime = DateFormat('h:mm a').format(time);
  return formattedTime;
}

Future<List<dynamic>> fetchData(User? user) async {
  final response = await http.post(Uri.parse(
      '$kURL/teacher/events/pending/${user!.email!.substring(0, user.email!.indexOf("@"))}'));
  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    List jsonResponse = json.decode(response.body);
    return jsonResponse;
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class Listofgames extends StatelessWidget {
  Listofgames(this.ind, this.text, this.pressed, this.img);
  String text;
  int ind;
  void Function()? pressed;
  IconData img;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: pressed,
        child: Container(
          decoration: BoxDecoration(
              color: Color(0xFF1D1E33),
              border: Border.all(
                color: Color(0xFF1D1E33),
              ),
              borderRadius: BorderRadius.circular(10.0)),
          height: 20,
          width: 20,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                img,
                size: 34,
                color: Colors.white,
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                text,
                style: TextStyle(color: Colors.white, fontSize: 24),
              )
            ],
          ),
        ),
      ),
    );
  }
}

const kPrimaryConstColor = Color(0xFF0A0E21);
