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
String uid;
GlobalKey<ScaffoldState> _scaffKey = new GlobalKey<ScaffoldState>();
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

  bool callMethodForExtractingFirebaseData;

  var listOfShoppingListDataSelectedItems;

  var listOfShoppingListDataUnselectedItems;

  bool updateToFirebase;

  var documentId;

  ItemsList(
      [this.shoppingListName,
      this.callMethodForExtractingFirebaseData,
      this.listOfShoppingListDataSelectedItems,
      this.listOfShoppingListDataUnselectedItems,
      this.updateToFirebase,
      this.documentId]);
  @override
  ItemsListState createState() => ItemsListState(
      this.shoppingListName,
      this.callMethodForExtractingFirebaseData,
      this.listOfShoppingListDataSelectedItems,
      this.listOfShoppingListDataUnselectedItems,
      this.updateToFirebase,
      this.documentId);
}

class ItemsListState extends State<ItemsList> {
  String shoppingListName;
  bool callMethodForExtractingFirebaseData;

  //variable for storing data of Shopping list
  var listOfShoppingListDataSelectedItems;

  var listOfShoppingListDataUnselectedItems;

  bool updateToFirebase;

  var documentId;

  ItemsListState(
      this.shoppingListName,
      this.callMethodForExtractingFirebaseData,
      this.listOfShoppingListDataSelectedItems,
      this.listOfShoppingListDataUnselectedItems,
      this.updateToFirebase,
      this.documentId);

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
          renameShoppingListName();
        } else if (returnValue == "Delete list") {
          print("Delete list");
          deleteShoppingListDataFromFirebase();
        }
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (callMethodForExtractingFirebaseData == true) {
      methodForExtractingFirebaseData();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return saveDialogBox(true);
      },
      child: Scaffold(
          key: _scaffKey,
          appBar: AppBar(
              title: Text("$shoppingListName"),
              backgroundColor: setNaturalGreenColor(),
              leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    saveDialogBox(true);
                  }),
              actions: [
                IconButton(
                    icon: Icon(Icons.save),
                    onPressed: () {
                      saveDialogBox(false);
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
              : null),
    );
  }

  deleteShoppingListDataFromFirebase() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content:
                Text("Are you sure you want to delete $shoppingListName ?"),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(
                  "Delete",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () async {
                  // TODO: Delete the item from DB etc..

                  LoginRegistrationPageState obj =
                      new LoginRegistrationPageState();
                  uid = await obj.getCurrentUserId();
                  Firestore.instance
                      .collection('ShoppingItems')
                      .document(uid)
                      .collection('shoppingItemsData')
                      .document(documentId)
                      .delete();

                  final snackBar = SnackBar(
                    content: Text('This shopping list is deleted'),
                    duration: Duration(seconds: 1),
                  );

                  _scaffKey.currentState.showSnackBar(snackBar);

                  //after deleting navigating to home page
                  Future.delayed(const Duration(seconds: 2), () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ShoppingListPage();
                    }));
                    _scaffKey.currentState.removeCurrentSnackBar();
                  });
                },
              ),
            ],
          );
        });
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
                                _scaffKey.currentState.showSnackBar(snackBar);
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
                                _scaffKey.currentState.showSnackBar(snackBar);

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
                                    _scaffKey.currentState
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

  renameShoppingListName() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Rename $shoppingListName"),
            content: TextField(
              //controller: itemToBeEdited,
              decoration: InputDecoration(
                //Underline color of text field
                focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromRGBO(80, 213, 162, 1.0))),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    print("pressed ittt");
                  },
                  child: Text("Rename", style: TextStyle(color: Colors.green))),
            ],
          );
        });
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

  //dialog box called after pressing back arrow button and save button in the app bar
  saveDialogBox(bool boolVal) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(boolVal
                ? "Please save all the data of $shoppingListName else all data might get lost"
                : "Are you sure you want to save the data of $shoppingListName ?"),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(
                  "Save",
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: () async {
                  addDataToFireBase();
                },
              ),
            ],
          );
        });
  }

  //adding data to firebase
  addDataToFireBase() async {
    List unSelectedItems = [];
    List selectedItems = [];
    List<ShoppingListModel> shoppingListSecondList = [];

    //adding all the elements of shoppingList in new list i.e. shoppingListSecondList

    for (var i = 0; i < shoppingList.length; i++) {
      shoppingListSecondList.add(shoppingList[i]);
    }

    print("shoopinglists second  $shoppingListSecondList");
    //if none of the items are selected then selectedShoppingItems will be null

    for (var j = 0; j < selectedShoppingItems.length; j++) {
      selectedItems.add(
        selectedShoppingItems[j].itemName,
      );

      selectedItems.add(selectedShoppingItems[j].price);
    }
    print("selected items $selectedItems");

    for (var i = 0; i < shoppingListSecondList.length; i++) {
      for (var j = 0; j < selectedShoppingItems.length; j++) {
        if (selectedShoppingItems[j].itemName ==
                shoppingListSecondList[i].itemName &&
            selectedShoppingItems[j].price == shoppingListSecondList[i].price) {
          shoppingListSecondList.removeAt(i);
          i = i - 1;
          break;
        }
      }
    }

    //checking if all items are selected or not. If all items are selected shoppingList will be null
    if (shoppingList != null) {
      for (var i = 0; i < shoppingListSecondList.length; i++) {
        unSelectedItems.add(
          shoppingListSecondList[i].itemName,
        );

        unSelectedItems.add(shoppingListSecondList[i].price);
      }
    }

    print("unselected items $unSelectedItems");

    LoginRegistrationPageState obj = new LoginRegistrationPageState();
    uid = await obj.getCurrentUserId();

    //for updating the previous firebase data
    if (updateToFirebase == true) {
      Firestore.instance
          .collection('ShoppingItems')
          .document(uid)
          .collection('shoppingItemsData')
          .document(documentId)
          .updateData({
        'Shopping List Title': shoppingListName,
        'Unselected Items': unSelectedItems,
        'Selected Items': selectedItems
      });
    }
    //for saving the data
    else {
      Firestore.instance
          .collection('ShoppingItems')
          .document(uid)
          .collection('shoppingItemsData')
          .document()
          .setData({
        'Shopping List Title': shoppingListName,
        'Unselected Items': unSelectedItems,
        'Selected Items': selectedItems
      });
    }

    // print(shoppingList.length);
    // print(selectedShoppingItems.length);

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ShoppingListPage();
    }));

    shoppingList.clear();
    selectedShoppingItems.clear();
  }

  //
  methodForExtractingFirebaseData() {
    print("shopping list selcted $listOfShoppingListDataSelectedItems");
    print("shopping list unselcted is $listOfShoppingListDataUnselectedItems");

    for (var i = 0; i < listOfShoppingListDataUnselectedItems.length; i++) {
      ShoppingListModel itemsDetail = new ShoppingListModel(
          listOfShoppingListDataUnselectedItems[i],
          listOfShoppingListDataUnselectedItems[i + 1]);

      //appending item details to shoppingList
      addToShoppingList(itemsDetail);
      i = i + 1;
    }

    for (var i = 0; i < listOfShoppingListDataSelectedItems.length; i++) {
      ShoppingListModel itemsDetail = new ShoppingListModel(
          listOfShoppingListDataSelectedItems[i],
          listOfShoppingListDataSelectedItems[i + 1]);

      //appending item details to shoppingList
      addToShoppingList(itemsDetail);

      selectedShoppingItems.add(itemsDetail);
      i = i + 1;
    }

    setState(() {
      showFloatingActionButton = true;
    });
  }
}
