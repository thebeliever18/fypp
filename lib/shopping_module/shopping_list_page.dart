import 'package:expense_tracker_app/decorations.dart';
import 'package:expense_tracker_app/shopping_module/create_new_shopping_list_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShoppingListPage extends StatefulWidget {
  @override
  ShoppingListPageState createState() => ShoppingListPageState();
}

class ShoppingListPageState extends State<ShoppingListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: setNaturalGreenColor(),
          title: Text(
            "Shopping lists",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: shoppingListPageBody(),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: setNaturalGreenColor(),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CreateNewShoppingListPage();
          }));
          
        }
        )
        
        );
  }

  shoppingListPageBody() {}
}
