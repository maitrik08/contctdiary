import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shareprefcont/SettingSceen.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.currentTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: themeProvider.currentTheme.scaffoldBackgroundColor,
        leading: SizedBox(),
        leadingWidth: 0,
        title: Text(
          'Contact Diary',
          style: TextStyle(
              color: themeProvider.currentTheme.iconTheme.color
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingSceen()));
            },
            child: Icon(Icons.settings,color: themeProvider.currentTheme.iconTheme.color,),
          ),
          SizedBox(width: 20,)
        ],
      ),
      body: Consumer<ContactListProvider>(
        builder: (context, provider, child) {
          final contacts = provider.contacts;
          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return ListTile(
                leading: Icon(CupertinoIcons.profile_circled,color: Colors.grey,size: 60,),
                title: Text('${contact.name} ${contact.lastname}',style: themeProvider.currentTheme.textTheme.bodyMedium,),
                subtitle: Text(contact.phoneNumber,style: themeProvider.currentTheme.textTheme.bodyMedium,),
                trailing: PopupMenuButton(
                  color: themeProvider.currentTheme.focusColor,
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: TextButton.icon(
                        label: Text('Edit',style: TextStyle(color: themeProvider.currentTheme.scaffoldBackgroundColor)),
                        icon: Icon(Icons.edit,color: themeProvider.currentTheme.scaffoldBackgroundColor,),
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
                        label: Text('Delete',style: TextStyle(color: themeProvider.currentTheme.scaffoldBackgroundColor)),
                        icon: Icon(Icons.delete,color: themeProvider.currentTheme.scaffoldBackgroundColor),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: themeProvider.currentTheme.focusColor,
                                title: Text('Delete Contact',
                                  style: TextStyle(
                                  color: themeProvider.currentTheme.scaffoldBackgroundColor
                                ),),
                                content: Text(
                                    'Are you sure you want to delete this contact?',
                                  style: TextStyle(
                                      color: themeProvider.currentTheme.scaffoldBackgroundColor
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                        'Cancel',
                                      style: TextStyle(
                                          color: themeProvider.currentTheme.scaffoldBackgroundColor
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      provider.deleteContact(index);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                        'Delete',
                                      style: TextStyle(
                                          color: themeProvider.currentTheme.scaffoldBackgroundColor
                                      ),
                                    ),
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
  bool isSwitched = false;
  Future<List> loadContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final contactsData = prefs.getStringList('contacts');
    if (contactsData != null) {
      contacts = contactsData.map((data) {
        final parts = data.split(',');
        return Contact(parts[0], parts[1],parts[2],parts[3]);
      }).toList();

      notifyListeners();
    }
    final prefs1 = await SharedPreferences.getInstance();
    isSwitched = prefs1.getBool('isSwitched') ?? false;
    return contacts;
   notifyListeners();
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
      return '${contact.name},${contact.lastname},${contact.phoneNumber},${contact.Email}';
    }).toList();
    prefs.setStringList('contacts', contactsData);
  }
  void toggleSwitch(bool newValue) async{
    isSwitched = newValue;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isSwitched', isSwitched);
    notifyListeners();
  }
}

