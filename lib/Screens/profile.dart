import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:student_task_manager/Screens/AddEvent.dart';
import 'package:student_task_manager/Screens/EventScreen.dart';
import 'package:student_task_manager/component/RoundedButton.dart';
import 'package:http/http.dart' as http;
import '../component/google_sign_in.dart';
import '../constant.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
    String accessToken = provider.accessToken;
    String idToken = provider.idToken;
    // GoogleSignInAuthentication auth = GoogleSignInProvider().auth;
    // print(auth.accessToken);
    // print(auth.idToken);
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        actions: [
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
      body: Container(
          alignment: Alignment.center,
          color: Colors.blueGrey.shade900,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Profile',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              SizedBox(
                height: 32,
              ),
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(user!.photoURL!),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'Name: ' + user.displayName!,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'Email: ' + user.email!,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              // Text(
              //   '${auth.accessToken!} ${auth.idToken!}',
              // )
              RoundedButton(
                text: "addEvent",
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return AddEvent();
                      },
                    ),
                  );
                },
              ),
              RoundedButton(
                text: "eventScreen",
                press: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return EventScreen();
                      },
                    ),
                  );
                },
              ),
              RoundedButton(
                text: "eventScreen",
                press: () async {
                  var body = {
                    'accessToken': accessToken.toString(),
                    'idToken': idToken.toString()
                  };
                  print(accessToken + " | " + idToken);
                  http.post(Uri.parse('$kURL/'), body: body);
                },
              ),
            ],
          )),
    );
  }
}
