import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker_app/decorations.dart';
import 'package:expense_tracker_app/login_registration_page.dart';
import 'package:expense_tracker_app/transaction_module/transaction_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TransactionListPage extends StatefulWidget {
  @override
  TransactionListPageState createState() => TransactionListPageState();
}

class TransactionListPageState extends State<TransactionListPage> {
  //variable for storing user id
  String uid;

  //variable for storing data of transaction
  var listOfTransaction;

  bool displayData = false;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    getTransactionsData();
  }

  getTransactionsData() async {
    LoginRegistrationPageState obj = new LoginRegistrationPageState();
    uid = await obj.getCurrentUserId();

    QuerySnapshot querySnapshot = await Firestore.instance
        .collection('Transactions')
        .document(uid)
        .collection('transactionData')
        .getDocuments();

    //storing extracted list of documents in a variable
    listOfTransaction = querySnapshot.documents;

    //boolean value displayData is set to true if the extracted list from firestore is not null
    if (listOfTransaction != null) {
      setState(() {
        displayData = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transactions List"),
        backgroundColor: setNaturalGreenColor(),
      ),
      body: transactionListPageBody(),
    );
  }

  //decoration for the cards of transaction list page
  Widget transactionListPageBody() {
    if (displayData == true) {
      return ListView(children: <Widget>[
        for (var i = 0; i < listOfTransaction.length; i++)
          Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              elevation: 7.0,
              color: Colors.white,
              child: Container(
                height: 100,
                width: MediaQuery.of(context).size.width,
                child: InkWell(
                  onTap: () {
                    //Navigating to edit transaction page
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return TransactionPage(true,
                      listOfTransaction[i].data['Amount'],
                      listOfTransaction[i].data['Memo'],
                      listOfTransaction[i].data['Transaction Type'],
                      payerOrPayee(listOfTransaction[i].data['Transaction Type'],i),
                      listOfTransaction[i].data['Category'],
                      listOfTransaction[i].data['Envelope'],
                      listOfTransaction[i].data['Date'],
                      listOfTransaction[i].documentID,
                      uid
                      );
                    }));
                  },
                  child: Column(children: <Widget>[
                    Expanded(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("${listOfTransaction[i].data['Date']}",
                                style: TextStyle(
                                    color: setNaturalGreenColor(),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25.0))
                          ]),
                    ),
                    Expanded(
                      child: Row(children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                              "${listOfTransaction[i].data['Envelope']}",
                              style: TextStyle(
                                  color: setNaturalGreenColor(),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0)),
                        ),
                      ]),
                    ),
                    Expanded(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                  "${listOfTransaction[i].data['Category']}",
                                  style: TextStyle(
                                      color: setNaturalGreenColor(),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: decorationForAmount(i),
                            ),
                          ]),
                    ),
                  ]),
                ),
              )),
      ]);
    }
    return Center(child: CircularProgressIndicator());
  }

  payerOrPayee(String transactionType,i){
    if (transactionType=="Expense") {
      return listOfTransaction[i].data['Payee'];
    } else if(transactionType=="Income"){
      return listOfTransaction[i].data['Payer'];
    }
  }

  decorationForAmount(i) {
    //if transaction type is income
    if (listOfTransaction[i].data['Transaction Type'] == "Income") {
      return Text("${"+" + listOfTransaction[i].data['Amount']}",
          style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 20.0));
    } else if (listOfTransaction[i].data['Transaction Type'] == "Expense") {
      return Text("${"-" + listOfTransaction[i].data['Amount']}",
          style: TextStyle(
              color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20.0));
    }
  }
}
