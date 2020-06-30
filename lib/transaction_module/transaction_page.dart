import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker_app/bottom_navigation_bar.dart';
import 'package:expense_tracker_app/decorations.dart';
import 'package:expense_tracker_app/envelope_reorderable_listview.dart';
import 'package:expense_tracker_app/home_page.dart';
import 'package:expense_tracker_app/login_registration_page.dart';
import 'package:expense_tracker_app/transaction_module/display_category_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Class for transaction page
class TransactionPage extends StatefulWidget {
  bool displayEditTransactionPage;

  String amount,
      memo,
      transactiontype,
      payerOrPayee,
      category,
      envelope,
      displayDate,
      documentID,
      uid;
  TransactionPage(
      [this.displayEditTransactionPage,
      this.amount,
      this.memo,
      this.transactiontype,
      this.payerOrPayee,
      this.category,
      this.envelope,
      this.displayDate,
      this.documentID,
      this.uid]);
  @override
  TransactionPageState createState() => TransactionPageState(
      this.displayEditTransactionPage,
      this.amount,
      this.memo,
      this.transactiontype,
      this.payerOrPayee,
      this.category,
      this.envelope,
      this.displayDate,
      this.documentID,
      this.uid);
}

class TransactionPageState extends State<TransactionPage> {
  bool displayEditTransactionPage;
  String amount,
      memo,
      transactiontype,
      payerOrPayee,
      category,
      envelope,
      displayDate,
      documentID,
      uid;
  TransactionPageState(
      this.displayEditTransactionPage,
      this.amount,
      this.memo,
      this.transactiontype,
      this.payerOrPayee,
      this.category,
      this.envelope,
      this.displayDate,
      this.documentID,
      this.uid);

  //bool isSwitched for changing the state of switch
  bool isSwitched = false;

  //Focus node for amount textfeild
  FocusNode focusNodeAmount = new FocusNode();

  //Focus node for payer/payee textfeild
  FocusNode focusNodePay = new FocusNode();

  //Focus node for memo textfeild
  FocusNode focusNodeMemo = new FocusNode();

  
  DateTime _dateTime;

  String buttonText = "Save Transaction";

  var amountController = TextEditingController();
  var payerOrPayeeController = TextEditingController();
  var memoController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List information;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    focusNodeAmount.addListener(() {
      setState(() {});
    });

    focusNodePay.addListener(() {
      setState(() {});
    });

    focusNodeMemo.addListener(() {
      setState(() {});
    });

