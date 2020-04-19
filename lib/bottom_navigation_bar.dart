import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:expense_tracker_app/categories.dart';
import 'package:expense_tracker_app/decorations.dart';
import 'package:expense_tracker_app/home_page.dart';
import 'package:expense_tracker_app/login_registration_page.dart';
import 'package:expense_tracker_app/pie_chart.dart';
import 'package:expense_tracker_app/profile_page.dart';
import 'package:expense_tracker_app/shopping_module/shopping_list_page.dart';
import 'package:expense_tracker_app/transaction_module/transaction_list_page.dart';
import 'package:expense_tracker_app/transaction_module/transaction_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClassBottomNavigationBar extends StatefulWidget {
  @override
  ClassBottomNavigationBarState createState() => ClassBottomNavigationBarState();
}

class ClassBottomNavigationBarState extends State<ClassBottomNavigationBar> {
  //_scaffoldKey is a global key that is unique across the entire app.
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int pageIndex = 0;

  final HomePage _homePage = HomePage();
  final TransactionListPage _transactionListPage = TransactionListPage();
  final PieChart _pieChart = PieChart();
  final ProfilePage _profilePage = ProfilePage();

  Widget showPage = HomePage();
  String appBarTitle="Home";
  bool displayAppBar=true;
  Widget pageChooser(int page) {
    switch (page) {
      case 0:
        setState(() {
          appBarTitle="Home";
          displayAppBar=true;
        });
        return _homePage;
        break;
      case 1:
        setState(() {
          appBarTitle="Transactions List";
          displayAppBar=true;
        });
        return _transactionListPage;
        break;
      case 3:
        setState(() {
          displayAppBar=false;
        });
        return _pieChart;
        break;
      case 4:
        setState(() {
          displayAppBar=false;
        });
        return _profilePage;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: displayAppBar ? AppBar(
          backgroundColor: setNaturalGreenColor(),
          title: Text(
            "$appBarTitle",
            style: TextStyle(color: Colors.white),
          ),
          //elevation: 0,
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

                      _scaffoldKey.currentState.openDrawer();
                    },
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(200),
                ),
              )
            ],
          )):null,
      drawer: Drawer(
        elevation: 1.0,
        child: drawerItems(context),
      ),

      //A bottom navigation bar to display at the bottom of the scaffold.

      bottomNavigationBar: CurvedNavigationBar(
        color: setNaturalGreenColor(),
        backgroundColor: Colors.white,
        // buttonBackgroundColor: setNaturalGreenColor(),
        height: 50,
        items: <Widget>[
          // IconButton(
          //   icon:
          Icon(
            Icons.home,
            size: 30,
            color: Colors.white,
          ),
          //onPressed: () {},
          //),
          // IconButton(
          //     onPressed: () {
          //       // Navigator.push(context, MaterialPageRoute(builder: (context) {
          //       //   return TransactionListPage();
          //       // }));
          //     },
          Icon(
            Icons.calendar_today,
            size: 25,
            color: Colors.white,
          ),
          IconButton(
              icon: Icon(
                Icons.add,
                size: 30,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return TransactionPage(false);
                }));
              }),
          // IconButton(
               Icon(
                Icons.pie_chart,
                size: 30,
                color: Colors.white,
              ),
              // onPressed: () {
              //   Navigator.push(context, MaterialPageRoute(builder: (context) {
              //     return PieChart();
              //   }));
              // }),
          //IconButton(
              Icon(
                Icons.person,
                size: 30,
                color: Colors.white,
              ),
              // onPressed: () {
              //   Navigator.push(context, MaterialPageRoute(builder: (context) {
              //     return ProfilePage();
              //   }));
              // }),
        ],

        //animationDuration for increasing the duration of the animation

        animationDuration: Duration(milliseconds: 200),

        //index 0 will be selected by default in bottom navigation bar

        index: pageIndex,
        onTap: (int tappedIndex) {
          print("tapped");
          //Handle button tap
          setState(() {
            showPage = pageChooser(tappedIndex);
          });
        },
      ),
      body: showPage,
    );
  }
}

//Decoration of Drawer
drawerItems(context) {
  return ListView(
    children: <Widget>[
      DrawerHeader(
        child: Column(
          children: <Widget>[
            CircleAvatar(radius: 55, child: displayFirstLetterofEmail(),backgroundColor: Colors.white,foregroundColor: setNaturalGreenColor(),),
            SizedBox(
              height: 10,
            ),
            Text(LoginRegistrationPageState.emailController.text)
          ],
        ),
        decoration: BoxDecoration(color: setNaturalGreenColor()),
      ),
      ListTile(
        leading: Icon(Icons.home,color: Colors.black,),
        title: Text("Home",style: TextStyle(color:Colors.black),),
        onTap: () {
          //Navigating to home page
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ClassBottomNavigationBar();
          }));
        },
      ),
      ListTile(
        leading: Icon(Icons.category,color: Colors.black),
        title: Text("Categories",style: TextStyle(color:Colors.black)),
        onTap: () {
          //Navigating to category list page
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Catagories();
          }));
        },
      ),
      ListTile(
        leading: Icon(Icons.shopping_basket,color: Colors.black),
        title: Text("Shopping lists",style: TextStyle(color:Colors.black)),
        onTap: () {
          //Navigating to shopping list page
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ShoppingListPage();
          }));
        },
      ),
    ],
  );
}

//Selects first letter from email
displayFirstLetterofEmail() {
  String firstLetterofEmail =
      LoginRegistrationPageState.emailController.text[0];
  //Returning first letter of email address by making it capital
  return Text("${firstLetterofEmail.toUpperCase()}");
}
