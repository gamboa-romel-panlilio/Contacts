import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'variables.dart'; // Your shared data (like name, phone, email, photo, etc.)

class EditContact extends StatefulWidget {
  const EditContact({super.key});

  @override
  State<EditContact> createState() => _EditContactState();
}

class _EditContactState extends State<EditContact> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  List<_PhoneEntry> _phoneNumbers = [];
  List<_EmailEntry> _emails = [];
  List<_URLEntry> _urls = [];

  @override
  void initState() {
    super.initState();
    _firstNameController.text = name ?? '';
    _lastNameController.text = ''; // Initialize as empty
    if (phone != null) {
      _phoneNumbers.add(
        _PhoneEntry(
          type: 'mobile',
          numberController: TextEditingController(text: phone),
        ),
      );
    } else {
      _phoneNumbers.add(
        _PhoneEntry(
          type: 'mobile',
          numberController: TextEditingController(),
        ),
      );
    }
    if (email != null) {
      _emails.add(
        _EmailEntry(
          type: 'home',
          emailController: TextEditingController(text: email),
        ),
      );
    } else {
      _emails.add(
        _EmailEntry(
          type: 'home',
          emailController: TextEditingController(),
        ),
      );
    }
    if (url != null) {
      _urls.add(
        _URLEntry(
          type: 'home',
          urlController: TextEditingController(text: url),
        ),
      );
    } else {
      _urls.add(
        _URLEntry(
          type: 'home',
          urlController: TextEditingController(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    for (var p in _phoneNumbers) {
      p.numberController.dispose();
    }
    for (var e in _emails) {
      e.emailController.dispose();
    }
    for (var u in _urls) {
      u.urlController.dispose();
    }
    super.dispose();
  }

  void _addPhoneNumber() {
    if (_phoneNumbers.length >= 5) return;
    setState(() {
      _phoneNumbers.add(_PhoneEntry(type: 'mobile', numberController: TextEditingController()));
    });
  }

  void _removePhoneNumber(int index) {
    setState(() {
      _phoneNumbers.removeAt(index);
    });
  }

  void _addEmail() {
    setState(() {
      _emails.add(_EmailEntry(type: 'home', emailController: TextEditingController()));
    });
  }
