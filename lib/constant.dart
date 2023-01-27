import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

String kURL = "http://localhost/8080";
const kPrimaryColor = Colors.blue;
const kPrimaryLightColor = Color.fromARGB(252, 255, 175, 95);
const kButtonColor = Colors.black12;
Future<bool> onBackPressed(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Do you really want to Mark as done?"),
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
