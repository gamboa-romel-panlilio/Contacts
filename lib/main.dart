import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'variables.dart';
import 'contact.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('database'); // Ensure the box is opened in main
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

class PhoneField {
  TextEditingController controller = TextEditingController();
  String label = 'mobile'; // Default label

  PhoneField({String initialLabel = 'mobile'}) {
    this.label = initialLabel;
  }
}

class EmailField {
  TextEditingController controller = TextEditingController();
  String label = 'home'; // Default label

  EmailField({String initialLabel = 'home'}) {
    this.label = initialLabel;
  }
}

class _HomepageState extends State<Homepage> {
  late Box<dynamic> _myBox; // Declare a late variable for the box
  List<dynamic> contacts = [];
  List<dynamic> filteredContacts = [];
  final ImagePicker _picker = ImagePicker();
  String? _selectedImageBase64;
  TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _openBoxAndLoadData(); // Call a function to handle box opening and data loading
    _searchController.addListener(_filterContacts);
  }

  Future<void> _openBoxAndLoadData() async {
    _myBox = Hive.box('database'); // Get the already opened box
    _loadContacts();
  }

  void _loadContacts() {
    if (_myBox.get('contacts') == null) {
      print('empty list');
    } else {
      setState(() {
        contacts = _myBox.get('contacts');
        filteredContacts = List.from(contacts);
        print(contacts);
      });
    }
  }
