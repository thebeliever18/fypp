import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:expense_tracker_app/add_envelope_page.dart';
import 'package:expense_tracker_app/login_registration_page.dart';
import 'package:expense_tracker_app/envelope_model.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

//Creating list of type EnvelopeModel
List<EnvelopeModel> listEnvelope = [];

//Method for appending data to the listEnvelope
void addToList(EnvelopeModel data) {
  listEnvelope.add(data);
}

//Class for HomePage
class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  //_scaffoldKey is a global key that is unique across the entire app.
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "Envelope",
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0,
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
                      
                      _scaffoldKey.currentState.openDrawer();
                    },
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(200),
                ),
              )
            ],
          )),
      drawer: Drawer(
        elevation: 1.0,
        child: drawerItems(),
      ),

      //A bottom navigation bar to display at the bottom of the scaffold.

      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.blueAccent,
        height: 50,
        items: <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.calendar_today, size: 25),
          Icon(Icons.add, size: 30),
          Icon(Icons.pie_chart, size: 30),
          Icon(Icons.help, size: 30),
        ],

        //animationDuration for increasing the duration of the animation

        animationDuration: Duration(milliseconds: 200),

        //index 0 will be selected by default in bottom navigation bar

        index: 0,
        onTap: (index) {
          //Handle button tap
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "List of envelopes",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 21.0),
                    ),
                    Icon(Icons.settings)
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                wrapEnvelop(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Wrap design
  Wrap wrapEnvelop() {
    return Wrap(
      direction: Axis.horizontal,
      spacing: 5.0,
      runSpacing: 10.0,
      children: <Widget>[
        //Adding envelope infinitely.
        for (var i = 0; i < listEnvelope.length; i++)
          addEnvelope(listEnvelope[i].name, listEnvelope[i].amount),
        addEnvelopeButton()
      ],
    );
  }

  //Widget for ADD ENVELOPE button
  Widget addEnvelopeButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      height: 50,
      width: 167.5,
      child: FlatButton(
        onPressed: () {
          //Navigating to add envelope page
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddEnvelopePage();
          }));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[Text("ADD ENVELOPE"), Icon(Icons.add_circle)],
        ),
      ),
    );
  }
}

//Widget for addEnvelope conatiner
Widget addEnvelope(String title, String text) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
    height: 50,
    width: 167.5,
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(color: Colors.grey),
          ),
          Text(
            text,
            style: TextStyle(fontSize: 16.0),
          )
        ],
      ),
    ),
  );
}

//Decoration of Drawer
drawerItems() {
  return ListView(
    children: <Widget>[
      DrawerHeader(
        child: Column(
          children: <Widget>[
            CircleAvatar(radius: 55, child: displayFirstLetterofEmail()),
            SizedBox(
              height: 10,
            ),
            Text(LoginRegistrationPageState.emailController.text)
          ],
        ),
        decoration: BoxDecoration(color: Colors.red),
      ),
      ListTile(
        leading: Icon(Icons.home),
        title: Text("Home"),
        onTap: () {},
      )
    ],
  );
}

//Selects first letter from email
displayFirstLetterofEmail() {
  String firstLetterofEmail =
      LoginRegistrationPageState.emailController.text[0];
  //Returning first letter of email address by making it capital
  return Text("${firstLetterofEmail.toUpperCase()}");
}
