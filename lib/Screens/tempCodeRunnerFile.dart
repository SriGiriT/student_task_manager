import 'package:flutter/material.dart';

class ODScreenStaff extends StatefulWidget {
  const ODScreenStaff({super.key});

  @override
  State<ODScreenStaff> createState() => _ODScreenStaffState();
}

class _ODScreenStaffState extends State<ODScreenStaff> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Center(child: Text("On Duty", style: TextStyle(fontSize: 40),)),);
  }
}