import 'package:expense_tracker_app/decorations.dart';
import 'package:expense_tracker_app/shopping_module/shopping_list_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Creating list of type ShoppingListModel
List<ShoppingListModel> shoppingList = [];
List<ShoppingListModel> selectedShoppingItems = [];
int count = 0;
int i;
int an;

//Method for appending data to the ShoppingListModel
void addToShoppingList(ShoppingListModel data) {
  shoppingList.add(data);
  print(shoppingList);
  print(shoppingList[0].itemName);
  print("hh");
  print(shoppingList[0].price);
}

//Page for different shopping items
class ItemsList extends StatefulWidget {
  @override
  ItemsListState createState() => ItemsListState();
}

class ItemsListState extends State<ItemsList> {
  final _formKeyOne = GlobalKey<FormState>();
  final _formKeyTwo = GlobalKey<FormState>();
  bool autovalidate = false;
  bool showFloatingActionButton = false;
  bool selected = false;

  final itemNameController = TextEditingController();
  final priceController = TextEditingController();

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
  void initState() {
    // TODO: implement initState
    super.initState();

    //shoppingList = ShoppingListModel.getShoppingItemData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("title"),
            backgroundColor: setNaturalGreenColor(),
            actions: [popupMenuButton()]),
        body: itemsListBody(),
        floatingActionButton: showFloatingActionButton
            ? FloatingActionButton(
                child: Icon(Icons.add),
                backgroundColor: setNaturalGreenColor(),
                onPressed: () {
                  print("pressedssed");
                  setState(() {
                    //after pressing floating action button textfeild for inputting item name and price appears
                    showFloatingActionButton = false;
                    autovalidate = false;
                  });
                })
            : null);
  }

  itemsListBody() {
    return Column(
        mainAxisAlignment: showFloatingActionButton
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        crossAxisAlignment: showFloatingActionButton
            ? CrossAxisAlignment.stretch
            : CrossAxisAlignment.end,
        children: <Widget>[
          //if floating action button appears then textfeild for inputting item name and price disappears
          showFloatingActionButton
              ? Expanded(child: dataTable())
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 150,
                      child: Form(
                        key: _formKeyOne,
                        child: TextFormField(
                          controller: itemNameController,
                          autovalidate: autovalidate,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter item name';
                            } else if (double.tryParse(value) is double) {
                              return 'Enter text not number';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (term) {
                            validateTextFeilds();
                          },
                          autofocus: true,
                          decoration: InputDecoration(
                            focusedBorder: setFocusedBorder(),
                            //Underline color of text field
                            filled: true,
                            fillColor: Colors.grey[300],
                            hintText: "Item name",
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 150,
                      child: Form(
                        key: _formKeyTwo,
                        child: TextFormField(
                          controller: priceController,
                          autovalidate: autovalidate,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter price';
                            } else if (double.tryParse(value) is! double) {
                              return 'Enter number not text';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (term) {
                            validateTextFeilds();
                          },
                          autofocus: true,
                          decoration: InputDecoration(
                            focusedBorder: setFocusedBorder(),
                            //Underline color of text field
                            filled: true,
                            fillColor: Colors.grey[300],
                            hintText: "Price",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

          //if floating action button disappears then the row implemented below also disappears
          showFloatingActionButton
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  //mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 15.0, left: 13),
                      child: OutlineButton(
                        child: Text('BOUGHT ${selectedShoppingItems.length}'),
                        onPressed: () {},
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 15.0, left: 13),
                      child: OutlineButton(
                        child: Text('DELETE ITEMS BOUGHT'),
                        onPressed: selectedShoppingItems.isEmpty
                            ? null
                            : () {
                                deleteBoughtItems();
                              },
                      ),
                    ),
                  ],
                )
              : Container()
        ]);
  }

  deleteBoughtItems() async {
    setState(() {
      if (selectedShoppingItems.isNotEmpty) {
        List<ShoppingListModel> temp = [];
        temp.addAll(selectedShoppingItems);
        for (ShoppingListModel item in temp) {
          shoppingList.remove(item);
          selectedShoppingItems.remove(item);
        }
      }
    });
  }

  validateTextFeilds() {
    if (_formKeyOne.currentState.validate() &&
        _formKeyTwo.currentState.validate()) {
      //Creating object of ShoppingListModel class and passing itemName and price of item in ShoppingListModel constructor.
      ShoppingListModel itemsDetail =
          new ShoppingListModel(itemNameController.text, priceController.text);
      print("hello");

      //appending item details to shoppingList
      addToShoppingList(itemsDetail);

      setState(() {
        showFloatingActionButton = true;
      });
      itemNameController.clear();
      priceController.clear();
    } else {
      setState(() {
        autovalidate = true;
      });
    }
  }

  dataTable() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          DataTable(
            columns: [
              DataColumn(
                  label: Text(
                "Item Name",
                style: TextStyle(fontSize: 17.0, color: Colors.grey[700]),
              )),
              DataColumn(
                  label: Text("Price",
                      style:
                          TextStyle(fontSize: 17.0, color: Colors.grey[700])))
            ],
            rows: shoppingList
                .map(
                  (itmDetl) => DataRow(
                    
                      selected: selectedShoppingItems.contains(itmDetl),
                      
                      onSelectChanged: (b) {
                        print("Onselect");
                        onSelectedRow(b, itmDetl);
                      },
                      cells: [
                        DataCell( 
                          Text(itmDetl.itemName,
                              style: TextStyle(
                                  fontSize: 15.0, color: Colors.grey[700])),
                          showEditIcon: true,
                          onTap: () {
                            print('Selected ${itmDetl.itemName}');
                          },
                        ),
                        DataCell(
                          Text(itmDetl.price,
                              style: TextStyle(
                                  fontSize: 15.0, color: Colors.grey[700])),
                                  showEditIcon: true,
                                  onTap: (){

                                  }
                        ),
                      ]),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  onSelectedRow(bool select, ShoppingListModel shoppingListModel) {
    setState(() {
      if (select) {
        selectedShoppingItems.add(shoppingListModel);
      } else {
        selectedShoppingItems.remove(shoppingListModel);
      }
    });
  }
}
