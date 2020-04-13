import 'package:expense_tracker_app/decorations.dart';
import 'package:expense_tracker_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: setNaturalGreenColor(),
      ),
      body: bodyOfSettingsPage(),
    );
  }

  bodyOfSettingsPage() {
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

                    _scaffoldKey.currentState.showSnackBar(snackBar);

                    Future.delayed(const Duration(seconds: 3), () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Main();
                      }));
                      _scaffoldKey.currentState.removeCurrentSnackBar();
                    });
                  } catch (e) {
                    final snackBar = SnackBar(
                      content: Text('$e'),
                      duration: Duration(seconds: 2),
                    );

                    _scaffoldKey.currentState.showSnackBar(snackBar);
                  }
                },
              ),
            ],
          );
        });
  }
}
