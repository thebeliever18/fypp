import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker_app/decorations.dart';
import 'package:expense_tracker_app/home_page.dart';
import 'package:expense_tracker_app/login_registration_page.dart';
import 'package:expense_tracker_app/shopping_module/create_new_shopping_list_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShoppingListPage extends StatefulWidget {
  @override
  ShoppingListPageState createState() => ShoppingListPageState();
}

class ShoppingListPageState extends State<ShoppingListPage> {
  //variable for storing user id
  String uid;

  //variable for storing data of Shopping list
  var listOfShoppingListData;

  bool showCard = true;

  String shoppingListDataDocumentID;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getShoppingListData();
  }

  //method for extracting shopping lists data from firebase
  getShoppingListData() async {
    LoginRegistrationPageState obj = new LoginRegistrationPageState();
    uid = await obj.getCurrentUserId();

    QuerySnapshot querySnapshot = await Firestore.instance
        .collection('ShoppingItems')
        .document(uid)
        .collection('shoppingItemsData')
        .getDocuments();

    //storing extracted list of documents in a variable
    listOfShoppingListData = querySnapshot.documents;

    if (listOfShoppingListData == null || listOfShoppingListData.isEmpty) {
      setState(() {
        showCard = false;
      });
    } else if (listOfShoppingListData != null) {
      shoppingListDataDocumentID = listOfShoppingListData[0].documentID;
      setState(() {
        showCard = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: setNaturalGreenColor(),
          leading: IconButton(icon: Icon(Icons.arrow_back), 
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) {
                return HomePage();
              }));
          }),
          title: Text(
            "Shopping lists",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: showCard
            ? shoppingListsCards(context)
            : shoppingListPageBody(context),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: setNaturalGreenColor(),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return CreateNewShoppingListPage();
              }));
            }));
  }

  shoppingListPageBody(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        //shoppingListsCards(),
        Center(
            child: CircleAvatar(
                backgroundColor: Colors.grey[300],
                radius: 50.0,
                child:
                    Icon(Icons.shopping_cart, size: 40.0, color: Colors.grey))),
        SizedBox(
          height: 10.0,
        ),
        Text(
          "Plan before you shop",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
        ),
        SizedBox(
          height: 5.0,
        ),
        Container(
            width: 300.0,
            child: Text(
              "Manage all your shopping lists here. Tap the plus button to add the first one.",
              style: TextStyle(fontSize: 17.0, color: Colors.grey[700]),
            ))
      ],
    );
  }

  shoppingListsCards(context) {
    if (listOfShoppingListData != null) {
      return SingleChildScrollView(
        child: Column(
          children: <Widget>[
            for (var i = 0; i < listOfShoppingListData.length; i++)
               Card(
                 key:ValueKey(listOfShoppingListData[i].documentID),
                  child: Padding(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                                "${listOfShoppingListData[i].data["Shopping List Title"]}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold)),
                            Text("Rs. dhumval",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(children: <Widget>[Text("0/1 items")]),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          thickness: 1.5,
                        ),
                        Row(
                          children: <Widget>[
                            InkWell(
                              onLongPress: () {},
                              child: Text("SHARE LIST",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        )
                      ],
                    )),
              )),
          ],
        ),
      );
    }
    return Center(child: CircularProgressIndicator());
  }
}
