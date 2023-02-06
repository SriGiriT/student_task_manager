import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

String kURL = "https://tidy-puma-7.telebit.io";
const kPrimaryColor = Colors.blue;
const kPrimaryLightColor = Color.fromARGB(255, 255, 166, 51);
const kButtonColor = Colors.black12;
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
    return Center(child: Container(child: Text(widget.descriptionData)));
  }
}