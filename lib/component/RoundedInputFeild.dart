import 'package:flutter/material.dart';
import 'package:student_task_manager/constant.dart';
import 'package:student_task_manager/component/TextFieldContainer.dart';

class RoundedInputField extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final VoidCallback onTap;
  final bool isDes;
  final double times;
  const RoundedInputField(
      {required this.hintText,
      required this.onTap,
      required this.icon,
      required this.onChanged,
      required this.times,
      required this.isDes});

  @override
  State<RoundedInputField> createState() => _RoundedInputFieldState();
}

class _RoundedInputFieldState extends State<RoundedInputField> {
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      width: widget.times,
      isDescription: widget.isDes,
      child: TextField(
        style: kButtonTextStyle,
        onTap: widget.onTap,
        // widget.onChanged;
        onChanged: widget.onChanged,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: Colors.white),
          icon: Icon(
            widget.icon,
            color: kPrimaryLightColor,
          ),
          hintText: widget.hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
