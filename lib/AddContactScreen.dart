import 'package:flutter/material.dart';
import 'main.dart';

class AddContactScreen extends StatelessWidget {
  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text;
                final phoneNumber = phoneNumberController.text;
                if (name.isNotEmpty && phoneNumber.isNotEmpty) {
                  final newContact = Contact(name, phoneNumber);
                  Navigator.pop(context, newContact);
                }
              },
              child: Text('Save Contact'),
            ),
          ],
        ),
      ),
    );
  }
}