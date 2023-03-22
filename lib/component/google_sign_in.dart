import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:student_task_manager/constant.dart';
import 'package:http/http.dart' as http;

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;
  GoogleSignInAuthentication? _auth;
  GoogleSignInAccount get user => _user!;
  GoogleSignInAuthentication get auth => _auth!;
  String accessToken = "";
  String idToken = "";
  String get getAccessToken => accessToken;
  String get getIdToken => idToken;
  Future googleLogin(String field) async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;
      _user = googleUser;
      final googleAuth = await googleUser.authentication;
      accessToken = googleAuth.accessToken!;
      idToken = googleAuth.idToken!;
      _auth = googleAuth;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      await FirebaseAuth.instance.signInWithCredential(credential);
      var body = {"token": to};
      http.post(Uri.parse('$kURL/login/${googleUser.email}/${to}'), body: body);
      // print('$kURL/login/${googleUser.email}/${to}');
      
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  Future logout() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}
