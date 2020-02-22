

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';

import 'package:expense_tracker_app/home_page.dart';
import 'package:expense_tracker_app/envelope_model.dart';
import 'package:expense_tracker_app/decorations.dart';
import 'package:expense_tracker_app/login_registration_page.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';

//Class for Add Envelope Page design
class EditEnvelopePage extends StatefulWidget {
  String envelopeName;
  String initialValue;
  String additionalNotes;
  String envelopeType;
  String documentID;
  EditEnvelopePage(this.envelopeName, this.initialValue, this.additionalNotes,
      this.envelopeType,this.documentID);
  @override
  EditEnvelopePageState createState() => EditEnvelopePageState(
      this.envelopeName,
      this.initialValue,
      this.additionalNotes,
      this.envelopeType,
      this.documentID);
}

class EditEnvelopePageState extends State<EditEnvelopePage> {
  String envelopeName;
  String initialValue;
  String additionalNotes;
  String envelopeType;
  String documentID;
  EditEnvelopePageState(this.envelopeName, this.initialValue,
      this.additionalNotes, this.envelopeType,this.documentID);

  /*
   *  initialValueinputController is a TextEditingController of Intial Value textfield.
   *  envelopeNameinputController is a TextEditingController of Envelope name textfield.
   *  additionalNotesinputController is a TextEditingController of Additional notes textfield.
   */

  TextEditingController envelopeNameinputController;
  TextEditingController initialValueinputController;
  TextEditingController additionalNotesinputController;

  /*
   * FocusNode is an object that can be used by a stateful widget to obtain the keyboard focus and to handle keyboard events.
   * focusNodeEnvelopeName is a Focus Node of Envelope Name textfield
   * focusNodeInitialValue is a Focus Node of Initial Value textfield
   * focusNodeAdditionalNotes is a Focus Node of Additional notes textfield
   */

  FocusNode focusNodeEnvelopeName = new FocusNode();
  FocusNode focusNodeInitialValue = new FocusNode();
  FocusNode focusNodeAdditionalNotes = new FocusNode();

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();

  bool autoValidate;

  //boolean variable for disabling certain textfeilds
  bool enable=true;

  //The index of envelopeType is stored in envelopeTypeIndex
  String envelopeTypeIndex;
  @override
  void initState() {
    super.initState();
    //initializing the initial value of the textfeild 0 at first run
    // setState(() {
    //   _inputController.text = "0.0";
    // });

    //addListener is triggered whenever the focus of the textfield changes
    focusNodeEnvelopeName.addListener(() {
      setState(() {});
    });

    focusNodeInitialValue.addListener(() {
      setState(() {});
    });

    focusNodeAdditionalNotes.addListener(() {
      setState(() {});
    });

    autoValidate = false;
    envelopeNameinputController = TextEditingController(text: envelopeName);
    initialValueinputController = TextEditingController(text: initialValue);
    additionalNotesinputController =
        TextEditingController(text: additionalNotes);

    //envelopeType extracted from firestore is indexed
    if (envelopeType == "Cash") {
      envelopeTypeIndex = "1";
    } else if (envelopeType == "Bank") {
      envelopeTypeIndex = "2";
    } else if (envelopeType == "Credit Card") {
      envelopeTypeIndex = "3";
    }

    //If envelope name is Cash then specific textfeilds are disabled else enabled
    if (envelopeName == "Cash") {
      enable = false;
    } else {
      enable = true;
    }
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    focusNodeEnvelopeName.dispose();
    focusNodeInitialValue.dispose();
    focusNodeAdditionalNotes.dispose();
    super.dispose();
  }

  //if isStack is true then calculator is poped-up else calculator is not poped-up
  bool isStack = false;

  //if isButtonBar is true then button bar is displayed below the calculator else button bar is not displayed
  bool isButtonBar = false;

  //initial value of calculator which is 0
  static double currentValue = 0;

  //variable for doing validation for dropdown box
  bool validateDropDownButton = false;

