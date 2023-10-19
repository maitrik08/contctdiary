import 'dart:async';

import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:shareprefcont/ContactListScreen.dart';
import 'package:shareprefcont/Login.dart';

import 'main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Future<bool> auth;
  @override
  void initState() {

    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => StepperProvider().islogin?ContactListScreen():Login()));
    });
    ThemeProvider().loadThemePreference();
    loadIsLoginAndNavigate();
    authenticate();
    super.initState();
  }

  final LocalAuthentication localAuth = LocalAuthentication();
  Future<bool> authenticate() async {
    final contactProvider = Provider.of<ContactListProvider>(context, listen: false);
    final bool canAuthenticateWithBiometrics = await localAuth.canCheckBiometrics;
    final bool canAuthenticate = canAuthenticateWithBiometrics || await localAuth.isDeviceSupported();
    return contactProvider.isSwitched?await localAuth.authenticate(
      localizedReason: 'Authenticate to access the app',
    ):false;
  }
  Future<void> loadIsLoginAndNavigate() async {
    final stepperProvider = Provider.of<StepperProvider>(context, listen: false);
    await stepperProvider.loadIsLogin(); // Load the isLogin value from shared preferences
    final isLogin = stepperProvider.islogin;

    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => isLogin ? ContactListScreen() : Login(),
      ));
    });
  }
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.currentTheme.scaffoldBackgroundColor,
      body: Center(
        child: Image.asset('Assets/icon.png'),
      ),
    );
  }
}
// class _SplashScreenState extends State<SplashScreen> {
//   bool isAuthenticated = false;
//
//   @override
//   void initState() {
//     super.initState();
//     authenticate().then((authenticated) {
//       if (authenticated) {
//         Timer(Duration(seconds: 3), () {
//           if (mounted) { // Check if the widget is still mounted before navigating
//             Navigator.of(context).push(MaterialPageRoute(builder: (context) => Login()));
//           }
//         });
//       }
//     });
//   }
//
//   Future<bool> authenticate() async {
//     final authenticated = await authenticateWithBiometrics();
//     isAuthenticated = authenticated;
//     return authenticated;
//   }
//   final LocalAuthentication localAuth = LocalAuthentication();
//   Future<bool> authenticateWithBiometrics() async {
//     final bool canAuthenticateWithBiometrics = await localAuth.canCheckBiometrics;
//     final bool canAuthenticate =
//         canAuthenticateWithBiometrics || await localAuth.isDeviceSupported();
//     final result = await localAuth.authenticate(
//       localizedReason: 'Authenticate to access the app',
//     );
//     return result?await localAuth.authenticate(
//       localizedReason: 'Authenticate to access the app',
//     ):true;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//
//     if (isAuthenticated) {
//       return Scaffold(
//         backgroundColor: themeProvider.currentTheme.scaffoldBackgroundColor,
//         body: Center(
//           child: Image.asset('Assets/icon.png'),
//         ),
//       );
//     } else {
//       return Scaffold(
//         backgroundColor: themeProvider.currentTheme.scaffoldBackgroundColor,
//         body: Center(
//           child: CircularProgressIndicator(), // You can replace this with an error message
//         ),
//       );
//     }
//   }
// }
