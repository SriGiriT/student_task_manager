import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';



class Nyapp extends StatefulWidget {
  const Nyapp({super.key});

  @override
  State<Nyapp> createState() => _NyappState();
}

class _NyappState extends State<Nyapp> {
  _launchWhatsApp(String phone) async {
  String url = "whatsapp://send?phone=$phone";
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

  @override
  Widget build(BuildContext context) {
    return Container(child: ElevatedButton(
  onPressed: () => launch("whatsapp://send?phone=+919865390370"),
  child:Icon( Icons.whatsapp),
)
,);
  }
}