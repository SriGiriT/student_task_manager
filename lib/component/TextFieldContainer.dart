import 'package:flutter/material.dart';
import 'package:student_task_manager/constant.dart';

class TextFieldContainer extends StatefulWidget {
  final Widget child;
  final double width;
  const TextFieldContainer({
    required this.child,
    required this.width
  });

  @override
  State<TextFieldContainer> createState() => _TextFieldContainerState();
}

class _TextFieldContainerState extends State<TextFieldContainer> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * widget.width,
      decoration: BoxDecoration(
        color: kPrimaryLightColor,
        borderRadius: BorderRadius.circular(29),
      ),
      child: widget.child,
    );
  }
}
