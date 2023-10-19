import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shareprefcont/main.dart';

import 'ContactListScreen.dart';

class SettingSceen extends StatefulWidget {
  const SettingSceen({super.key});

  @override
  State<SettingSceen> createState() => _SettingSceenState();
}
class _SettingSceenState extends State<SettingSceen> {

  @override
  Widget build(BuildContext context) {
    final contactListProvider = Provider.of<ContactListProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
        backgroundColor: themeProvider.currentTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: themeProvider.currentTheme.scaffoldBackgroundColor,
          title: Text(
            'Setting',
            style: TextStyle(
              color: themeProvider.currentTheme.iconTheme.color
            ),
          ),
      ),
      body: Column(
        children: [
          RadioMenuButton(
              value: 'light',
              groupValue: themeProvider.selected,
              onChanged: (value) {
                themeProvider.Changetheme(value!);
                themeProvider.setTheme(true);
                themeProvider.saveThemevalue(value);
                themeProvider.loadThemePreference();
              },
              style: ButtonStyle(),
              child: Text(
                'Light mode',
                style: TextStyle(
                    color: themeProvider.currentTheme.focusColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 18
                ),
              )
          ),
          RadioMenuButton(
              value: 'dark',
              groupValue: themeProvider.selected,
              onChanged: (value) {
                themeProvider.loadThemePreference();
                themeProvider.Changetheme(value!);
                themeProvider.saveThemevalue(value);
                themeProvider.setTheme(false);
              },
              child: Text(
                'Dark mode',
                style: TextStyle(
                    color: themeProvider.currentTheme.focusColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 18
                ),
              )
          ),
          RadioMenuButton(
            value: 'device',
            groupValue: themeProvider.selected,
            onChanged: (value) {
              final platformBrightness = MediaQuery.of(context).platformBrightness;
              themeProvider.Changetheme(value!);
              themeProvider.saveThemevalue(value);
              themeProvider.loadThemePreference();
              if(platformBrightness == Brightness.light){
                themeProvider.setTheme(true);
              }
              else{
                themeProvider.setTheme(false);
              }
            },
            child: Text(
              'Device mode',
              style: TextStyle(
                  color: themeProvider.currentTheme.focusColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 18),
            ),
          ),
          ListTile(
            leading: Text('Authentication'),
            trailing: Switch(
              value: contactListProvider.isSwitched,
              onChanged: (value) {
                print(contactListProvider.isSwitched);
                Provider.of<ContactListProvider>(context, listen: false).toggleSwitch(value);
              },
            ),
          ),
        ],
      )
    );
  }
}
