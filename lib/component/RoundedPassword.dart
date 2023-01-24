import 'package:flutter/material.dart';
import 'package:student_task_manager/component/TextFieldContainer.dart';
import 'package:student_task_manager/constant.dart';

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
    final double times;
  const RoundedPasswordField({
    required this.onChanged,
    required this.times
  });

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      width: times,
      child: TextField(
        obscureText: true,
        onChanged: onChanged,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          hintText: "Password",
          icon: Icon(
            Icons.lock,
            color: kPrimaryColor,
          ),
          suffixIcon: Icon(
            Icons.visibility,
            color: kPrimaryColor,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}