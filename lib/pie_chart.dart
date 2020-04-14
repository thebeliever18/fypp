import 'package:expense_tracker_app/decorations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class PieChart extends StatefulWidget {
  @override
  _PieChartState createState() => _PieChartState();
}

class _PieChartState extends State<PieChart> {
  List<charts.Series<PieChartCategory, String>> _seriesData;

  _generateData() {
    var piedata = [
      new PieChartCategory('Work', 35.8, Color(0xff3366cc)),
      new PieChartCategory('Eat', 8.3, Color(0xff990099)),
      new PieChartCategory('Commute', 10.8, Color(0xff109618)),
      new PieChartCategory('TV', 15.6, Color(0xfffdbe19)),
      new PieChartCategory('Sleep', 19.2, Color(0xffff9900)),
      new PieChartCategory('Other', 10.3, Color(0xffdc3912)),
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
                          entryTextStyle: charts.TextStyleSpec( 
                              fontSize: 11),
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
      Container(
        child:Text("hello")
      )
    ]);
  }
}

class PieChartCategory {
  String categoryName;
  double amount;
  Color colorVal;

  PieChartCategory(this.categoryName, this.amount, this.colorVal);
}
