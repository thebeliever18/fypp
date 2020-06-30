import 'package:expense_tracker_app/bottom_navigation_bar.dart';
import 'package:expense_tracker_app/decorations.dart';
import 'package:expense_tracker_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//for logout page/profile page
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      drawer: Drawer(
        elevation: 1.0,
        child: drawerItems(context),
      ),
      appBar: AppBar(
        backgroundColor: setNaturalGreenColor(),
        title: Text("Profile"),
        leading: Row(
            children: <Widget>[
              SizedBox(
                width: 9,
              ),
              Card(
                elevation: 3.0,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Container(
                  height: 30,
                  width: 30,
                  child: IconButton(
                    icon: Image.asset(
                      "images/logoET.png",
                      fit: BoxFit.cover,
                    ),
                    onPressed: () {
                      /*
                       * currentState is the state for the widget in the tree that currently has a global key.
                       * openDrawer() is the method which opens the drawer.
                       */

                      _scaffoldkey.currentState.openDrawer();
                    },
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(200),
                ),
              )
            ],
          )),
      body: bodyOfProfilePage(),
    );
  }

  bodyOfProfilePage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: ButtonTheme(
            minWidth: 300.0,
            child: OutlineButton(
              onPressed: () {
                print("hello");
                displayDialogBox();
              },
              child: Text("Log Out"),
              splashColor: Colors.redAccent,
            ),
          ),
        )
      ],
    );
  }

  displayDialogBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("Are you sure you want to log out?"),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(
                  "Yes",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () async {
                  try {
                    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
                    _firebaseAuth.signOut();

                    final snackBar = SnackBar(
                      content: Text('Logging out...'),
                      duration: Duration(seconds: 2),
                    );

                    _scaffoldkey.currentState.showSnackBar(snackBar);

                    Future.delayed(const Duration(seconds: 3), () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Main();
                      }));
                      _scaffoldkey.currentState.removeCurrentSnackBar();
                    });
                  } catch (e) {
                    final snackBar = SnackBar(
                      content: Text('$e'),
                      duration: Duration(seconds: 2),
                    );

                    _scaffoldkey.currentState.showSnackBar(snackBar);
                  }
                },
              ),
            ],
          );
        });
  }
}
