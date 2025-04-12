import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'variables.dart';
import 'contact.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_flutter/adapters.dart';

void main() async{
  await Hive.initFlutter();
  var box =  await Hive.openBox('database');
  runApp(CupertinoApp(
    theme: CupertinoThemeData(
        brightness: Brightness.dark
    ),
    debugShowCheckedModeBanner: false,
    home: Homepage(),));

}