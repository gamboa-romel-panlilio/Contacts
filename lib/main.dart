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
 void _filterContacts() {
    if (_searchController.text.isEmpty) {
      setState(() {
        filteredContacts = List.from(contacts);
        _isSearching = false;
      });
    } else {
      setState(() {
        _isSearching = true;
        filteredContacts = contacts.where((contact) {
          return contact["name"].toLowerCase().contains(_searchController.text.toLowerCase()) ||
              (contact["phone"] != null && contact["phone"].toLowerCase().contains(_searchController.text.toLowerCase())) ||
              (contact["email"] != null && contact["email"].toLowerCase().contains(_searchController.text.toLowerCase()));
        }).toList();
      });
    }
  }

  void _deleteContact(int index) {
    int actualIndex = contacts.indexOf(filteredContacts[index]);
    if (actualIndex != -1) {
      setState(() {
        contacts.removeAt(actualIndex);
        filteredContacts.removeAt(index);
        _myBox.put('contacts', contacts);
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 75, // Reduce quality to save storage space
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          // Convert image to base64 string for storage
          _selectedImageBase64 = base64Encode(bytes);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  // Method to get image widget from base64 string
  Widget _getImageWidget(String? base64String) {
    if (base64String != null && base64String.isNotEmpty) {
      try {
        return Image.memory(
          base64Decode(base64String),
          fit: BoxFit.cover,
          width: 200,
          height: 200,
        );
      } catch (e) {
        print('Error decoding image: $e');
      }
    }

    // Return default icon if no image or error
    return Icon(
      CupertinoIcons.person_circle_fill,
      color: CupertinoColors.systemGrey,
      size: 200,
    );
  }

  TextEditingController _fname = TextEditingController();
  TextEditingController _lname = TextEditingController();
  TextEditingController _company = TextEditingController();
  TextEditingController _url = TextEditingController();

  // List to store phone fields with their labels
  List<PhoneField> _phoneFields = [PhoneField()];
  // List to store email fields with their labels
  List<EmailField> _emailFields = [EmailField()];

  void _addPhoneField() {
    setState(() {
      _phoneFields.add(PhoneField());
    });
  }

  void _addEmailField() {
    setState(() {
      _emailFields.add(EmailField());
    });
  }

  // List of available phone labels
  final List<String> _phoneLabels = ['mobile', 'home', 'work', 'school', 'iPhone', 'Apple Watch', 'main', 'home fax', 'work fax', 'pager', 'other'];
  // List of available email labels
  final List<String> _emailLabels = ['home', 'work', 'school', 'iCloud', 'other'];

  void _openContactSheet({Map<String, dynamic>? contactToEdit, int? editIndex}) {
    // Reset or fill with contact data
    if (contactToEdit != null) {
      _fname.text = contactToEdit['name'].split(" ")[0] ?? "";
      _lname.text = contactToEdit['name'].split(" ").length > 1 ? contactToEdit['name'].split(" ")[1] : "";
      _company.text = contactToEdit['company'] ?? "";
      _url.text = contactToEdit['url'] ?? "";
      _selectedImageBase64 = contactToEdit['isBase64'] ? contactToEdit['photo'] : null;

      // Setup phone fields
      _phoneFields.clear();
      if (contactToEdit['phoneNumbers'] != null && contactToEdit['phoneNumbers'].isNotEmpty) {
        for (var phone in contactToEdit['phoneNumbers']) {
          PhoneField field = PhoneField(initialLabel: phone['label']);
          field.controller.text = phone['number'];
          _phoneFields.add(field);
        }
      } else {
        _phoneFields.add(PhoneField());
      }

      // Setup email fields
      _emailFields.clear();
      if (contactToEdit['emailAddresses'] != null && contactToEdit['emailAddresses'].isNotEmpty) {
        for (var email in contactToEdit['emailAddresses']) {
          EmailField field = EmailField(initialLabel: email['label']);
          field.controller.text = email['email'];
          _emailFields.add(field);
        }
      } else {
        _emailFields.add(EmailField());
      }
    } else {
      // Reset for new contact
      _selectedImageBase64 = null;
      _phoneFields = [PhoneField()];
      _emailFields = [EmailField()];
      _fname.clear();
      _lname.clear();
      _company.clear();
      _url.clear();
    }

    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CupertinoButton(
                child: Text('Cancel', style: TextStyle(color: CupertinoColors.activeBlue)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Text(contactToEdit != null ? 'Edit Contact' : 'New Contact', style: TextStyle(fontWeight: FontWeight.bold)),
              CupertinoButton(
                child: Text('Done', style: TextStyle(color: CupertinoColors.activeBlue)),
                onPressed: () {
                  // Collect all phone numbers with their labels
                  List<Map<String, dynamic>> phoneNumbers = [];
                  for (var field in _phoneFields) {
                    if (field.controller.text.isNotEmpty) {
                      phoneNumbers.add({
                        'label': field.label,
                        'number': field.controller.text
                      });
                    }
                  }
