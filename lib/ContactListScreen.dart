import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'EditContactScreen.dart';
import 'main.dart';

class ContactListScreen extends StatefulWidget {
  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    loadContacts();
  }

  void loadContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final contactsData = prefs.getStringList('contacts');
    if (contactsData != null) {
      setState(() {
        contacts = contactsData.map((data) {
          final parts = data.split(',');
          return Contact(parts[0], parts[1]);
        }).toList();
      });
    }
  }

  void saveContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final contactsData = contacts.map((contact) {
      return '${contact.name},${contact.phoneNumber}';
    }).toList();
    prefs.setStringList('contacts', contactsData);
  }

  void deleteContact(int index) {
    setState(() {
      contacts.removeAt(index);
      saveContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Diary'),
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return ListTile(
            title: Text(contact.name),
            subtitle: Text(contact.phoneNumber),
            trailing: PopupMenuButton(
                itemBuilder: (context)=>[
                  PopupMenuItem(
                    child: TextButton.icon(
                      label: Text('Edit'),
                      icon: Icon(Icons.edit),
                      onPressed: () async {
                        final editedContact = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditContactScreen(),
                            settings: RouteSettings(
                              arguments: contact, // Pass the contact as an argument
                            ),
                          ),
                        );
                        if (editedContact != null) {
                          setState(() {
                            contacts[index] = editedContact as Contact;
                            saveContacts();
                          });
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
                                      deleteContact(index);
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
                ]
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addContact').then((newContact) {
            if (newContact != null) {
              setState(() {
                contacts.add(newContact as Contact);
                saveContacts();
              });
            }
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}