import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shareprefcont/ContactListScreen.dart';
import 'package:shareprefcont/main.dart';
class EditContactScreen extends StatefulWidget {
  final int index;

  EditContactScreen({required this.index});

  @override
  _EditContactScreenState createState() => _EditContactScreenState(index: index);
}

class _EditContactScreenState extends State<EditContactScreen> {
  late TextEditingController nameController;
  late TextEditingController phoneNumberController;
  final int index;

  _EditContactScreenState({required this.index});

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    phoneNumberController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final contact = ModalRoute.of(context)!.settings.arguments as Contact;

    // Initialize the text controllers with the contact's information.
    nameController.text = contact.name;
    phoneNumberController.text = contact.phoneNumber;

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
                  final updatedContact = Contact(name, phoneNumber);
                  Provider.of<ContactListProvider>(context, listen: false).updateContact(index, updatedContact);
                  Navigator.pop(context, updatedContact);
                } else {
                  Navigator.pop(context, null);
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