import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AddContactScreen.dart';
import 'ContactListScreen.dart';
import 'EditContactScreen.dart';

void main() {
  runApp(ContactDiaryApp());
}

class ContactDiaryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ContactListScreen(),
      routes: {
        '/addContact': (context) => AddContactScreen(),
        '/editContact': (context) => EditContactScreen(),
      },
    );
  }
}

class Contact {
  String name;
  String phoneNumber;

  Contact(this.name, this.phoneNumber);
}






