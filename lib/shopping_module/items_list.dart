import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker_app/decorations.dart';
import 'package:expense_tracker_app/shopping_module/shopping_list_model.dart';
import 'package:expense_tracker_app/shopping_module/shopping_list_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../login_registration_page.dart';

//Creating list of type ShoppingListModel
List<ShoppingListModel> shoppingList = [];
List<ShoppingListModel> selectedShoppingItems = [];
int count = 0;
int i;
int an;

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
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
  String shoppingListName;
  ItemsList(this.shoppingListName);
  @override
  ItemsListState createState() => ItemsListState(this.shoppingListName);
}

class ItemsListState extends State<ItemsList> {
  String shoppingListName;
  ItemsListState(this.shoppingListName);
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
        key: _scaffoldKey,
        appBar: AppBar(
            title: Text("$shoppingListName"),
            backgroundColor: setNaturalGreenColor(),
            actions: [
              IconButton(
                  icon: Icon(Icons.save),
                  onPressed: () {
                    addDataToFireBase();
                  }),
              popupMenuButton()
            ]),
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
                            if (value.isNotEmpty) {
                              if (double.tryParse(value) is! double) {
                                return 'Enter number not text';
                              }
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
                        //data cell for item name
                        DataCell(
                          TextFormField(
                            controller: setItemNameController(itmDetl.itemName),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (term) {
                              //checking if updated text is empty or not
                              if (term.isEmpty) {
                                final snackBar = SnackBar(
                                  content: Text('Item name cannot be empty'),
                                  duration: Duration(seconds: 3),
                                );

                                //setting previous value of textfeild
                                setState(() {
                                  setItemNameController(itmDetl.itemName);
                                });

                                // Find the Scaffold in the widget tree and use it to show a SnackBar.
                                _scaffoldKey.currentState
                                    .showSnackBar(snackBar);
                              }

                              //checking if updated text is string or not
                              else if (double.tryParse(term) is double) {
                                final snackBar = SnackBar(
                                  content: Text('Item name cannot be number'),
                                  duration: Duration(seconds: 3),
                                );

                                //setting previous value of textfeild
                                setState(() {
                                  setItemNameController(itmDetl.itemName);
                                });

                                // Find the Scaffold in the widget tree and use it to show a SnackBar.
                                _scaffoldKey.currentState
                                    .showSnackBar(snackBar);

                                //_scaffoldKey.currentState.removeCurrentSnackBar();
                              } else {
                                itmDetl.itemName = term;
                              }
                            },
                          ),
                          showEditIcon: true,
                          onTap: () {
                            print('Selected ${itmDetl.itemName}');

                            print("Display list ${shoppingList[2].itemName}");
                          },
                        ),

                        //data cell for price
                        DataCell(
                            TextFormField(
                              controller: setPriceController(itmDetl.price),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (term) {
                                //checking if updated price is empty or not
                                if (term.isNotEmpty) {
                                  //checking if updated price is number or not
                                  if (double.tryParse(term) is! double) {
                                    final snackBar = SnackBar(
                                      content: Text('Price cannot be text'),
                                      duration: Duration(seconds: 3),
                                    );

                                    //setting previous value of textfeild
                                    setState(() {
                                      setPriceController(itmDetl.price);
                                    });

                                    // Find the Scaffold in the widget tree and use it to show a SnackBar.
                                    _scaffoldKey.currentState
                                        .showSnackBar(snackBar);

                                    //_scaffoldKey.currentState.removeCurrentSnackBar();
                                  } else {
                                    itmDetl.price = term;
                                  }
                                } else {
                                  itmDetl.price = term;
                                }
                              },
                            ),
                            showEditIcon: true, onTap: () {
                          print('Selected ${itmDetl.price}');

                          print("Display list ${shoppingList[2].price}");
                        }),
                      ]),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  setItemNameController(String itemName) {
    var setItemNameController = TextEditingController(text: itemName);
    return setItemNameController;
  }

  setPriceController(String price) {
    var setPriceController = TextEditingController(text: price);
    return setPriceController;
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

  //adding data to firebase
  addDataToFireBase() async {
    List unSelectedItems = [];
    List selectedItems = [];

  for (var j = 0; j < selectedShoppingItems.length; j++) {

      selectedItems.add([
          selectedShoppingItems[j].itemName,
          selectedShoppingItems[j].price
        ]);
  }
   print(selectedItems);

    for (var i = 0; i < shoppingList.length; i++) {
        for (var j = 0; j < selectedShoppingItems.length; j++) {
        if (selectedShoppingItems[j].itemName== shoppingList[i].itemName &&
            selectedShoppingItems[j].price==shoppingList[i].price ) {
              shoppingList.removeAt(i);
              
              i=i-1;
              break;
        } 
      }
    }

    for (var i = 0; i < shoppingList.length; i++) {

      unSelectedItems.add([
          shoppingList[i].itemName,
          shoppingList[i].price
        ]);
  }
    
  // if(selectedShoppingItems.contains(shoppingList)){
  //   print(selectedShoppingItems);
  // }else{
  //   print(selectedShoppingItems);
  // }
    // else {
    //       unSelectedItems
    //           .add([shoppingList[i].itemName, shoppingList[i].price]);
    //           break;
    //     }
    print(unSelectedItems);
   

    // String uid;
    // LoginRegistrationPageState obj = new LoginRegistrationPageState();
    // uid = await obj.getCurrentUserId();

    // Firestore.instance
    //     .collection('ShoppingItems')
    //     .document(uid)
    //     .collection('shoppingItemsData')
    //     .document()
    //     .setData({
    //         'Shopping List Title':shoppingListName,
    //         for (var i = 0; i < count; i++)
    //           'Unselected Items': [['','']],
    //         for (var i = 0; i < count; i++)
    //           'Selected Items':[['','']]
    // });

    // print(shoppingList.length);
    // print(selectedShoppingItems.length);


    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ShoppingListPage(true
                      );
                    }));

  }
}
