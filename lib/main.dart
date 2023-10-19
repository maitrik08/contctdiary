import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shareprefcont/Login.dart';
import 'package:shareprefcont/SplashScreen.dart';
import 'AddContactScreen.dart';
import 'ContactListScreen.dart';
import 'EditContactScreen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  final themeProvider = ThemeProvider();
  final contactListProvider = ContactListProvider();
  final stepperProvider = StepperProvider();
  await themeProvider.loadThemePreference();
  await themeProvider.loadThemevalue();
  await contactListProvider.loadContacts();
  await stepperProvider.loadIsLogin();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
        ChangeNotifierProvider<ContactListProvider>.value(value: contactListProvider),
        ChangeNotifierProvider<StepperProvider>.value(value: stepperProvider),
        //ChangeNotifierProvider<ContactListProvider>(create: (_) => contactListProvider()),
        //ChangeNotifierProvider<StepperProvider>(create: (_) => StepperProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeProvider.currentTheme,
          routes: {
            '/addContact': (context) => AddContactScreen(),
            '/editContact': (context) => EditContactScreen(index: 0),
          },
          home: SplashScreen(),
        );
      },
    );
  }
}

class ThemeProvider with ChangeNotifier {
  String selected = 'light';
  bool _isLightTheme = true; // Default to light theme

  bool get isLightTheme => _isLightTheme;
  late ThemeData _currentTheme = _isLightTheme?lighttheme():darktheme();
  ThemeData get currentTheme => _currentTheme;
  void setTheme(bool isLight) async{
    print(isLight);
    _isLightTheme = isLight;
    _currentTheme = isLight ? lighttheme() : darktheme();
    saveThemePreference(isLight);
    notifyListeners();
    ;
  }
  void Changetheme(String Value){
    selected = Value;
    notifyListeners();
  }
  void saveThemePreference(bool is_light_theme) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('is_light_theme', is_light_theme);
  }

  Future<bool> loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final isLightTheme = prefs.getBool('is_light_theme');
    _isLightTheme = isLightTheme ?? true;
    _currentTheme = _isLightTheme ? lighttheme() : darktheme();
    return _isLightTheme;
    notifyListeners();
  }
  void saveThemevalue(String selected) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('selected', selected);
  }
  Future<String?> loadThemevalue() async {
    final prefs = await SharedPreferences.getInstance();
    final Selection = prefs.getString('selected');
    return Selection;
  }
}

ThemeData lighttheme() {
  return ThemeData(
      scaffoldBackgroundColor: Colors.grey.shade100,
      iconTheme: IconThemeData(color: Colors.black, size: 25),
      primarySwatch: Colors.blue,
      focusColor: Colors.black,
      textTheme: TextTheme(
          bodyMedium: TextStyle(
              color: Colors.black, fontSize: 15,fontWeight: FontWeight.w500
          )
      ),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateColor.resolveWith((states) => Colors.black), //<-- SEE HERE
      )
  );
}

ThemeData darktheme() {
  return ThemeData(
      scaffoldBackgroundColor: Colors.black,
      iconTheme: IconThemeData(color: Colors.white, size: 25),
      primarySwatch: Colors.blue,
      focusColor: Colors.white,
      textTheme: TextTheme(
          bodyMedium: TextStyle(
              color: Colors.white, fontSize: 15,fontWeight: FontWeight.w500
          )
      ),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateColor.resolveWith((states) => Colors.white), //<-- SEE HERE
      )
  );
}

class Contact {
  String name;
  String lastname;
  String phoneNumber;
  String Email;
  Contact(this.name, this.lastname,this.phoneNumber,this.Email);
}


class AuthService {
  final String _tokenKey = 'user_token';

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(_tokenKey);
    return token != null;
  }

  Future<void> login(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}


