import 'package:expense_tracker_app/home_page.dart';
import 'package:expense_tracker_app/envelope_model.dart';

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
   */

  static final initialValueinputController = TextEditingController();
  static final envelopeNameinputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //initializing the initial value of the textfeild 0 at first run
    // setState(() {
    //   _inputController.text = "0.0";
    // });
  }

  //if isStack is true then calculator is poped-up else calculator is not poped-up
   bool isStack = false;

  //if isButtonBar is true then button bar is displayed below the calculator else button bar is not displayed
   bool isButtonBar = false;

  //initial value of calculator which is 0
  static double currentValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              EnvelopeModel env = new EnvelopeModel(envelopeNameinputController.text,
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
              controller: envelopeNameinputController,
              decoration: InputDecoration(labelText: "Envelope name"),
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
              controller: initialValueinputController,
              decoration: InputDecoration(labelText: "Initial value"),
              readOnly: true,
              onTap: () {
                setState(() {
                  isStack = true;
                  isButtonBar = true;
                });
              },
            ),
          ],
        ),

        //For displaying buttonBar
        isButtonBar
             ?
             Positioned(
                right: 36.5,
                bottom: 100,
                height: 50,
                child: Container(
                  width: 270,
                  color: Colors.red,
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
                        child: Text("Cancel"),
                      ),
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
                        child: Text("Insert"),
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
                          borderColor: Colors.black,
                          displayColor: Colors.black,
                          commandColor: Colors.orange,
                          displayStyle: const TextStyle(
                              fontSize: 80, color: Colors.yellow),
                          expressionColor: Colors.indigo,
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
            : Container()
      ],
    );
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
