import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shareprefcont/ContactListScreen.dart';
import 'package:shareprefcont/main.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController Firstnamecontroller = TextEditingController();
  TextEditingController Lastnamecontroller = TextEditingController();
  TextEditingController Numbercontroller = TextEditingController();
  TextEditingController Emailcontroller = TextEditingController();
  TextEditingController Adresscontroller = TextEditingController();
  TextEditingController Citycontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final contactProvider = Provider.of<ContactListProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final stepperProvider = Provider.of<StepperProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.currentTheme.scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: themeProvider.currentTheme.scaffoldBackgroundColor,
        title: Text(
          'Log in',
          style: themeProvider.currentTheme.textTheme.bodyMedium,
        ),
        leading: SizedBox(),
      ),
      body: Stepper(
          currentStep: stepperProvider.index,
          type: StepperType.horizontal,
          onStepTapped: (value) {
            stepperProvider.ChangeStep(value);
          },
          onStepContinue: () {
            stepperProvider.ContinueStep();
          },
          onStepCancel: () {
            stepperProvider.CancelStep();
          },
          steps: [
            Step(
              title: Text(
                'Account',
                style: themeProvider.currentTheme.textTheme.bodyMedium,
              ),
              content: Column(
                children: [
                  TextField(
                    controller: Firstnamecontroller,
                    style: TextStyle(
                      color: themeProvider.currentTheme.focusColor
                    ),
                    decoration: InputDecoration(
                        label: Text('Firstname'),
                        labelStyle: themeProvider.currentTheme.textTheme.bodyMedium
                    ),
                  ),
                  TextField(
                    controller: Lastnamecontroller,
                    style: themeProvider.currentTheme.textTheme.bodyMedium,
                    decoration: InputDecoration(
                        label: Text('Lastname'),
                        labelStyle: themeProvider.currentTheme.textTheme.bodyMedium
                    ),
                  ),
                  TextField(
                    controller: Numbercontroller,
                    style: themeProvider.currentTheme.textTheme.bodyMedium,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        label: Text('Contact Number'),
                        labelStyle: themeProvider.currentTheme.textTheme.bodyMedium
                    ),
                  ),
                  TextField(
                    controller: Emailcontroller,
                    style: themeProvider.currentTheme.textTheme.bodyMedium,
                    decoration: InputDecoration(
                        label: Text('Email'),
                        labelStyle: themeProvider.currentTheme.textTheme.bodyMedium
                    ),
                  )
                ],
              ),
              isActive: stepperProvider.index>=0?true:false,
              state: stepperProvider.index>0?StepState.complete:StepState.indexed,
            ),
            Step(
              title: Text(
                'Address',
                style: themeProvider.currentTheme.textTheme.bodyMedium,
              ),
              content:Column(
                children: [
                  TextField(
                    controller: Adresscontroller,
                    style: themeProvider.currentTheme.textTheme.bodyMedium,
                    maxLines: 6,
                    decoration: InputDecoration(
                        label: Text('Address'),
                        labelStyle: themeProvider.currentTheme.textTheme.bodyMedium
                    ),
                  ),
                  TextField(
                    controller: Citycontroller,
                    style: themeProvider.currentTheme.textTheme.bodyMedium,
                    decoration: InputDecoration(
                        label: Text('City'),
                        labelStyle: themeProvider.currentTheme.textTheme.bodyMedium
                    ),
                  )
                ],
              ),
              isActive: stepperProvider.index>=1?true:false,
              state: stepperProvider.index>1?StepState.complete:StepState.indexed,

            ),
            Step(
              title: Text(
                'Complete',
                style: themeProvider.currentTheme.textTheme.bodyMedium,
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('First Name: ${Firstnamecontroller.text.toString()}',style: themeProvider.currentTheme.textTheme.bodyMedium,),
                  Text('Last Name: ${Lastnamecontroller.text.toString()}',style: themeProvider.currentTheme.textTheme.bodyMedium,),
                  Text('Number: ${Numbercontroller.text.toString()}',style: themeProvider.currentTheme.textTheme.bodyMedium,),
                  Text('Email: ${Emailcontroller.text.toString()}',style: themeProvider.currentTheme.textTheme.bodyMedium,),
                  Text('Address: ${Adresscontroller.text.toString()}',style: themeProvider.currentTheme.textTheme.bodyMedium,),
                  Text('City: ${Citycontroller.text.toString()}',style: themeProvider.currentTheme.textTheme.bodyMedium,),
                  Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ContactListScreen()));
                          contactProvider.addContact(Contact(
                            Firstnamecontroller.text.toString(),
                            Lastnamecontroller.text.toString(),
                            Numbercontroller.text.toString(),
                            Emailcontroller.text.toString(),
                          ));
                          stepperProvider.LoginCheck();
                          stepperProvider.saveIsLogin(true);
                        },
                        child: Text('Submit'),
                      )
                  )
                ],
              ),
              isActive: stepperProvider.index==2?true:false,
              state: stepperProvider.index>2?StepState.complete:StepState.indexed,

            )
          ]
      ),
    );
  }
}
class StepperProvider extends ChangeNotifier{
  int index = 0;
  bool islogin = false;
  void ChangeStep(int Step){
    index = Step;
    notifyListeners();
  }
  void ContinueStep(){
    if(index<2){
      index++;
    }
    notifyListeners();
  }
  void CancelStep(){
    if(index>0){
      index--;
    }
    notifyListeners();
  }
  void LoginCheck(){
    islogin = true;
    notifyListeners();
  }
  Future<bool> loadIsLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    islogin = prefs.getBool('isLogin') ?? false;
    return islogin;
  }

  Future<void> saveIsLogin(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    islogin = value;
    prefs.setBool('isLogin', islogin);
    notifyListeners();
  }
}
