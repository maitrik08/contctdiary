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
  late TextEditingController lnameController;
  late TextEditingController emailController;
  final int index;

  _EditContactScreenState({required this.index});

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    phoneNumberController = TextEditingController();
    lnameController = TextEditingController();
    emailController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final contact = ModalRoute.of(context)!.settings.arguments as Contact;

    // Initialize the text controllers with the contact's information.
    nameController.text = contact.name;
    phoneNumberController.text = contact.phoneNumber;
    lnameController.text = contact.lastname;
    emailController.text = contact.Email;

    return Scaffold(
      backgroundColor: themeProvider.currentTheme.scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: themeProvider.currentTheme.scaffoldBackgroundColor,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back,color: themeProvider.currentTheme.iconTheme.color,),
        ),
        title: Text(
            'Edit Contact',
          style: themeProvider.currentTheme.textTheme.bodyLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              style: themeProvider.currentTheme.textTheme.bodyMedium,
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name',labelStyle: themeProvider.currentTheme.textTheme.bodyMedium),
            ),
            TextField(
                style: themeProvider.currentTheme.textTheme.bodyMedium,
                controller: lnameController,
              decoration: InputDecoration(labelText: 'Phone Number',labelStyle: themeProvider.currentTheme.textTheme.bodyMedium)
            ),
            TextField(
              style: themeProvider.currentTheme.textTheme.bodyMedium,
              controller: phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number',labelStyle: themeProvider.currentTheme.textTheme.bodyMedium),
              keyboardType: TextInputType.phone,
            ),
            TextField(
                style: themeProvider.currentTheme.textTheme.bodyMedium,
                controller: emailController,
              decoration: InputDecoration(labelText: 'Email',labelStyle: themeProvider.currentTheme.textTheme.bodyMedium)
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text;
                final lastname = lnameController.text;
                final phoneNumber = phoneNumberController.text;
                final Email = emailController.text;

                if (name.isNotEmpty && phoneNumber.isNotEmpty && lastname.isNotEmpty && Email.isNotEmpty) {
                  final updatedContact = Contact(name,lastname, phoneNumber,Email);
                  Provider.of<ContactListProvider>(context, listen: false).updateContact(index, updatedContact);
                  Navigator.pop(context, updatedContact);
                } else {
                  Navigator.pop(context, null);
                }
              },
              child: Text('Save Changes',style: themeProvider.currentTheme.textTheme.bodyMedium,),
            ),
          ],
        ),
      ),
    );
  }
}