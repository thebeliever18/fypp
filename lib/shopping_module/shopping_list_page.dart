import 'package:expense_tracker_app/decorations.dart';
import 'package:expense_tracker_app/shopping_module/create_new_shopping_list_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



//
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

  shoppingListPageBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Center(child: CircleAvatar(
          backgroundColor: Colors.grey[300],
          radius: 50.0,
          child: Icon(Icons.shopping_cart,
          size:40.0,
          color:Colors.grey))),
        SizedBox(height:10.0 ,),
        Text("Plan before you shop",style: TextStyle(
          fontWeight:FontWeight.bold,
          fontSize: 25.0
        ),),
        SizedBox(height:5.0 ,),
        Container(
          width: 300.0,
          child: Text("Manage all your shopping lists here. Tap the plus button to add the first one.",
          style: TextStyle(
            fontSize: 17.0,color: Colors.grey[700]
          ),))
      ],
    );
  }
}
