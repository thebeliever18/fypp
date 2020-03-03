import 'package:expense_tracker_app/decorations.dart';
import 'package:expense_tracker_app/transaction_module/display_category_page.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TransactionPage extends StatefulWidget {
  @override
  TransactionPageState createState() => TransactionPageState();
}

class TransactionPageState extends State<TransactionPage> {
  bool isSwitched = false;
  FocusNode focusNodeAmount = new FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    focusNodeAmount.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.

    focusNodeAmount.dispose();
    super.dispose();
  }

  String _information = 'Choose category';

  void updateInformation(String information) {
    setState(() => _information = information);
  }

  void moveToDisplayCategoryPage() async {
    final information =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return DisplayCategoryPage();
    }));

    updateInformation(information);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Add Transaction"),
        backgroundColor: setNaturalGreenColor(),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
            top: 15.0, left: 10.0, right: 10.0, bottom: 5.0),
        child: Column(
          children: <Widget>[
            Container(
              height: 55.0,
              color: Colors.grey[50],
              child: Row(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Positioned(
                          top: 11.0,
                          child: Text(
                            "Income",
                            style: TextStyle(
                                fontSize: 12.0,
                                color: isSwitched ? Colors.grey : Colors.green),
                          )),
                      Positioned(
                        top: 11.0,
                        child: Text(
                          "Expense",
                          style: TextStyle(
                              fontSize: 12.0,
                              color: isSwitched ? Colors.red : Colors.grey),
                        ),
                        left: 60.0,
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 20.0),
                        width: 100.0,
                        child: Switch(
                          value: isSwitched,
                          onChanged: (value) {
                            setState(() {
                              isSwitched = value;
                              print(isSwitched);
                            });
                          },
                          activeTrackColor: Colors.red,
                          activeColor: Colors.red,
                          inactiveTrackColor: Colors.green,
                          inactiveThumbColor: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Container(
                        height: 55,
                        child: TextField(
                          style: TextStyle(
                              color: isSwitched ? Colors.red : Colors.green),
                          focusNode: focusNodeAmount,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              focusedBorder: setFocusedBorder(),
                              //Underline color of text field
                              filled: true,
                              fillColor: Colors.grey[50],
                              labelText: "Amount",
                              labelStyle: changingFocus(focusNodeAmount)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            divider(),
            Container(
              height: 55.0,
              color: Colors.grey[50],
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          isSwitched ? "Payee:" : "Payer:",
                          style: TextStyle(fontSize: 12.0),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        width: 221,
                        child: TextField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            focusedBorder: setFocusedBorder(),
                            //Underline color of text field
                            filled: true,
                            fillColor: Colors.grey[50],
                            labelText: isSwitched ? "Payee" : "Payer",
                            //labelStyle: changingFocus(focusNodeAmount)
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            divider(),
            GestureDetector(
              onTap: () {
                print("helo");
                moveToDisplayCategoryPage();
              },
              child: Container(
                  height: 55.0,
                  color: Colors.grey[50],
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Category:",
                              style: TextStyle(fontSize: 12.0),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 210,
                            child: Text(
                              _information,
                              style:
                                  TextStyle(fontSize: 17.0, color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  divider() {
    return Divider(color: Colors.white);
  }

  changingFocus(focusType) {
    return TextStyle(
        color: focusType.hasFocus ? setNaturalGreenColor() : Colors.grey);
  }
}
