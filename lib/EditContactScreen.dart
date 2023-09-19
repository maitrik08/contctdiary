import 'package:flutter/material.dart';

import 'main.dart';

class EditContactScreen extends StatefulWidget {
  @override
  _EditContactScreenState createState() => _EditContactScreenState();
}

class _EditContactScreenState extends State<EditContactScreen> {
  late Contact contact; // Define the contact property here
  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    contact = ModalRoute.of(context)!.settings.arguments as Contact;
    nameController.text = contact.name;
    phoneNumberController.text = contact.phoneNumber;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Contact'),
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
                  Navigator.pop(
                    context,
                    Contact(name, phoneNumber),
                  );
                } else {
                  Navigator.pop(context, null); // User canceled editing
                }
              },

              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
