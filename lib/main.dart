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
 @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        trailing: CupertinoButton(
            child: Icon(CupertinoIcons.add),
            onPressed: () {
              showCupertinoModalPopup(
                  context: context,
                  builder: (context) {
                    return CupertinoPageScaffold(
                      navigationBar: CupertinoNavigationBar(
                        middle: Text('New Contact'),
                        leading: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        trailing: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: Text('Done'),
                            onPressed: () {
                              List<String> phoneNumbers = _phoneControllers
                                  .map((controller) => controller.text)
                                  .where((text) => text.isNotEmpty)
                                  .toList();

                              List<String> emails = _emailControllers
                                  .map((controller) => controller.text)
                                  .where((text) => text.isNotEmpty)
                                  .toList();

                              List<String> urls = _urlControllers
                                  .map((controller) => controller.text)
                                  .where((text) => text.isNotEmpty)
                                  .toList();

                              String contactName = "";
                              if (_fname.text.isNotEmpty && _lname.text.isNotEmpty) {
                                contactName = "${_fname.text} ${_lname.text}";
                              } else if (_fname.text.isNotEmpty) {
                                contactName = _fname.text;
                              } else if (_lname.text.isNotEmpty) {
                                contactName = _lname.text;
                              } else if (phoneNumbers.isNotEmpty) {
                                contactName = phoneNumbers.first;
                              }
