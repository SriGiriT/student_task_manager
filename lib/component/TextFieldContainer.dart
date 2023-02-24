import 'package:flutter/material.dart';
import 'package:student_task_manager/constant.dart';

class TextFieldContainer extends StatefulWidget {
  final Widget child;
  final double width;
  final bool isLis;
  final bool isDescription;
  const TextFieldContainer(
      {required this.child, required this.width, required this.isDescription, required this.isLis});

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
      height: widget.isDescription ? widget.isLis?100 : 200 : 50,
      width: size.width * widget.width,
      decoration: BoxDecoration(
        color: kPrimaryLightColor,
        borderRadius: BorderRadius.circular(29),
      ),
      child: widget.child,
    );
  }
}