  String hintTextForDropDownBox = "Select envelope type *";
  //setting autofocus to true
  // setAutoFocusTrue(){
  //   setState(() {
  //     autofocus=true;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: setNaturalGreenColor(),
        title: Text("Edit envelope"),
        leading: IconButton(
          onPressed: () {
            //clear all fields of new envelope page
            clearEnvelopeFeild();
            //Navigating back to homepage after pressing close button in app bar.
            Navigator.pop(context);
          },
          icon: Icon(Icons.close),
        ),
        actions: <Widget>[
         //delete button is displayed for all envelope name except for Cash
         enable ? IconButton(
              icon: Icon(Icons.delete),
              
              onPressed: () async{
                
                print("delete");
                LoginRegistrationPageState obj =
                    new LoginRegistrationPageState();
                var uid = await obj.getCurrentUserId();

                Firestore.instance
                    .collection('Envelopes')
                    .document(uid)
                    .collection('userData')
                    .document(documentID)
                    .delete();

              //after deleting navigating to home page
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return HomePage();
                  }));
              }): Container(),
              
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () async {
              if (_formKey.currentState.validate() && envelopeType != null) {
                //Creating object of Envelope class and passing envelope name and initial value of envelope in Envelope constructor.
                EnvelopeModel env = new EnvelopeModel(
                    envelopeNameinputController.text,
                    initialValueinputController.text);

                //appending env to listEnvelope
                addToList(env);
                LoginRegistrationPageState obj =
                    new LoginRegistrationPageState();
                var uid = await obj.getCurrentUserId();

                Firestore.instance
                    .collection('Envelopes')
                    .document(uid)
                    .collection('userData')
                    .document()
                    .setData({
                  'Envelope Name': envelopeNameinputController.text,
                  'Envelope Type': namesOfDropDown[int.parse(envelopeType)],
                  'Initial Value': initialValueinputController.text,
                  'Additional notes': additionalNotesinputController.text
                });

                //Navigating to home page after pressing  check button of app bar.
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return HomePage();
                }));

                //clear all envelope feilds
                clearEnvelopeFeild();
              } else {
                autoValidate = true;
                setState(() {
                  validateDropDownButton = true;
                });
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: envelopeForm(),
      ),
    );
  }

  //clear all fields of new envelope page
  clearEnvelopeFeild() {
    initialValueinputController.clear();
    envelopeNameinputController.clear();
    additionalNotesinputController.clear();
    setState(() {
      hintTextForDropDownBox = "Select envelope type *";
      envelopeTypeIndex = null;
    });
  }

  //Widget for Envelope form page design
  Widget envelopeForm() {
    print(envelopeName);
    print(additionalNotes);
    print(envelopeType);
    //print(HomePageState.listEnvelopeFirestoreData[2].documentID);
    return Form(
      key: _formKey,
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              TextFormField(
                //If envelope name is Cash then specific textfeilds are disabled else enabled
                enabled: enable,
                autovalidate: autoValidate,
                //autofocus: true,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Envelope name is required";
                  }
                  return null;
                },
                focusNode: focusNodeEnvelopeName,
                controller: envelopeNameinputController,

                decoration: InputDecoration(
                    focusedBorder: setFocusedBorder(),
                    labelText: "Envelope name",
                    labelStyle: changingFocus(focusNodeEnvelopeName)),
              ),
              SizedBox(
                height: 20.0,
              ),
              Stack(
                children: <Widget>[
                  Container(
                    child: IgnorePointer(
                       //If envelope name is Cash then drop down button is disabled else enabled
                      ignoring: enable ? false:true,
                      child: DropdownButton(
                        isExpanded: true,
                        onChanged: (value) {
                          setState(() {
                            envelopeTypeIndex = value;
                            validateDropDownButton = false;
                          });
                        },
                        value: envelopeTypeIndex,
                        items: itemsOfDropDown,
                        hint: Text(hintTextForDropDownBox),
                        underline: Container(
                            height: 1,
                            color: validateDropDownButton
                                ? Colors.red[700]
                                : Colors.grey),
                      ),
                    ),
                  ),
                  Positioned(
                    top: -0.5,
                    child: Text(
                      "Envelope type",
                      style: TextStyle(fontSize: 11.5, color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),

              validateDropDownButton
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Select your envelope type",
                          style:
                              TextStyle(color: Colors.red[700], fontSize: 12.0),
                        ),
                      ],
                    )
                  : Container(),

              //Textfield of initial value
              TextFormField(
                autovalidate: autoValidate,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter your initial value";
                  }
                  return null;
                },
                focusNode: focusNodeInitialValue,
                controller: initialValueinputController,
                decoration: InputDecoration(
                    focusedBorder: setFocusedBorder(),
                    labelText: "Initial value",
                    labelStyle: changingFocus(focusNodeInitialValue)),
                readOnly: true,
                onTap: () {
                  setState(() {
                    isStack = true;
                    isButtonBar = true;
                  });
                },
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                  //If envelope name is Cash then specific textfeilds are disabled else enabled
                  enabled: enable,
                  focusNode: focusNodeAdditionalNotes,
                  controller: additionalNotesinputController,
                  decoration: InputDecoration(
                    //Underline color of text field
                    focusedBorder: setFocusedBorder(),
                    labelText: "Additional notes",
                    hintText: "Optional",
                    labelStyle: changingFocus(focusNodeAdditionalNotes),
                  )),
            ],
          ),
          //For displaying buttonBar
          isButtonBar
              ? Positioned(
                  right: 36.5,
                  bottom: 100,
                  height: 50,
                  child: Container(
                    width: 270,
                    color: Color.fromRGBO(80, 213, 162, 1.0),
                    child: ButtonBar(
                      alignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        FlatButton(
                            onPressed: () {
                              //After pressing cancel button calculator will get closed
                              setState(() {
                                isStack = false;
                                isButtonBar = false;
                              });
                            },
                            child: Text(
                              "Cancel",
                              style: TextStyle(color: Colors.white),
                            )),
                        FlatButton(
                          onPressed: () {
                            //After pressing insert button the calculated value will get stored in the Initial value container and calculator will get closed
                            setState(() {
                              isStack = false;
                              isButtonBar = false;
                              initialValueinputController.text =
                                  currentValue.toString();
                            });
                          },
                          child: Text(
                            "Insert",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : Container(),
          //For displaying calculator
          isStack
              ? Positioned(
                  top: 100,
                  right: 36.5,
                  child: Stack(
                    children: <Widget>[
                      SizedBox(
                        height: 290,
                        width: 270,
                        child: SimpleCalculator(
                          theme: const CalculatorThemeData(
                              borderColor: Color.fromRGBO(80, 213, 162, 1.0),
                              displayColor: Color.fromRGBO(80, 213, 162, 1.0),
                              commandColor: Colors.white,
                              displayStyle: const TextStyle(
                                  fontSize: 80, color: Colors.white),
                              expressionColor: Color.fromRGBO(7, 226, 177, 1.0),
                              operatorColor: Color.fromRGBO(14, 205, 197, 1.0),
                              operatorStyle: TextStyle(color: Colors.black)),
                          value: currentValue,
                          hideExpression: false,
                          hideSurroundingBorder: false,
                          onChanged: (key, value, expression) {
                            setState(() {
                              currentValue = value;
                            });
                            print("$key\t$value\t$expression");
                          },
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  changingFocus(focusType) {
    return TextStyle(
        color: focusType.hasFocus ? setNaturalGreenColor() : Colors.grey);
  }

  static List<String> namesOfDropDown = [
    "Selected nothing",
    "Cash",
    "Bank",
    "Credit Card"
  ];

  //Items in dropdown
  List<DropdownMenuItem<String>> itemsOfDropDown = [
    getDropDownItem("1", Icon(Icons.attach_money), namesOfDropDown[1]),
    getDropDownItem("2", Icon(Icons.account_balance), namesOfDropDown[2]),
    getDropDownItem("3", Icon(Icons.credit_card), namesOfDropDown[3]),
  ];
}

//Arranging the items of dropdown in a specific UI pattern
getDropDownItem(String value, icon, String type) {
  return DropdownMenuItem(
    value: value,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[icon, Text(type)],
    ),
  );
}
