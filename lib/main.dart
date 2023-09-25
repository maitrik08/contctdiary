import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AddContactScreen.dart';
import 'ContactListScreen.dart';
import 'EditContactScreen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ContactListProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ContactListScreen(),
    routes: {
        '/addContact': (context) => AddContactScreen(),
        '/editContact': (context) => EditContactScreen(index: 0,),
      },
    );
  }
}

class Contact {
  String name;
  String phoneNumber;

  Contact(this.name, this.phoneNumber);
}




