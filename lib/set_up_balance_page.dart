import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker_app/envelope_model.dart';
import 'package:expense_tracker_app/home_page.dart';
import 'package:expense_tracker_app/login_registration_page.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Class for set up cash balance page.
class SetUpBalancePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SetUpBalancePageState();
  }
}

/*
 * deletedOutput is the output which will be remained after pressing backspace button.
 * output is the value shown in the display.
 * _output is a variable used for doing calculation.
 */
var deletedOutput;
var output = "0 NPR";
var _output = "";

//Creating a text style
textStyle() {
  return TextStyle(color: Colors.grey[600], fontSize: 40.0);
}

class SetUpBalancePageState extends State<SetUpBalancePage> {

  //A method for validating different conditions after pressing any numbered button.
  void buttonPressed(var buttonText) {

    //dot('.') button can be pressed only one time.
    if (buttonText == ".") {
      if (_output.contains(".")) {
        return;
      }
    }

    //Characters up to 10 can only be pressed.
    if (_output.length < 10) {
      _output = _output + buttonText;
    }

    //Notify the framework that the internal state of this object has changed.
    setState(() {
      output = _output;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 50,
        ),
        Column(
          children: <Widget>[
            //Adding dollar symbol in card
            Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Container(
                height: 100,
                width: 100,
                child: Image.asset(
                  'images/dollar.jpg',
                  fit: BoxFit.contain,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(200),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text("Set up your balance",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0)),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Text(
                "How much cash do you have in your pocket?",
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Container(
                  height: 70,
                  color: Colors.grey[200],
                  child: Center(
                      child: Text(
                    output,
                    style: textStyle(),
                  ))),
            ),
            Container(
              height: 70,
              color: Colors.grey[200],
              child: IconButton(
                icon: Icon(Icons.backspace),
                onPressed: () {
                  //length of the entered number
                  int len = output.length;
                  
                  if (len > 1 && output != "0 NPR") {
                    //clearing the entered number after pressing backspace button
                    deletedOutput = output.substring(0, len - 1);
                  }

                  setState(() {
                    if (len == 1) {
                      output = "0 NPR";
                      _output = "";
                    } else if (output != "0 NPR") {
                      output = deletedOutput;
                      _output = deletedOutput;
                    }
                  });
                },
              ),
            )
          ],
        ),
        SizedBox(
          height: 50,
        ),

        //Layout for keypad.
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              flatButton("1"),
              flatButton("2"),
              flatButton("3"),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              flatButton("4"),
              flatButton("5"),
              flatButton("6"),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              flatButton("7"),
              flatButton("8"),
              flatButton("9"),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              flatButton("."),
              flatButton("0"),
              FlatButton(
                child: Icon(
                  Icons.done_outline,
                  color: Colors.green,
                ),
                onPressed: () async{

                  //Creating object of EnvelopeModel class and passing envelope name and value of envelope in EnvelopeModel constructor. 
                  EnvelopeModel env = new EnvelopeModel("Cash", output);
                  //DocumentSnapshot env = new EnvelopeModel("Cash", output);
                  //appending env to listEnvelope
                  addToList(env);
                  LoginRegistrationPageState obj= new LoginRegistrationPageState();
                  var uid=await obj.getCurrentUserId();
                  print(uid);
                  Firestore.instance.collection('Envelopes').document(uid).collection('userData').document().setData({'Envelope Name': "Cash",'Initial Value':output});
                  //Navigating to home page
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return HomePage();
                  }));
                },
              ),
            ],
          ),
        ),
      ],
    ));
  }

  //Widget for flatButton
  Widget flatButton(String buttonText) {
    return FlatButton(
      child: Text(buttonText, style: textStyle()),
      onPressed: () {
        buttonPressed(buttonText);
      },
    );
  }
}
