import 'package:flutter/material.dart';
import 'package:student_task_manager/constant.dart';

class StaffTimetable extends StatelessWidget {
  final Map<String, dynamic> timetable;

  StaffTimetable({required this.timetable});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(timetable['staff']['name'] + "'s Timetable"),
      ),
      body: Container(
        color: kMatColor,
        child: Column(
          children: [
            Container(
              color: kPrimaryLightColor,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('Period', style: TextStyle(color: Colors.white, fontSize: 24),)),
                      DataColumn(label: Text('Monday', style: TextStyle(color: Colors.white, fontSize: 24),)),
                      DataColumn(label: Text('Tuesday', style: TextStyle(color: Colors.white, fontSize: 24),)),
                      DataColumn(label: Text('Wednesday', style: TextStyle(color: Colors.white, fontSize: 24),)),
                      DataColumn(label: Text('Thursday', style: TextStyle(color: Colors.white, fontSize: 24),)),
                      DataColumn(label: Text('Friday', style: TextStyle(color: Colors.white, fontSize: 24),)),
                    ],
                    rows: List.generate(
                      7,
                      (period) => DataRow(
                        cells: [
                          DataCell(Text('Period ${period + 1}', style: TextStyle(color: Colors.white, fontSize: 24),)),
                          DataCell(Text(timetable['dayOne'][period], style: TextStyle(color: Colors.white, fontSize: 24),)),
                          DataCell(Text(timetable['dayTwo'][period], style: TextStyle(color: Colors.white, fontSize: 24),)),
                          DataCell(Text(timetable['dayThree'][period], style: TextStyle(color: Colors.white, fontSize: 24),)),
                          DataCell(Text(timetable['dayFour'][period], style: TextStyle(color: Colors.white, fontSize: 24),)),
                          DataCell(Text(timetable['dayFive'][period], style: TextStyle(color: Colors.white, fontSize: 24),)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}