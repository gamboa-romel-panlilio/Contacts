import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'variables.dart';
import 'contact.dart';

void main() {
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
  List<dynamic> contacts = [
    {
      "name" : "Juan Dela Cruz",
      "phone" : "09887654321",
      "email" : "romelqqq@gmail.com",
      "url" : "https://facebook.com/juandelacruz.1",
      "photos" : "https://mir-s3-cdn-cf.behance.net/project_modules/2800_opt_1/15345c41332353.57a1ce9141249.jpg"
    },
    {
      "name" : "Romel Gamboa",
      "phone" : "09123456789",
      "email" : "romel@gmail.com",
      "url" : "https://facebook.com/juandelacruz.1",
      "photos" : "https://mir-s3-cdn-cf.behance.net/project_modules/2800_opt_1/15345c41332353.57a1ce9141249.jpg"
    },
    {
      "name" : "Juan Dela Cruz",
      "phone" : "09887654321",
      "email" : "romelqqq@gmail.com",
      "url" : "https://facebook.com/juandelacruz.1",
      "photos" : "https://mir-s3-cdn-cf.behance.net/project_modules/2800_opt_1/15345c41332353.57a1ce9141249.jpg"
    },
    {
      "name" : "Romel Gamboa",
      "phone" : "09123456789",
      "email" : "romel@gmail.com",
      "url" : "https://facebook.com/juandelacruz.1",
      "photos" : "https://mir-s3-cdn-cf.behance.net/project_modules/2800_opt_1/15345c41332353.57a1ce9141249.jpg"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
         navigationBar: CupertinoNavigationBar(
           trailing: CupertinoButton(child: Icon(CupertinoIcons.add), onPressed: (){

           }),
         ),
        child: SafeArea(child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
                children: [
           Row(
             children: [
               Text('Contacts', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
             ],
           ),
                  SizedBox(height: 15,),
                  CupertinoTextField(
                    placeholder: 'Search',
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20)
                    ),
                    prefix: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(CupertinoIcons.search, color: CupertinoColors.systemGrey, size: 20,),
                    ),
                    suffix: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(CupertinoIcons.mic_fill, color: CupertinoColors.systemGrey, size: 20,),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(12,9,12,9),

                        decoration: BoxDecoration(
                          color: CupertinoColors.systemGrey,
                              borderRadius: BorderRadius.circular(50)
                        ),
                        child: Text('RG', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),),
                      ),
                      SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Romel Gamboa', style: TextStyle(fontWeight: FontWeight.bold),),
                          Text('My Card', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),)
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                  Divider(color: CupertinoColors.systemGrey.withOpacity(0.3),),
                  Expanded(child: ListView.builder(
                    itemCount: contacts.length,
                    itemBuilder: (context, int index) {
                      return GestureDetector(
                        onTap: (){
                          setState(() {
                            name = contacts[index]['name'];
                            phone = contacts[index]['phone'];
                            email = contacts[index]['email'];
                            url = contacts[index]['url'];
                          });
                          Navigator.push(context, CupertinoPageRoute(builder: (context)=> Contact()));
                        },
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(contacts[index]['name']),
                              Divider(color: CupertinoColors.systemGrey.withOpacity(0.3),),
                            ],
                          ),
                        ),
                      );
                    })),
                ],
              ),
        )));
  }
}
