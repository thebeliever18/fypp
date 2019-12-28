import 'package:expense_tracker_app/home_page.dart';
import 'package:expense_tracker_app/envelope_model.dart';
import 'package:expense_tracker_app/decorations.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';

//Class for Add Envelope Page design
class AddEnvelopePage extends StatefulWidget {
  @override
  AddEnvelopePageState createState() => AddEnvelopePageState();
}

//Selected item in dropdown
String _dropDownValue;

class AddEnvelopePageState extends State<AddEnvelopePage> {
  /*
   * _initialValueinputController is a TextEditingController of Intial Value textfield.
   *  envelopeNameinputController is a TextEditingController of Envelope name textfield.
   *  additionalNotesinputController is a TextEditingController of Additional notes textfield.
   */

  static final initialValueinputController = TextEditingController();
  static final envelopeNameinputController = TextEditingController();
  static final additionalNotesinputController = TextEditingController();

  /*
   * FocusNode is an object that can be used by a stateful widget to obtain the keyboard focus and to handle keyboard events.
   * focusNodeEnvelopeName is a Focus Node of Envelope Name textfield
   * focusNodeInitialValue is a Focus Node of Initial Value textfield
   * focusNodeAdditionalNotes is a Focus Node of Additional notes textfield
   */

  FocusNode focusNodeEnvelopeName = new FocusNode();
  FocusNode focusNodeInitialValue = new FocusNode();
  FocusNode focusNodeAdditionalNotes = new FocusNode();

  //bool autofocus=false;
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
        backgroundColor: Color.fromRGBO(80, 213, 162, 1.0),
        leading: IconButton(
          onPressed: () {
            //Navigating back to homepage after pressing close button in app bar.
            Navigator.pop(context);
          },
          icon: Icon(Icons.close),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              //Creating object of Envelope class and passing envelope name and initial value of envelope in Envelope constructor.
              EnvelopeModel env = new EnvelopeModel(
                  envelopeNameinputController.text,
                  initialValueinputController.text);

              //appending env to listEnvelope
              addToList(env);

              //Navigating to home page after pressing  check button of app bar.
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return HomePage();
              }));
            },
          )
        ],
        title: Text("New Envelope"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: envelopeForm(),
      ),
    );
  }

  //Widget for Envelope form page design
  Widget envelopeForm() {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            TextField(
              //autofocus: true,
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
                  child: DropdownButton(
                    isExpanded: true,
                    onChanged: (value) {
                      setState(() {
                        _dropDownValue = value;
                      });
                    },
                    value: _dropDownValue,
                    items: itemsOfDropDown,
                    hint: Text("Select envelope type *"),
                    underline: Container(
                      height: 1,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Positioned(
                  top: -0.5,
                  child: Text(
                    "Envelope type",
                    style: TextStyle(fontSize: 11.5, color: Colors.grey[600]),
                  ),
                )
              ],
            ),

            //Textfield of initial value
            TextField(
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
                        child: Text("Cancel",style: TextStyle(
                          color: Colors.white),
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
                        child: Text("Insert",style: TextStyle(
                          color: Colors.white
                        ),),
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
                          operatorStyle: TextStyle(color: Colors.black)
                        ),
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
    );
  }

  changingFocus(focusType) {
    return TextStyle(
        color: focusType.hasFocus ? setNaturalGreenColor() : Colors.grey);
  }

  //Items in dropdown
  List<DropdownMenuItem<String>> itemsOfDropDown = [
    getDropDownItem("1", Icon(Icons.attach_money), "Cash"),
    getDropDownItem("2", Icon(Icons.account_balance), "Bank"),
    getDropDownItem("3", Icon(Icons.credit_card), "Credit Card"),
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
