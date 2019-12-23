import 'package:expense_tracker_app/set_up_balance_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker_app/snackBar.dart';

//Class for login and registration page
class LoginRegistrationPage extends StatefulWidget {
  @override
  LoginRegistrationPageState createState() => LoginRegistrationPageState();
}

class LoginRegistrationPageState extends State<LoginRegistrationPage> {
  /*
   * if bool registration is true then login page is displayed else sign up page is displayed.
   * emailController is a TextEditingController of email textfield.
   * passwordController is a TextEditingController of password textfield.
   */
  bool registration;
  static final emailController = TextEditingController();
  static final passwordController = TextEditingController();

  //The framework will call this method exactly once for each State object it creates.
  @override
  void initState() {
    super.initState();
    registration = true;
  }

  //Creating a with a specified size.
  var sizebox = SizedBox(
    height: 10,
  );

  Widget build(BuildContext context) {
    return Form(
      autovalidate: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Image.asset(
                "images/bgimg.jpg",
              ),
              Positioned(
                  bottom: 30,
                  left: 35,
                  child: Text(
                    registration ? "LOGIN" : "SIGNUP",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        decoration: TextDecoration.underline,
                        decorationStyle: TextDecorationStyle.double,
                        color: Colors.white),
                  ))
            ],
          ),
          sizebox,
          sizebox,
          Container(
            width: 290,
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              decoration: InputDecoration(
                  //Underline color of text field
                  focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(80, 213, 162, 1.0))),
                  filled: true,
                  fillColor: Colors.grey[50],
                  hintText: "Email",
                  hintStyle: TextStyle(color: Colors.grey)),
            ),
          ),
          sizebox,
          Container(
            width: 290.0,
            child: TextFormField(
              controller: passwordController,
              obscureText: true,
              // validator: (value) {
              //   if (value.isEmpty) {
              //     return 'Please enter your Password';
              //   } else if (value.length < 4) {
              //     return 'Password must be of more than 3 characters';
              //   } else {
              //     return null;
              //   }
              // },
              decoration: InputDecoration(

                  //Underline color of text field
                  focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(80, 213, 162, 1.0))),
                  filled: true,
                  fillColor: Colors.grey[50],
                  hintText: "Password",
                  hintStyle: TextStyle(color: Colors.grey)),
            ),
          ),
          sizebox,
          ButtonTheme(
            buttonColor: Color.fromRGBO(80, 213, 162, 1.0),
            minWidth: 290,
            height: 37,
            child: registration
                ? RaisedButton(
                    child: Text(
                      "Log In",
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                    onPressed: () {
                      //validation for login
                      validateFeildsOfLogin();
                    },
                  )
                : RaisedButton(
                    child: Text(
                      "Sign Up",
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                    onPressed: () {
                      //validation for signup
                      validateFeildsOfSignUp();
                    },
                  ),
          ),
          sizebox,
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 33.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Divider(
                        color: Colors.grey[400],
                      )),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      ),
                      Text("OR"),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      ),
                      Expanded(
                          child: Divider(
                        color: Colors.grey[400],
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ButtonTheme(
                  minWidth: 180,
                  child: FlatButton(
                    color: Color.fromRGBO(7, 226, 177, 1.0),
                    child: Text(
                      registration
                          ? "Create New Account"
                          : "Log In To Your Account",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      if (registration == true) {
                        //Clear all textfeilds
                        clearTextField();

                        setState(() {
                          registration = false;
                        });
                      } else if (registration == false) {
                        //Clear all textfeilds
                        clearTextField();
                        setState(() {
                          registration = true;
                        });
                      }
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  //Method for validating feilds for login
  validateFeildsOfLogin() {
    //Email pattern
    Pattern emailPattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    //Regular expressions are Patterns, and can as such be used to match strings or parts of strings.
    RegExp emailRegExp = RegExp(emailPattern);

    //If textfield of email address is empty then message is displayed in snack bar.
    if (emailController.text.isEmpty) {
      String message = "Please enter your email address";
      Scaffold.of(context).showSnackBar(displaySnackBar(message));
    }
    //If standard email pattern does not match with the entered email then message is displayed in snack bar.
    else if (!emailRegExp.hasMatch(emailController.text)) {
      String message = "Entered email address pattern is not standared";
      Scaffold.of(context).showSnackBar(displaySnackBar(message));
    }
    //If textfield of password is empty then message is displayed in snack bar.
    else if (passwordController.text.isEmpty) {
      String message = "Please enter your password";
      Scaffold.of(context).showSnackBar(displaySnackBar(message));
    }
    //If all fields are validated
    else {
      //clearTextField();
      //Navigating to Set Up Balance Page
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return SetUpBalancePage();
      }));

      //Clear all textfeilds
      
    }
  }

  //Method for validating feilds for signup
  validateFeildsOfSignUp() {
    //Email pattern
    Pattern emailPattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    //Regular expressions are Patterns, and can as such be used to match strings or parts of strings.
    RegExp emailRegExp = RegExp(emailPattern);

    //If textfield of email address is empty then message is displayed in snack bar.
    if (emailController.text.isEmpty) {
      String message = "Please enter your email address";
      Scaffold.of(context).showSnackBar(displaySnackBar(message));
    }
    //If standard email pattern does not match with the entered email then message is displayed in snack bar.
    else if (!emailRegExp.hasMatch(emailController.text)) {
      String message = "Entered email address pattern is not standared";
      Scaffold.of(context).showSnackBar(displaySnackBar(message));
    }
    //If textfield of password is empty then message is displayed in snack bar.
    else if (passwordController.text.isEmpty) {
      String message = "Please enter your password";
      Scaffold.of(context).showSnackBar(displaySnackBar(message));
    }
    //If all fields are validated
    else {
      setState(() {
        registration = true;
      });
      //Clear all textfeilds
      clearTextField();
    }
  }

  //Method for clearing all textfeilds
  clearTextField() {
    emailController.clear();
    passwordController.clear();
  }
}
