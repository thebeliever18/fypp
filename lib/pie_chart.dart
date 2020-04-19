import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker_app/bottom_navigation_bar.dart';
import 'package:expense_tracker_app/categories.dart';
import 'package:expense_tracker_app/decorations.dart';
import 'package:expense_tracker_app/login_registration_page.dart';
import 'package:expense_tracker_app/shopping_module/shopping_list_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:random_color/random_color.dart';

class PieChart extends StatefulWidget {
  @override
  _PieChartState createState() => _PieChartState();
}

class _PieChartState extends State<PieChart> {
  List<charts.Series<PieChartCategory, String>> _incomeSeriesData;
  List<charts.Series<PieChartCategory, String>> _expenseSeriesData;

   //_scaffoldKey is a global key that is unique across the entire app.
  final GlobalKey<ScaffoldState> _scafoldKey = new GlobalKey<ScaffoldState>();
  String uid;
  var listOfTransaction;
  bool displayPieChart = false;

//Method for generating random color
  getRandomColor() {
    RandomColor randomColor = RandomColor();
    Color color = randomColor.randomColor();
    return color;
  }

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
      displayDataOfTransaction();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scafoldKey,
        body: pieChartBody(),
        appBar: AppBar(
          title: Text("Reports"),
          backgroundColor: setNaturalGreenColor(),
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
          leading: Row(
            children: <Widget>[
              SizedBox(
                width: 9,
              ),
              Card(
                elevation: 3.0,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Container(
                  height: 30,
                  width: 30,
                  child: IconButton(
                    icon: Image.asset(
                      "images/logoET.png",
                      fit: BoxFit.cover,
                    ),
                    onPressed: () {
                      /*
                       * currentState is the state for the widget in the tree that currently has a global key.
                       * openDrawer() is the method which opens the drawer.
                       */
                      _scafoldKey.currentState.openDrawer();
                    },
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(200),
                ),
              )
            ],
          )),
      drawer: Drawer(
        elevation: 1.0,
        child: drawerItems(context),
      ),
      ),
    );
  }

  pieChartBody() {
    if (displayPieChart == true) {
      return TabBarView(children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
            child: Center(
              child: Column(
                children: <Widget>[
                  //piechart for income
                  Text(
                    'Income made from specific categories',
                    style:
                        TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),

                  Expanded(
                    child: charts.PieChart(_incomeSeriesData,
                        animate: true,
                        animationDuration: Duration(seconds: 5),
                        behaviors: [
                          new charts.DatumLegend(
                            outsideJustification:
                                charts.OutsideJustification.endDrawArea,
                            horizontalFirst: false,
                            desiredMaxRows: 2,
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
        //piechart for expense
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
            child: Center(
              child: Column(
                children: <Widget>[
                  //piechart for income
                  Text(
                    'Expense made from specific categories',
                    style:
                        TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),

                  Expanded(
                    child: charts.PieChart(_expenseSeriesData,
                        animate: true,
                        animationDuration: Duration(seconds: 5),
                        behaviors: [
                          new charts.DatumLegend(
                            outsideJustification:
                                charts.OutsideJustification.endDrawArea,
                            horizontalFirst: false,
                            desiredMaxRows: 2,
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
      ]);
    } else if (displayPieChart == false) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  displayDataOfTransaction() {
    List incomeCategoryList = [];
    List expenseCategoryList=[];
    double incomeSum = 0;
    double expenseSum=0;
    List incomeAmounts = [];
    List expenseAmounts=[];
    //List uniqueCategoryList = [];

    for (var i = 0; i < listOfTransaction.length; i++) {
      //print(listOfTransaction[i].data["Category Name"]);
      if (listOfTransaction[i].data["Transaction Type"] == "Income") {
        incomeCategoryList.add(listOfTransaction[i].data["Category"].trim());
      }else if(listOfTransaction[i].data["Transaction Type"] == "Expense"){
        expenseCategoryList.add(listOfTransaction[i].data["Category"].trim());
      }
    }

    List uniqueIncomeCategoryList = incomeCategoryList.toSet().toList();
    List uniqueExpenseCategoryList = expenseCategoryList.toSet().toList();
    

    for (var i = 0; i < uniqueExpenseCategoryList.length; i++) {
      print(uniqueExpenseCategoryList[i]);
    }

    //for income
    for (var i = 0; i < uniqueIncomeCategoryList.length; i++) {
      for (var j = 0; j < listOfTransaction.length; j++) {
        if (uniqueIncomeCategoryList[i] ==
            listOfTransaction[j].data["Category"].trim()) {
          if (listOfTransaction[j].data["Transaction Type"] == "Income") {
            incomeSum =
                incomeSum + double.parse(listOfTransaction[j].data["Amount"]);
          }
        }

        while (j == listOfTransaction.length - 1) {
          incomeAmounts.add(incomeSum);
          incomeSum = 0;
          break;
        }
      }
    }


    //for expense
    for (var i = 0; i < uniqueExpenseCategoryList.length; i++) {
      for (var j = 0; j < listOfTransaction.length; j++) {
        if (uniqueExpenseCategoryList[i] ==
            listOfTransaction[j].data["Category"].trim()) {
          if (listOfTransaction[j].data["Transaction Type"] == "Expense") {
            expenseSum =
                expenseSum + double.parse(listOfTransaction[j].data["Amount"]);
          }
        }

        while (j == listOfTransaction.length - 1) {
          expenseAmounts.add(expenseSum);
          expenseSum = 0;
          break;
        }
      }
    }

    for (var i = 0; i < expenseAmounts.length; i++) {
      print(expenseAmounts[i]);
    }

    _generateData(uniqueIncomeCategoryList, incomeAmounts,uniqueExpenseCategoryList,expenseAmounts);
  }

  _generateData(uniqueIncomeCategoryList, incomeAmounts,uniqueExpenseCategoryList,expenseAmounts) {
    _incomeSeriesData = List<charts.Series<PieChartCategory, String>>();

    var incomePiedata = [
      for (var i = 0; i < uniqueIncomeCategoryList.length; i++)
        PieChartCategory('${uniqueIncomeCategoryList[i]}', incomeAmounts[i],
            getRandomColor()),
    ];

    _incomeSeriesData.add(
      charts.Series(
        domainFn: (PieChartCategory pieChartCategory, _) =>
            pieChartCategory.categoryName,
        measureFn: (PieChartCategory pieChartCategory, _) =>
            pieChartCategory.amount,
        colorFn: (PieChartCategory pieChartCategory, _) =>
            charts.ColorUtil.fromDartColor(pieChartCategory.colorVal),
        id: 'Income Category Data',
        data: incomePiedata,
        labelAccessorFn: (PieChartCategory row, _) => '${row.amount}',
      ),
    );


    _expenseSeriesData = List<charts.Series<PieChartCategory, String>>();
    
    var expensePiedata = [
      for (var i = 0; i < uniqueExpenseCategoryList.length; i++)
        PieChartCategory('${uniqueExpenseCategoryList[i]}', expenseAmounts[i],
            getRandomColor()),
    ];

    _expenseSeriesData.add(
      charts.Series(
        domainFn: (PieChartCategory pieChartCategory, _) =>
            pieChartCategory.categoryName,
        measureFn: (PieChartCategory pieChartCategory, _) =>
            pieChartCategory.amount,
        colorFn: (PieChartCategory pieChartCategory, _) =>
            charts.ColorUtil.fromDartColor(pieChartCategory.colorVal),
        id: 'Expense Category Data',
        data: expensePiedata,
        labelAccessorFn: (PieChartCategory row, _) => '${row.amount}',
      ),
    );

    setState(() {
      displayPieChart = true;
    });
  }
}

class PieChartCategory {
  String categoryName;
  double amount;
  Color colorVal;

  PieChartCategory(this.categoryName, this.amount, this.colorVal);
}
