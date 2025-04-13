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
 void _removeEmail(int index) {
    setState(() {
      _emails.removeAt(index);
    });
  }

  void _addURL() {
    setState(() {
      _urls.add(_URLEntry(type: 'home', urlController: TextEditingController()));
    });
  }

  void _removeURL(int index) {
    setState(() {
      _urls.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Edit Contact'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text('Done', style: TextStyle(fontWeight: FontWeight.bold)),
          onPressed: () {
            List<String> phoneNumbers = _phoneNumbers.map((e) => e.numberController.text).toList();
            List<String> emails = _emails.map((e) => e.emailController.text).toList();
            List<String> urls = _urls.map((e) => e.urlController.text).toList();

            Navigator.pop(context, {
              'name': _firstNameController.text,
              'phoneNumbers': phoneNumbers,
              'emails': emails,
              'urls': urls,
            });
          },
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  // TODO: Change photo logic
                  print('Change photo');
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(photo ?? ''), // Handle potential null
                      backgroundColor: CupertinoColors.lightBackgroundGray,
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: CupertinoColors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Edit',
                          style: TextStyle(color: CupertinoColors.white, fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              _cupertinoField(_firstNameController, 'First Name'), // Changed placeholder
              SizedBox(height: 15),
              _cupertinoField(_lastNameController, 'Last Name'), // Changed placeholder
              SizedBox(height: 20),
              ..._phoneNumbers.asMap().entries.map((entry) => _buildPhoneNumberField(entry.key, entry.value)).toList(),
              _addButton('add phone', _addPhoneNumber),
              SizedBox(height: 15),
              ..._emails.asMap().entries.map((entry) => _buildEmailField(entry.key, entry.value)).toList(),
              _addButton('add email', _addEmail),
              SizedBox(height: 15),
              ..._urls.asMap().entries.map((entry) => _buildURLField(entry.key, entry.value)).toList(),
              _addButton('add URL', _addURL),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
 Widget _cupertinoField(TextEditingController controller, String placeholder) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CupertinoTextField(
        controller: controller,
        placeholder: placeholder,
        clearButtonMode: OverlayVisibilityMode.editing,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: CupertinoColors.secondarySystemBackground,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _addButton(String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CupertinoButton(
        padding: EdgeInsets.all(15),
        color: CupertinoColors.secondarySystemBackground,
        borderRadius: BorderRadius.circular(8),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(CupertinoIcons.add_circled_solid, color: CupertinoColors.systemGreen),
            SizedBox(width: 10),
            Text(label, style: TextStyle(color: CupertinoColors.systemGreen)),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneNumberField(int index, _PhoneEntry entry) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: Row(
              children: [
                if (index > 0)
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => _removePhoneNumber(index),
                    child: Icon(CupertinoIcons.minus_circled, color: CupertinoColors.systemRed),
                  ),
                SizedBox(width: 5),
                Text('${entry.type} >', style: TextStyle(color: CupertinoColors.systemGrey)),
              ],
            ),
            onPressed: () {},
          ),
          SizedBox(width: 10),
          Expanded(
            child: CupertinoTextField(
              controller: entry.numberController,
              placeholder: '(0906) 849 5385',
              keyboardType: TextInputType.phone,
              clearButtonMode: OverlayVisibilityMode.editing,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: CupertinoColors.secondarySystemBackground,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
if (index == 0 && _phoneNumbers.length > 1)
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => _removePhoneNumber(index),
              child: Icon(CupertinoIcons.minus_circled, color: CupertinoColors.systemRed),
            ),
        ],
      ),
    );
  }

  Widget _buildEmailField(int index, _EmailEntry entry) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: Row(
              children: [
                if (index > 0)
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => _removeEmail(index),
                    child: Icon(CupertinoIcons.minus_circled, color: CupertinoColors.systemRed),
                  ),
                SizedBox(width: 5),
                Text('${entry.type} >', style: TextStyle(color: CupertinoColors.systemGrey)),
              ],
            ),
            onPressed: () {},
          ),
          SizedBox(width: 10),
          Expanded(
            child: CupertinoTextField(
              controller: entry.emailController,
              placeholder: 'example@email.com',
              keyboardType: TextInputType.emailAddress,
              clearButtonMode: OverlayVisibilityMode.editing,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: CupertinoColors.secondarySystemBackground,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildURLField(int index, _URLEntry entry) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: Row(
              children: [
                if (index > 0)
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => _removeURL(index),
                    child: Icon(CupertinoIcons.minus_circled, color: CupertinoColors.systemRed),
                  ),
                SizedBox(width: 5),
                Text('${entry.type} >', style: TextStyle(color: CupertinoColors.systemGrey)),
              ],
            ),
            onPressed: () {},
          ),
          SizedBox(width: 10),
          Expanded(
            child: CupertinoTextField(
              controller: entry.urlController,
              placeholder: 'https://example.com',
              keyboardType: TextInputType.url,
              clearButtonMode: OverlayVisibilityMode.editing,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: CupertinoColors.secondarySystemBackground,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhoneEntry {
  String type;
  TextEditingController numberController;

  _PhoneEntry({required this.type, required this.numberController});
}

class _EmailEntry {
  String type;
  TextEditingController emailController;

  _EmailEntry({required this.type, required this.emailController});
}

class _URLEntry {
  String type;
  TextEditingController urlController;

  _URLEntry({required this.type, required this.urlController});
}