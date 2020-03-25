import 'package:expense_tracker_app/decorations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Page for different shopping items
class ItemsList extends StatefulWidget {
  @override
  ItemsListState createState() => ItemsListState();
}

class ItemsListState extends State<ItemsList> {
  popupMenuButton() {
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) =>

          //PopupMenuEntry is a base class for entries in a material design popup menu.
          <PopupMenuEntry<String>>[
        PopupMenuItem(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(
                Icons.edit,
                color: Colors.grey,
              ),
              Text("Rename shopping list"),
            ],
          ),
          value: "Rename shopping list",
        ),
        PopupMenuItem(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(
                Icons.delete,
                color: Colors.grey,
              ),
              Text("Delete list"),
            ],
          ),
          value: "Delete list",
        ),
      ],
      onSelected: (returnValue) {
        if (returnValue == "Rename shopping list") {
          print("Rename shopping list");
        } else if (returnValue == "Delete list") {
          print("Delete list");
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      appBar: AppBar(
          title: Text("title"),
          backgroundColor: setNaturalGreenColor(),
          actions: [popupMenuButton()]),
    );
  }
}
