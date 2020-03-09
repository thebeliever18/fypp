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

  Widget transactionListPageBody() {
    return ListView(children: <Widget>[
      Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          elevation: 10.0,
          color: getRandomColor(),
          child: Container(
            height: 100,
            width: MediaQuery.of(context).size.width,
            child: Column(children: <Widget>[
              Expanded(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[Text("Date")]),
              ),
              Expanded(
                child: Row(children: <Widget>[
                  Text("Cash"),
                ]),
              ),
              Expanded(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Food"),
                      Text("1000", style: TextStyle(color: Colors.green)),
                    ]),
              ),
            ]),
          )),
    ]);
  }
}
