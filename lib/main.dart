import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'variables.dart';
import 'contact.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  await Hive.initFlutter();
  var box = await Hive.openBox('database');
  runApp(CupertinoApp(
    theme: CupertinoThemeData(brightness: Brightness.dark),
    debugShowCheckedModeBanner: false,
    home: Homepage(),
  ));
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  var box = Hive.box('database');
  List<dynamic> contacts = [];
  List<TextEditingController> _phoneControllers = [];
  List<TextEditingController> _emailControllers = [];
  List<TextEditingController> _urlControllers = [];

  @override
  void initState() {
    super.initState();
    if (box.get('contacts') == null) {
      print('empty list');
    } else {
      setState(() {
        contacts = box.get('contacts');
        print(contacts);
      });
    }
  }

  TextEditingController _fname = TextEditingController();
  TextEditingController _lname = TextEditingController();
