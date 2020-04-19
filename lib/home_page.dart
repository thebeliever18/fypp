import 'package:expense_tracker_app/add_envelope_page.dart';
import 'package:expense_tracker_app/decorations.dart';
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
  String message;
  HomePage([this.message]);
  @override
  State<StatefulWidget> createState() {
    return HomePageState(this.message);
  }
}

var listOfTransaction;
bool displayDataForCalculation = false;

class HomePageState extends State<HomePage> {

  String message;
  HomePageState([this.message]);

  String returnText;

  // //_scaffoldKey is a global key that is unique across the entire app.
  // final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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

    //print(listEnvelopeFirestoreData[0].data);
    //print(listEnvelopeFirestoreData[0].data['Envelope Name']);
    //print(listEnvelopeFirestoreData[0].data['Initial Value']);
  }

  getTransactionsData() async {
    LoginRegistrationPageState obj = new LoginRegistrationPageState();
    var uid = await obj.getCurrentUserId();

    QuerySnapshot querySnapshot = await Firestore.instance
        .collection('Transactions')
        .document(uid)
        .collection('transactionData')
        .getDocuments();

    //storing extracted list of documents in a variable
    listOfTransaction = querySnapshot.documents;

    if (listOfTransaction != null) {
      setState(() {
        displayDataForCalculation = true;
      });
    }
  }

  @override
  void initState() {
    //getting data for calculation
    getTransactionsData();

    // TODO: implement initState
    getCurrentUserIdData();

    //loginOnline is set to true if user logins in his/her account
    loginOnline = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                          return EnvelopeReorderableListView(false);
                        }));
                      },
                    )
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                wrapEnvelop(true),
              ],
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
            //backgroundColor: Colors.purple,
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
        color: setNaturalGreenColor(),
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
          children: <Widget>[Text("ADD ENVELOPE",style: TextStyle(
            color:Colors.white
          )), Icon(Icons.add_circle,color: Colors.white,)],
        ),
      ),
    );
  }

  calculation(String title, String text) {
    returnText = "No Transaction";
    double envelopeAmount = double.parse(text);
    bool displayCalculatedValue = false;

    if (displayDataForCalculation == true) {
      for (var i = 0; i < listOfTransaction.length; i++) {
        if (title == listOfTransaction[i].data['Envelope']) {
          if (listOfTransaction[i].data['Transaction Type'] == "Income") {
            envelopeAmount = envelopeAmount +
                double.parse(listOfTransaction[i].data['Amount']);
          } else if (listOfTransaction[i].data['Transaction Type'] ==
              "Expense") {
            envelopeAmount = envelopeAmount -
                double.parse(listOfTransaction[i].data['Amount']);
          }
          print(envelopeAmount);
          print("$title");
          displayCalculatedValue = true;
          setState(() {
            returnText = envelopeAmount.toString();
          });
        } else {
          if (displayCalculatedValue == false) {
            setState(() {
              returnText = "No Transaction";
            });
          }
        }
      }
    } else if ((displayDataForCalculation == false)) {
      return returnText;
    }
    return returnText;
  }

  Widget addEnvelope(String title, String text) {
    return Container(
      decoration: BoxDecoration(
        color: setNaturalGreenColor(),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  text,
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                    //
                    calculation(title, text))
              ],
            )
          ],
        ),
      ),
    );
  }
}

calculationForTheValidationOfAmount(String envelopeName, double initialAmount) {
  bool displayCalculatedValue = false;
  if (displayDataForCalculation == true) {
    for (var i = 0; i < listOfTransaction.length; i++) {
      if (envelopeName == listOfTransaction[i].data['Envelope']) {
        if (listOfTransaction[i].data['Transaction Type'] == "Income") {
          initialAmount =
              initialAmount + double.parse(listOfTransaction[i].data['Amount']);
        } else if (listOfTransaction[i].data['Transaction Type'] == "Expense") {
          initialAmount =
              initialAmount - double.parse(listOfTransaction[i].data['Amount']);
        }

        displayCalculatedValue = true;
      } else {
        if (displayCalculatedValue == false) {
          return "No transaction";
        }
      }
    }
  } else if ((displayDataForCalculation == false)) {
    return initialAmount;
  }
  return initialAmount;
}

//Widget for addEnvelope conatiner


