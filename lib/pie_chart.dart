import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker_app/decorations.dart';
import 'package:expense_tracker_app/login_registration_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class PieChart extends StatefulWidget {
  @override
  _PieChartState createState() => _PieChartState();
}

class _PieChartState extends State<PieChart> {
  List<charts.Series<PieChartCategory, String>> _seriesData;
  String uid;
  var listOfTransaction;
  _generateData() {
    var piedata = [
      PieChartCategory('Work', 35.8, Color(0xff3366cc)),
      PieChartCategory('Eat', 8.3, Color(0xff990099)),
      PieChartCategory('Commute', 10.8, Color(0xff109618)),
      PieChartCategory('TV', 15.6, Color(0xfffdbe19)),
      PieChartCategory('Sleep', 19.2, Color(0xffff9900)),
      PieChartCategory('Other', 10.3, Color(0xffdc3912)),
    ];

    _seriesData.add(
      charts.Series(
        domainFn: (PieChartCategory pieChartCategory, _) =>
            pieChartCategory.categoryName,
        measureFn: (PieChartCategory pieChartCategory, _) =>
            pieChartCategory.amount,
        colorFn: (PieChartCategory pieChartCategory, _) =>
            charts.ColorUtil.fromDartColor(pieChartCategory.colorVal),
        id: 'Category Data',
        data: piedata,
        labelAccessorFn: (PieChartCategory row, _) => '${row.amount}',
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _seriesData = List<charts.Series<PieChartCategory, String>>();
    _generateData();

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
      displayDataOfTransaction();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Reports"),
          backgroundColor: setNaturalGreenColor(),
          //backgroundColor: Color(0xff308e1c),
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                text: "Income",
              ),
              Tab(
                text: "Expense",
              ),
            ],
          ),
        ),
        body: pieChartBody(),
      ),
    );
  }

  pieChartBody() {
    return TabBarView(children: [
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                Text(
                  'Income made from specific categories',
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Expanded(
                  child: charts.PieChart(_seriesData,
                      animate: true,
                      animationDuration: Duration(seconds: 5),
                      behaviors: [
                        new charts.DatumLegend(
                          outsideJustification:
                              charts.OutsideJustification.endDrawArea,
                          horizontalFirst: true,
                          //desiredMaxRows: 2,
                          cellPadding:
                              new EdgeInsets.only(right: 4.0, bottom: 4.0),
                          entryTextStyle: charts.TextStyleSpec(fontSize: 11),
                        )
                      ],
                      defaultRenderer: new charts.ArcRendererConfig(
                          arcWidth: 100,
                          arcRendererDecorators: [
                            new charts.ArcLabelDecorator(
                                labelPosition: charts.ArcLabelPosition.inside)
                          ])),
                ),
              ],
            ),
          ),
        ),
      ),
      Container(child: Text("hello"))
    ]);
  }

  displayDataOfTransaction() {
    List incomeCategoryList = [];
    double sum = 0;
    List incomeAmounts = [];
    //List uniqueCategoryList = [];

    for (var i = 0; i < listOfTransaction.length; i++) {
      //print(listOfTransaction[i].data["Category Name"]);
      if (listOfTransaction[i].data["Transaction Type"] == "Income") {
        incomeCategoryList.add(listOfTransaction[i].data["Category"].trim());
      }
    }

    List uniqueCategoryList=incomeCategoryList.toSet().toList();

    // for (var i = 0; i < incomeCategoryList.length; i++) {
    //   for (var j = 0; j < incomeCategoryList.length; j++) {
    //     if (incomeCategoryList[i] == incomeCategoryList[i + 1]) {
    //       incomeCategoryList.removeAt(i+1);
          
    //     }
    //   }
    // }

    // for (var i = 0; i < incomeCategoryList.length - 1; i++) {
    //   if (incomeCategoryList[i] == incomeCategoryList[i + 1]) {
    //     incomeCategoryList.removeAt(i);
    //     i=i-1;
    //   }
    // }

    // for (var i = 0; i < incomeCategoryList.length; i++) {
    //   if (addUniqueCategoryList.isEmpty) {
    //     addUniqueCategoryList.add(incomeCategoryList[i]);
    //   }else if(addUniqueCategoryList.isNotEmpty){
    //     for (var j = 0; j < addUniqueCategoryList.length; j++) {
    //       if (addUniqueCategoryList[j]!=incomeCategoryList[i]) {
    //         addUniqueCategoryList.add(incomeCategoryList[i]);
    //       }
    //     }
    //   }
    // }

    for (var i = 0; i < uniqueCategoryList.length; i++) {
      print(uniqueCategoryList[i]);
    }

    for (var i = 0; i < incomeCategoryList.length; i++) {
      for (var j = 0; j < listOfTransaction.length; j++) {
        if (incomeCategoryList[i] == listOfTransaction[j].data["Category"]) {
          sum = sum + double.parse(listOfTransaction[j].data["Amount"]);
        }

        while (j == listOfTransaction.length - 1) {
          incomeAmounts.add(sum);
          sum = 0;
          break;
        }
      }
    }
  }
}

class PieChartCategory {
  String categoryName;
  double amount;
  Color colorVal;

  PieChartCategory(this.categoryName, this.amount, this.colorVal);
}
