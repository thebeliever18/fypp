import 'package:expense_tracker_app/set_up_balance_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginRegistrationPage extends StatefulWidget {
  @override
  LoginRegistrationPageState createState() => LoginRegistrationPageState();
}

class LoginRegistrationPageState extends State<LoginRegistrationPage> {
  
  //final _formKey = GlobalKey<FormState>();
  bool registration;
  static final emailController = TextEditingController();
  static final passwordController = TextEditingController();
  @override
  void initState() {
    super.initState();
    registration = true;
  }

  int count = 0;
  var sizebox = SizedBox(
    height: 10,
  );

  Widget build(BuildContext context) {
    return Form(
      //key: _formKey,
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
              // validator: (value) {
              //   if (value.isEmpty) {
              //     return 'Please enter your Email';
              //   } else {
              //     return null;
              //   }
              // },
              decoration: InputDecoration(
                /**
                 * Underline color of text field
                 */
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
                  /**
                 * Underline color of text field
                 */
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
            child: registration ? RaisedButton(
              child: Text(
                "Log In",
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
              onPressed: () {
                
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SetUpBalancePage();
                }));
                // if (_formKey.currentState.validate()) {
                //   Navigator.push(context, MaterialPageRoute(builder: (context) {
                //     return SetUpBalance();
                //   }));
                // }
              },
            ):
            RaisedButton(
              child: Text(
                "Sign Up",
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
              onPressed: () {
                setState(() {
                  registration = true;
                });
                // Navigator.push(context, MaterialPageRoute(builder: (context) {
                //   return SetUpBalance();
                // }));
                // if (_formKey.currentState.validate()) {
                //   Navigator.push(context, MaterialPageRoute(builder: (context) {
                //     return SetUpBalance();
                //   }));
                // }
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
                    // color: Color.fromRGBO(11, 212, 191, 1.0),
                    color: Color.fromRGBO(7, 226, 177, 1.0),
                    child: Text(
                      registration ? "Create New Account" : "Log In To Your Account",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      if (registration == true) {
                        setState(() {
                          registration = false;
                        });
                      } else if (registration == false) {
                        setState(() {
                          registration = true;
                        });
                      }
                    },
                  ),
                )
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: <Widget>[
                //     Text("Not registered Yet?"),
                //     MaterialButton(
                //       splashColor: Color.fromRGBO(80, 213, 162, 1.0),
                //       shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(5.0)),
                //       minWidth: 5,
                //       height: 5,
                //       onPressed: () {},
                //       child: Text("Register here"),
                //     ),
                //   ],
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}