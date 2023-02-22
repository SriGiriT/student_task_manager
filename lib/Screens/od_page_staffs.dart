import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:student_task_manager/constant.dart';



class Person {
  final int id;
  final String name;
  final String imageUrl;

  Person({required this.id, required this.name, required this.imageUrl});

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
    );
  }
}

class ODStaffScreen extends StatefulWidget {
  @override
  _ODStaffScreenState createState() => _ODStaffScreenState();
}

class _ODStaffScreenState extends State<ODStaffScreen> {
  late List<Person> _persons;

  @override
  void initState() {
    super.initState();
    _fetchPersons();
  }

  Future<void> _fetchPersons() async {
    final response = await http.get(Uri.parse('$kURL/persons'));
    final data = jsonDecode(response.body) as List<dynamic>;
    setState(() {
      _persons = data.map((json) => Person.fromJson(json)).toList();
    });
  }

  void _onPersonClicked(Person person) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => PersonDetailPage(person),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Person List'),
      ),
      body: _persons == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _persons.length,
              itemBuilder: (context, index) {
                final person = _persons[index];
                return ListTile(
                  title: Text(person.name),
                  onTap: () => _onPersonClicked(person),
                );
              },
            ),
    );
  }
}

class PersonDetailPage extends StatelessWidget {
  final Person person;

  PersonDetailPage(this.person);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(person.name),
      ),
      body: Column(
        children: [
          Image.network(person.imageUrl),
          Text(person.name),
        ],
      ),
    );
  }
}