    if (displayEditTransactionPage == true) {
      editTransaction();
    }
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    focusNodeAmount.dispose();
    focusNodePay.dispose();
    focusNodeMemo.dispose();
    super.dispose();
  }

  String _categoryInformation = 'Choose category';

  String _envelopeInformation = 'Choose envelope';

  void updateInformationOfCategory(String information) {
    setState(() => _categoryInformation = information);
  }

  void updateInformationOfEnvelope(information) {
    if (information == null) {
      setState(() => _envelopeInformation = 'Choose envelope');
    } else {
      setState(() => _envelopeInformation = information[0]);
    }
  }

  void moveToDisplayCategoryPage() async {
    final information =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return DisplayCategoryPage();
    }));

    updateInformationOfCategory(information);
  }

  void moveToDisplayEnvelopePage() async {
    information =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EnvelopeReorderableListView(true);
    }));

    updateInformationOfEnvelope(information);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: displayEditTransactionPage
            ? Text("Edit Transaction")
            : Text("Add Transaction"),
        backgroundColor: setNaturalGreenColor(),
        leading: IconButton(icon: Icon(Icons.close), onPressed: (){
          Navigator.of(context).pop();
        }),
        actions: <Widget>[
          displayEditTransactionPage
              ? IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Text("Are you sure you want to delete?"),
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
                                  "Delete",
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () async {
                                  Firestore.instance
                                      .collection('Transactions')
                                      .document(uid)
                                      .collection('transactionData')
                                      .document(documentID)
                                      .delete();

                                  final snackBar = SnackBar(
                                    content:
                                        Text('Your transaction is deleted'),
                                    duration: Duration(seconds: 1),
                                  );

                                  _scaffoldKey.currentState
                                      .showSnackBar(snackBar);

                                  //after deleting navigating to home page
                                  Future.delayed(const Duration(seconds: 2),
                                      () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return ClassBottomNavigationBar();
                                    }));
                                  });
                                },
                              ),
                            ],
                          );
                        });
                  })
              : Container(),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Padding(
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
                                    color: isSwitched
                                        ? Colors.grey
                                        : Colors.green),
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
                              controller: amountController,
                              style: TextStyle(
                                  color:
                                      isSwitched ? Colors.red : Colors.green),
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
                              controller: payerOrPayeeController,
                              focusNode: focusNodePay,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  focusedBorder: setFocusedBorder(),
                                  //Underline color of text field
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                  labelText: isSwitched ? "Payee" : "Payer",
                                  labelStyle: changingFocus(focusNodePay)),
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
                                  _categoryInformation ?? "Choose category",
                                  style: TextStyle(
                                      fontSize: 17.0, color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                ),
                divider(),
                GestureDetector(
                  onTap: () {
                    moveToDisplayEnvelopePage();
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
                                  "Envelope:",
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
                                  _envelopeInformation ?? "Choose envelope",
                                  style: TextStyle(
                                      fontSize: 17.0, color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                ),
                divider(),
                GestureDetector(
                  onTap: () {
                    print("helo");
                    showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2222))
                        .then((date) {
                      setState(() {
                        _dateTime = date;
                        displayDate = null;
                      });
                    });
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
                                  "Date:",
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
                                  covertDateTime(_dateTime),
                                  style: TextStyle(
                                      fontSize: 17.0, color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                ),
                divider(),
                Container(
                    height: 30.0,
                    color: Colors.grey[400],
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 2.0),
                                child: Text(
                                  "Optional",
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
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
                              "Memo:",
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
                              controller: memoController,
                              focusNode: focusNodeMemo,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  focusedBorder: setFocusedBorder(),
                                  //Underline color of text field
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                  labelText: "Memo",
                                  hintText: "Enter a memo",
                                  labelStyle: changingFocus(focusNodeMemo)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                divider(),
                ButtonTheme(
                  buttonColor: Color.fromRGBO(80, 213, 162, 1.0),
                  height: 37,
                  minWidth: MediaQuery.of(context).size.width,
                  child: RaisedButton(
                      child: Text("$buttonText",
                          style:
                              TextStyle(fontSize: 16.0, color: Colors.white)),
                      onPressed: () {
                        transactionPageFirebaseConnection();
                      }),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  transactionPageFirebaseConnection() async {
    saveOrUpdateTransaction() async {
      try {
        var snackBar;
        LoginRegistrationPageState obj = new LoginRegistrationPageState();
        var uid = await obj.getCurrentUserId();

        if (buttonText == "Save Transaction") {
          await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content:
                      Text("Are you sure you want to save the transaction?"),
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
                        "Save",
                        style: TextStyle(color: Colors.green),
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        Firestore.instance
                            .collection('Transactions')
                            .document(uid)
                            .collection('transactionData')
                            .document()
                            .setData({
                          'Transaction Type': isSwitched ? "Expense" : "Income",
                          'Amount': amountController.text,
                          isSwitched ? 'Payee' : 'Payer':
                              payerOrPayeeController.text,
                          'Category': _categoryInformation,
                          'Envelope': _envelopeInformation,
                          'Date': covertDateTime(_dateTime),
                          'Memo': memoController.text,
                        });

                        snackBar = SnackBar(
                          content: Text('Your transaction is saved'),
                          duration: Duration(seconds: 2),
                        );
                      },
                    ),
                  ],
                );
              });
        } else if (buttonText == "Update Transaction") {
          await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Text("Are you sure you want to update?"),
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
                        "Update",
                        style: TextStyle(color: Colors.green),
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        Firestore.instance
                            .collection('Transactions')
                            .document(uid)
                            .collection('transactionData')
                            .document(documentID)
                            .updateData({
                          'Transaction Type': isSwitched ? "Expense" : "Income",
                          'Amount': amountController.text,
                          isSwitched ? 'Payee' : 'Payer':
                              payerOrPayeeController.text,
                          'Category': _categoryInformation,
                          'Envelope': _envelopeInformation,
                          'Date': covertDateTime(_dateTime),
                          'Memo': memoController.text,
                        });
                        snackBar = SnackBar(
                          content: Text('Your transaction is updated'),
                          duration: Duration(seconds: 2),
                        );
                      },
                    ),
                  ],
                );
              });
        }

        _scaffoldKey.currentState.removeCurrentSnackBar();
        _scaffoldKey.currentState.showSnackBar(snackBar);

        clearTransactionFeild();

        //Navigating to home page after pressing  save transaction button.
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ClassBottomNavigationBar();
          }));
        });

        //Navigator.of(context).pop();
      } catch (e) {
        final snackBar = SnackBar(
          content: Text('$e'),
          duration: Duration(seconds: 3),
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
        _scaffoldKey.currentState.removeCurrentSnackBar();
      }
    }

    //validation
    if (amountController.text.isEmpty) {
      final snackBar = SnackBar(
        content: Text('Please enter the amount'),
        duration: Duration(seconds: 3),
      );

      // Find the Scaffold in the widget tree and use it to show a SnackBar.
      _scaffoldKey.currentState.showSnackBar(snackBar);
    } else if (double.tryParse(amountController.text) is! double) {
      final snackBar = SnackBar(
        content: Text('Please enter number not text in amount'),
        duration: Duration(seconds: 3),
      );

      // Find the Scaffold in the widget tree and use it to show a SnackBar.
      _scaffoldKey.currentState.showSnackBar(snackBar);
    } else if (payerOrPayeeController.text.isEmpty) {
      final snackBar = SnackBar(
        content: isSwitched
            ? Text('Please enter payee')
            : Text('Please enter payer'),
        duration: Duration(seconds: 3),
      );

      _scaffoldKey.currentState.showSnackBar(snackBar);
    } else if (_categoryInformation == 'Choose category' ||
        _categoryInformation == null) {
      final snackBar = SnackBar(
        content: Text('Please choose a category'),
        duration: Duration(seconds: 3),
      );

      _scaffoldKey.currentState.showSnackBar(snackBar);
    } else if (_envelopeInformation == 'Choose envelope' ||
        _envelopeInformation == null) {
      final snackBar = SnackBar(
        content: Text('Please choose an envelope'),
        duration: Duration(seconds: 3),
      );

      _scaffoldKey.currentState.showSnackBar(snackBar);
    } else if (covertDateTime(_dateTime) == 'Choose date') {
      final snackBar = SnackBar(
        content: Text('Please select your date'),
        duration: Duration(seconds: 3),
      );

      _scaffoldKey.currentState.showSnackBar(snackBar);
    } else if (isSwitched == true &&
        _envelopeInformation != "Choose envelope" && buttonText=="Save Transaction") {
      var snackBar;
      var returnedValue = calculationForTheValidationOfAmount(
          _envelopeInformation, double.parse(information[1]));

      //if no transaction is done yet in a specific envelope
      if (returnedValue == "No transaction") {
        //checking entered amount with the initial amount of the envelope
        if (double.parse(amountController.text) >
            double.parse(information[1])) {
          snackBar = SnackBar(
            content: Text(
                'Expense amount exceeded. Please check the amount and try again.'),
            duration: Duration(seconds: 3),
          );
          _scaffoldKey.currentState.showSnackBar(snackBar);
        } else if (double.parse(amountController.text) <
            double.parse(information[1])) {
          saveOrUpdateTransaction();
        }
        //checking entered amount with the calculated transaction amount
      } else if (double.parse(amountController.text) > returnedValue) {
        snackBar = SnackBar(
          content: Text(
              'Expense amount exceeded. Please check the amount and try again.'),
          duration: Duration(seconds: 3),
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
      } else if (double.parse(amountController.text) < returnedValue) {
        saveOrUpdateTransaction();
      }

      
    } else {
      saveOrUpdateTransaction();
    }
  }

  //clear all fields of transaction page
  clearTransactionFeild() {
    amountController.clear();
    payerOrPayeeController.clear();
    memoController.clear();
    setState(() {
      _categoryInformation = "Choose category";
      _envelopeInformation = "Choose envelope";
      _dateTime = null;
    });
  }

  covertDateTime(_dateTime) {
    if (_dateTime == null && displayDate == null) {
      return "Choose date";
    } else if (displayDate is String) {
      return "$displayDate";
    } else {
      var date = DateTime.parse("$_dateTime");
      var formattedDate = "${date.day}-${date.month}-${date.year}";
      return formattedDate;
    }
  }

  divider() {
    return Divider(color: Colors.white);
  }

  changingFocus(focusType) {
    return TextStyle(
        color: focusType.hasFocus ? setNaturalGreenColor() : Colors.grey);
  }

  editTransaction() {
    if (transactiontype == "Expense") {
      setState(() {
        isSwitched = true;
      });
    } else if (transactiontype == "Income") {
      setState(() {
        isSwitched = false;
      });
    }

    amountController = TextEditingController(text: amount);

    memoController = TextEditingController(text: memo);

    payerOrPayeeController = TextEditingController(text: payerOrPayee);

    _categoryInformation = category;

    _envelopeInformation = envelope;

    buttonText = "Update Transaction";

    print(amount);
    print(memo);

    print(_categoryInformation);
    print(_envelopeInformation);
  }
}
