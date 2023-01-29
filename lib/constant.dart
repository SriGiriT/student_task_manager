import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

String kURL = "https://5f96-103-114-211-140.in.ngrok.io";
const kPrimaryColor = Colors.blue;
const kPrimaryLightColor = Color.fromARGB(252, 255, 175, 95);
const kButtonColor = Colors.black12;
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
