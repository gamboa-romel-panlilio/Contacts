import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'variables.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'edit_contact.dart';

class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  List<String> _phoneNumbers = [];
  List<String> _emails = [];
  List<String> _urls = [];
  String _name = name;

  @override
  void initState() {
    super.initState();
    _loadInitialContactData();
  }

  Future<void> _loadInitialContactData() async {
    setState(() {
      _phoneNumbers = [phone ?? ''];
      _emails = [email ?? ''];
      _urls = [url ?? ''];
      _name = name ?? '';
    });
  }

  Future<void> _navigateToEditContact(BuildContext context) async {
    final result = await Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => const EditContact()),
    );

    if (result != null && result is Map<String, dynamic>) {
      print('Phone Numbers from Edit: ${result['phoneNumbers']}');
      print('Emails from Edit: ${result['emails']}');
      print('URLs from Edit: ${result['urls']}');

      setState(() {
        _phoneNumbers = (result['phoneNumbers'] as List?)?.cast<String>() ?? [];
        _emails = (result['emails'] as List?)?.cast<String>() ?? [];
        _urls = (result['urls'] as List?)?.cast<String>() ?? [];
        _name = result['name'] as String? ?? _name;

        // Update global vars if needed (consider if this is the best approach)
        if (_name != null) name = _name;
        if (_phoneNumbers.isNotEmpty) phone = _phoneNumbers.first;
        if (_emails.isNotEmpty) email = _emails.first;
        if (_urls.isNotEmpty) url = _urls.first;
      });

      // ✅ Save updated data to Hive
      var box = Hive.box('contacts');
      await box.put('currentContact', {
        'name': _name,
        'phoneNumbers': _phoneNumbers,
        'emails': _emails,
        'urls': _urls,
        'photo': photo,
      });
    }
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(icon, color: CupertinoColors.white),
            onPressed: onPressed,
          ),
          Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300))
        ],
      ),
    );
  }

  Widget _buildContactDetailItem({
    required String label,
    required List<String> values,
    required IconData icon,
    required String Function(String value) onTapPrefix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(),
            style: TextStyle(fontSize: 12, color: CupertinoColors.systemGrey)),
        const SizedBox(height: 5),
        if (values.isNotEmpty)
          Column(
            children: values
                .map((value) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: GestureDetector(
                onTap: () async {
                  final Uri uri = Uri.parse(onTapPrefix(value));
                  await launchUrl(uri);
                },
                child: Container(
                  padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: CupertinoColors.systemGrey.withOpacity(0.2)),
                  child: Row(
                    children: [
                      Icon(icon, color: CupertinoColors.systemGrey),
                      const SizedBox(width: 15),
                      Text(value,
                          style: TextStyle(
                              color: CupertinoColors.systemBlue,
                              fontSize: 14)),
                    ],
                  ),
                ),
              ),
            ))
                .toList(),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text('No ${label.toLowerCase()} added',
                style: TextStyle(color: CupertinoColors.systemGrey, fontSize: 16)),
          ),
        const SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Image.network(
                  photo ?? '', // Handle potential null value
                  width: double.infinity,
                  fit: BoxFit.fill,
                  height: 300,
                ),
                Positioned(
                    top: 10,
                    right: 10,
                    child: CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      color: CupertinoColors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                      child: const Text('Edit',
                          style: TextStyle(color: CupertinoColors.white)),
                      onPressed: () {
                        _navigateToEditContact(context);
                      },
                    )),
                Positioned(
                    top: 10,
                    left: 10,
                    child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: const Icon(CupertinoIcons.chevron_back,
                            color: CupertinoColors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        })),
                Positioned(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("last used: ",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w200)),
                          Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: CupertinoColors.white),
                              child: const Text("P",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: CupertinoColors.black))),
                          const Text(" Primary",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w200)),
                          const Icon(CupertinoIcons.chevron_forward,
                              size: 12, color: CupertinoColors.white)
                        ],
                      ),
                      Text(_name,
                          style: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w500)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildActionButton(
                              icon: CupertinoIcons.bubble_middle_bottom_fill,
                              label: 'message',
                              onPressed: () async {
                                if (_phoneNumbers.isNotEmpty) {
                                  final Uri uri =
                                  Uri.parse('sms:${_phoneNumbers.first}');
                                  await launchUrl(uri);
                                }
                              },
                            ),
                            _buildActionButton(
                              icon: CupertinoIcons.phone_solid,
                              label: 'call',
                              onPressed: () async {
                                if (_phoneNumbers.isNotEmpty) {
                                  final Uri uri =
                                  Uri.parse('tel:${_phoneNumbers.first}');
                                  await launchUrl(uri);
                                }
                              },
                            ),
                            _buildActionButton(
                              icon: CupertinoIcons.video_camera_solid,
                              label: 'video',
                              onPressed: () {},
                            ),
                            _buildActionButton(
                              icon: CupertinoIcons.mail_solid,
                              label: 'mail',
                              onPressed: () async {
                                if (_emails.isNotEmpty) {
                                  final Uri uri =
                                  Uri.parse('mailto:${_emails.first}');
                                  await launchUrl(uri);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _buildContactDetailItem(
                    label: 'phone',
                    values: _phoneNumbers,
                    icon: CupertinoIcons.phone_fill,
                    onTapPrefix: (value) => 'tel:$value',
                  ),
                  const SizedBox(height: 10),
                  _buildContactDetailItem(
                    label: 'email',
                    values: _emails,
                    icon: CupertinoIcons.mail_solid,
                    onTapPrefix: (value) => 'mailto:$value',
                  ),
                  const SizedBox(height: 10),
                  _buildContactDetailItem(
                    label: 'sms',
                    values: _phoneNumbers,
                    icon: CupertinoIcons.chat_bubble_fill,
                    onTapPrefix: (value) => 'sms:$value',
                  ),
                  const SizedBox(height: 10),
                  _buildContactDetailItem(
                    label: 'url',
                    values: _urls,
                    icon: CupertinoIcons.link,
                    onTapPrefix: (value) =>
                    value.startsWith('http') ? value : 'https://$value',
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}