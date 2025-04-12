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
class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  var box = Hive.box('database');
  List<dynamic> contacts = [
  ];
   @override
  void initState() {
     if (box.get('contacts') == null) {
       print('empty list');
     }else{
       setState(() {
         contacts = box.get('contacts');
         print(contacts);
       });
     }
    super.initState();
 }
  TextEditingController _fname = TextEditingController();
  TextEditingController _lname = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _url = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
         navigationBar: CupertinoNavigationBar(
           trailing: CupertinoButton(child: Icon(CupertinoIcons.add), onPressed: (){
           showCupertinoModalPopup(context: context, builder: (context){
             return CupertinoActionSheet(
               title: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   CupertinoButton(child: Text('Cancle'), onPressed: (){
                     Navigator.pop(context);
                   }),
                   Text('New Contact'),
                   CupertinoButton(child: Text('Done'), onPressed: (){
                     setState(() {
                       contacts.add(  {
                         "name" : _fname.text + " " + _lname.text,
                         "phone" : _phone.text,
                         "email" : _email.text,
                         "url" : _url.text,
                         "photo" : "https://th.bing.com/th/id/OIP.v9xx5HA2kWMXMDxIms_86wHaLI?rs=1&pid=ImgDetMain"
                       },);
                       box.put('contacts', contacts);
                       print(box.get('contacts'));

                     });
                     _fname.text = "";
                     _lname.text = "";
                     _phone.text = "";
                     _email.text = "";
                     _url.text = "";

                     Navigator.pop(context);
                   }),
                 ],
               ),

               message: Column(
                 children: [
                   Icon(CupertinoIcons.person_circle_fill, color: CupertinoColors.systemGrey, size: 200,),
                   CupertinoButton(child: Text('Add Photo'), onPressed: (){

                   }),
                   Container(
                     decoration: BoxDecoration(
                       color: CupertinoColors.systemGrey.withOpacity(0.1),
                     ),
                     child: Column(
                       children: [
                         CupertinoTextField(
                           controller: _fname,
                           placeholder: 'First Name',
                           decoration: BoxDecoration(
                             color: CupertinoColors.systemGrey.withOpacity(0.0),
                           ),
                         ),
                         Divider(color: CupertinoColors.systemGrey.withOpacity(0.2),),
                         CupertinoTextField(
                           controller: _lname,
                           placeholder: 'Last Name',
                           decoration: BoxDecoration(
                             color: CupertinoColors.systemGrey.withOpacity(0.0),
                           ),
                         ),


                       ],
                     ),
                   ),
