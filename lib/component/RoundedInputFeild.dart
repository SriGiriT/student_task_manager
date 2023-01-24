import 'package:flutter/material.dart';
import 'package:student_task_manager/constant.dart';
import 'package:student_task_manager/component/TextFieldContainer.dart';

class RoundedInputField extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final VoidCallback onTap;
  final double times;
  const RoundedInputField(
      {required this.hintText,
      required this.onTap,
      required this.icon,
      required this.onChanged,
      required this.times});

  @override
  State<RoundedInputField> createState() => _RoundedInputFieldState();
}

class _RoundedInputFieldState extends State<RoundedInputField> {
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      width: widget.times,
      child: TextField(
        onTap: widget.onTap,
          // widget.onChanged;
        onChanged: widget.onChanged,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          icon: Icon(
            widget.icon,
            color: kPrimaryColor,
          ),
          hintText: widget.hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
