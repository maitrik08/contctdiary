import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'EditContactScreen.dart';
import 'main.dart';
class ContactListScreen extends StatefulWidget {
  @override
  ContactListScreenState createState() => ContactListScreenState();
}

class ContactListScreenState extends State<ContactListScreen> {
  final LocalAuthentication localAuth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    Provider.of<ContactListProvider>(context, listen: false).loadContacts();
    authenticate();
  }

  Future<void> authenticate() async {
    final bool canAuthenticateWithBiometrics = await localAuth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await localAuth.isDeviceSupported();
    if (canAuthenticate) {
      await localAuth.authenticate(localizedReason: 'check');
    }
    if (!canAuthenticate) {
      // Handle authentication failure, e.g., show a message and exit the app
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Authentication Failed'),
            content: Text('Authentication is required to access the app.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Diary'),
      ),
      body: Consumer<ContactListProvider>(
        builder: (context, provider, child) {
          final contacts = provider.contacts;
          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return ListTile(
                title: Text(contact.name),
                subtitle: Text(contact.phoneNumber),
                trailing: PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: TextButton.icon(
                        label: Text('Edit'),
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          final editedContact = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditContactScreen(index: index),
                              settings: RouteSettings(
                                arguments: contact,
                              ),
                            ),
                          );
                          if (editedContact != null) {
                            provider.updateContact(index, editedContact as Contact);
                          }
                        },
                      ),
                    ),
                    PopupMenuItem(
                      child: TextButton.icon(
                        label: Text('Delete'),
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Delete Contact'),
                                content: Text('Are you sure you want to delete this contact?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      provider.deleteContact(index);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Delete'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addContact').then((newContact) {
            if (newContact != null) {
              Provider.of<ContactListProvider>(context, listen: false).addContact(newContact as Contact);
            }
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class ContactListProvider extends ChangeNotifier {
  List<Contact> contacts = [];

  void loadContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final contactsData = prefs.getStringList('contacts');
    if (contactsData != null) {
      contacts = contactsData.map((data) {
        final parts = data.split(',');
        return Contact(parts[0], parts[1]);
      }).toList();
      notifyListeners();
    }
  }

  void addContact(Contact newContact) {
    contacts.add(newContact);
    saveContacts();
    notifyListeners();
  }

  void updateContact(int index, Contact updatedContact) {
    contacts[index] = updatedContact;
    saveContacts();
    notifyListeners();
  }

  void deleteContact(int index) {
    contacts.removeAt(index);
    saveContacts();
    notifyListeners();
  }

  void saveContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final contactsData = contacts.map((contact) {
      return '${contact.name},${contact.phoneNumber}';
    }).toList();
    prefs.setStringList('contacts', contactsData);
  }
}

