import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:expense_tracker_app/add_envelope_page.dart';
import 'package:expense_tracker_app/envelope_reorderable_listview.dart';
import 'package:expense_tracker_app/login_registration_page.dart';
import 'package:expense_tracker_app/envelope_model.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

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

  //boolean variable loginOnline is set to true if user logins in his/her account
  bool loginOnline;

  //boolean value displayData is set to true if the extracted list from firestore is not null
  bool displayData;

  //variable which stores envelope data of a specific user extracted from firestore
  static var listEnvelopeFirestoreData;

  //Method for extracting envelope data of a specific user
  getCurrentUserIdData() async {
    LoginRegistrationPageState obj = new LoginRegistrationPageState();
    var uid = await obj.getCurrentUserId();

    //Extracts list of documents from firestore
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection('Envelopes')
        .document(uid)
        .collection('userData')
        .getDocuments();

    //storing extracted list of documents in a variable
    listEnvelopeFirestoreData = querySnapshot.documents;

    //boolean value displayData is set to true if the extracted list from firestore is not null
    if (listEnvelopeFirestoreData != null) {
      setState(() {
        displayData = true;
      });
    }

    print(listEnvelopeFirestoreData[0].data);
    print(listEnvelopeFirestoreData[0].data['Envelope Name']);
    print(listEnvelopeFirestoreData[0].data['Initial Value']);
  }

  @override
  void initState() {
    // TODO: implement initState
    getCurrentUserIdData();

    //loginOnline is set to true if user logins in his/her account
    loginOnline = true;
    super.initState();
  }

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
                    IconButton(
                      icon: Icon(Icons.settings),
                      onPressed: () {
                        //Navigating to Envelope Settings page
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return EnvelopeReorderableListView();
                        }));
                      },
                    )
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                wrapEnvelop(true)
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Wrap design
  wrapEnvelop(val) {
    return Wrap(
      direction: Axis.horizontal,
      spacing: 5.0,
      runSpacing: 10.0,
      children: <Widget>[
        //Adding envelope infinitely.

        //if the extracted list from firestore is null then circular progress indicator displayed
        if (listEnvelopeFirestoreData == null)
          Center(
              child: CircularProgressIndicator(
            backgroundColor: Colors.purple,
            //valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            //value: 0.9,
          )),

        //This if statement works when user logins in his/her account and the list extracted from firestore is not null
        if (loginOnline == true && displayData == true)
          for (var i = 0; i < listEnvelopeFirestoreData.length; i++)
            //displaying online data
            addEnvelope(listEnvelopeFirestoreData[i].data['Envelope Name'],
                listEnvelopeFirestoreData[i].data['Initial Value']),

        //This if statement works when user presses add envelope button
        if (val == false)

          //displaying offline data
          for (var i = 0; i < listEnvelope.length; i++)
            addEnvelope(
                listEnvelope[i].envelopeName, listEnvelope[i].initialValue),

        //calling widget addEnvelopeButton when list is not null or when val is false
        if (listEnvelopeFirestoreData != null || val == false)
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
          //warpEnvelope method is called and false boolean value is passed when user presses add envelope button
          wrapEnvelop(false);

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
