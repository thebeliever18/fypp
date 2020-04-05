import 'package:expense_tracker_app/login_registration_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

/*
 * main() method is the first method from where the code gets executed.
 * main() method executes ExpenseTracker class.
 */
void main() {
  runApp(Main());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //systemNavigationBarColor: Color.fromRGBO(7, 226, 177, 1.0), // navigation bar color
    statusBarColor: Color.fromRGBO(7, 226, 177, 1.0), // status bar color
  ));
}

class Main extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: LoginRegistrationPage(),
      ),
    );
  }
}
