import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class AddContactScreen extends StatelessWidget {
  final nameController = TextEditingController();
  final lnameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.currentTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: themeProvider.currentTheme.scaffoldBackgroundColor,
        title: Text(
            'Add Contact',
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
              decoration: InputDecoration(labelText: 'First Name',labelStyle: themeProvider.currentTheme.textTheme.bodyMedium),
            ),
            TextField(
                style: themeProvider.currentTheme.textTheme.bodyMedium,
                controller: lnameController,
              decoration: InputDecoration(labelText: 'Last name',labelStyle: themeProvider.currentTheme.textTheme.bodyMedium)
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
              decoration: InputDecoration(labelText: 'Email',labelStyle: themeProvider.currentTheme.textTheme.bodyMedium),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text;
                final lastname = lnameController.text;
                final phoneNumber = phoneNumberController.text;
                final Email = emailController.text;
                if (name.isNotEmpty && phoneNumber.isNotEmpty&& lastname.isNotEmpty && Email.isNotEmpty) {
                  final newContact = Contact(name,lastname, phoneNumber,Email);
                  Navigator.pop(context, newContact);
                }
              },
              child: Text('Save Contact',style: themeProvider.currentTheme.textTheme.bodyMedium),
            ),
          ],
        ),
      ),
    );
  }
}