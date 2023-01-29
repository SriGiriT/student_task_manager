
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_task_manager/component/RoundedButton.dart';
import 'package:student_task_manager/constant.dart';
import '../component/google_sign_in.dart';

String selectedField = "Student";

class WelcomeScreenSignUp extends StatelessWidget {
  const WelcomeScreenSignUp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text(
              "STM",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 48,
                color: Color.fromARGB(255, 250, 175, 45),
              ),
            ),
            // SizedBox(height: MediaQuery.of(context).size.height * 0.4),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            RoundedButton(
              sizee: 0.6,
              text: "LOGIN with Google",
              color: kButtonColor,
              press: () async {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.googleLogin(selectedField);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    required this.child,
  });
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/hp2.png"),
          fit: BoxFit.cover,
        ),
      ),
      height: size.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              "assets/images/main_top.png",
              width: size.width * 0.3,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              "assets/images/main_bottom.png",
              width: size.width * 0.2,
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class GenderRadioButton extends StatefulWidget {
  @override
  _GenderRadioButtonState createState() => _GenderRadioButtonState();
}

class _GenderRadioButtonState extends State<GenderRadioButton> {

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Radio(
          value: 'Teacher',
          groupValue: selectedField,
          onChanged: (value) {
            setState(() {
              selectedField = value!;
            });
          },
        ),
        Text("Teacher"),
        Text(
          "   | ",
          style: TextStyle(fontSize: 30),
        ),
        Radio(
          value: 'Student',
          groupValue: selectedField,
          onChanged: (value) {
            setState(() {
              selectedField = value!;
            });
          },
        ),
        Text("Student"),
      ],
    );
  }
}
