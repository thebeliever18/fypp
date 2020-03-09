import 'package:expense_tracker_app/decorations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:expense_tracker_app/categories.dart';

class TransactionListPage extends StatefulWidget {
  @override
  _TransactionListPageState createState() => _TransactionListPageState();
}

class _TransactionListPageState extends State<TransactionListPage> {
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
    return ListView(children: <Widget>[
      Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          elevation: 7.0,
          color: getRandomColor(),
          child: Container(
            height: 100,
            width: MediaQuery.of(context).size.width,
            child: Column(children: <Widget>[
              Expanded(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Date",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25.0))
                    ]),
              ),
              Expanded(
                child: Row(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left:8.0),
                    child: Text("Cash",
                        style: TextStyle(
                            color: Colors.white,
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
                        padding: const EdgeInsets.only(left:8.0),
                        child: Text("Food",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right:8.0),
                        child: Text("1000",
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0)),
                      ),
                    ]),
              ),
            ]),
          )),
    ]);
  }
}
