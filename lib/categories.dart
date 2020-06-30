import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:expense_tracker_app/login_registration_page.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:random_color/random_color.dart';

import 'package:expense_tracker_app/decorations.dart';

//Method for generating random color
getRandomColor() {
  RandomColor randomColor = RandomColor();
  Color color = randomColor.randomColor();
  return color;
}

class Catagories extends StatefulWidget {
  @override
  CatagoriesState createState() => CatagoriesState();
}

class CatagoriesState extends State<Catagories> {
  //variable for storing user id
  String uid;

  //variable for storing data of category
  List listOfCategory;

  //variable for storing length of the array of a category
  var lengthOfCategory;

  //
  String categoryDocumentId;

  //boolean value for displaying data in user interface
  bool showData = false;

  bool callAgain = false;

  TextEditingController itemToBeEditedController;
  TextEditingController itemToBeDeletedController;

  final itemToBeAddedController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //
    getUserIdForCategory();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //
  getUserIdForCategory() async {
    LoginRegistrationPageState obj = new LoginRegistrationPageState();
    uid = await obj.getCurrentUserId();

    QuerySnapshot querySnapshot = await Firestore.instance
        .collection('Categories')
        .document(uid)
        .collection('categoriesData')
        .getDocuments();

    //storing extracted list of documents in a variable
    listOfCategory = querySnapshot.documents;

    try {
      lengthOfCategory = listOfCategory[0].data["Category Name"].length;
    } catch (e) {
      //if category list is empty then categories are added
      addCategoryDataToFireStore(uid);
      getUserIdForCategory();
    }

    categoryDocumentId = listOfCategory[0].documentID;

    print(categoryDocumentId);

    print(lengthOfCategory);

    if (lengthOfCategory != null) {
      setState(() {
        showData = true;
      });
    }
  }

  //if category list is empty then categories are added
  addCategoryDataToFireStore(uid) {
    return Firestore.instance
        .collection('Categories')
        .document(uid)
        .collection('categoriesData')
        .document()
        .setData({
      'Category Name': ['Food', 'Clothing', 'Medicine', 'Work', 'Entertainment']
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Category list"),
          backgroundColor: setNaturalGreenColor(),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.add),
                color: Colors.white,
                onPressed: () {
                  itemToBeAddedController.clear();
                  addCategory("Add", itemToBeAddedController);
                })
          ],
        ),
        body: Builder(builder: (BuildContext context) {
          return titleOfCategory(context);
        }));
  }

  Widget titleOfCategory(context) {
    //showData is true then all the data are displayed in user interface
    if (showData == true) {
      return ListView(children: <Widget>[
        for (var i = 0; i < lengthOfCategory; i++)
          Dismissible(
            key: ValueKey(i),
            background: Container(color: Colors.green, child: Icon(Icons.edit)),
            secondaryBackground: Container(
              color: Colors.red,
              child: Icon(Icons.delete),
            ),
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.endToStart) {
                final bool res = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text(
                            "Are you sure you want to delete ${listOfCategory[0].data["Category Name"][i]}?"),
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
                            onPressed: () {
                              // TODO: Delete the item from DB etc..
                              setState(() {
                                var itemToBeDeleted =
                                    listOfCategory[0].data["Category Name"][i];
                                print("itemToBeDeleted is" + itemToBeDeleted);
                                var val =
                                    []; //blank list for add elements which you want to delete
                                val.add('$itemToBeDeleted');

                                Firestore.instance
                                    .collection('Categories')
                                    .document(uid)
                                    .collection('categoriesData')
                                    .document(categoryDocumentId)
                                    .updateData({
                                  "Category Name": FieldValue.arrayRemove(val)
                                });
                                getUserIdForCategory();
                              });
                              Navigator.of(context).pop();

                              final snackBar = SnackBar(
                                content: Text('The category is deleted'),
                                duration: Duration(seconds: 1),
                              );

                              _scaffoldKey.currentState.showSnackBar(snackBar);
                            },
                          ),
                        ],
                      );
                    });
                return res;
              } else if (direction == DismissDirection.startToEnd) {
                final bool res = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text(
                            "Are you sure you want to edit ${listOfCategory[0].data["Category Name"][i]}?"),
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
                              "Edit",
                              style: TextStyle(color: Colors.green),
                            ),
                            onPressed: () {
                              var itemToBeEdited =
                                  listOfCategory[0].data["Category Name"][i];

                              //Controller for editing
                              itemToBeEditedController =
                                  TextEditingController(text: itemToBeEdited);

                              //Controller for deleting
                              itemToBeDeletedController =
                                  TextEditingController(text: itemToBeEdited);

                              Navigator.of(context).pop();
                              addCategory("Edit", itemToBeEditedController, i,
                                  itemToBeDeletedController);
                              //Navigator.of(context).pop();

                              
                            },
                          ),
                        ],
                      );
                    });
                return res;
              }
            },
            child: ListTile(
              leading: CircleAvatar(
                  backgroundColor: getRandomColor(),
                  child: Text(
                      listOfCategory[0]
                          .data["Category Name"][i][0]
                          .toUpperCase(),
                      style: TextStyle(
                        fontSize: 23.0,
                      ))),
              title: Text(listOfCategory[0].data["Category Name"][i]),
            ),
          ),
      ]);
    }
    return Center(child: CircularProgressIndicator());
  }

  Future addCategory([
    String title,
    TextEditingController itemToBeEdited,
    var index,
    TextEditingController itemToBeDeleted,
  ]) async {
    bool res = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("$title category"),
            content: TextField(
              controller: itemToBeEdited,
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
                    if (title == "Edit") {
                      
                      if (itemToBeEdited.text.isEmpty) {
                        final snackBar = SnackBar(
                          content: Text('Please enter the value to be edited.'),
                          duration: Duration(seconds: 3),
                        );

                        // Find the Scaffold in the widget tree and use it to show a SnackBar.
                        _scaffoldKey.currentState.showSnackBar(snackBar);
                      } else {
                        var delVal =
                            []; //blank list for adding elements which you want to delete
                        delVal.add('${itemToBeDeleted.text}');

                        //First deleting editing value
                        Firestore.instance
                            .collection('Categories')
                            .document(uid)
                            .collection('categoriesData')
                            .document(categoryDocumentId)
                            .updateData({
                          "Category Name": FieldValue.arrayRemove(delVal)
                        });

                        var editVal =
                            []; //blank list for adding elements which you want to edit
                        editVal.add('${itemToBeEdited.text}');
                        //editing the value
                        Firestore.instance
                            .collection('Categories')
                            .document(uid)
                            .collection('categoriesData')
                            .document(categoryDocumentId)
                            .updateData(
                          {
                            "Category Name": FieldValue.arrayUnion(editVal),
                          },
                        );
                        _scaffoldKey.currentState.removeCurrentSnackBar();
                        Navigator.of(context).pop();
                        getUserIdForCategory();

                        final snackBar = SnackBar(
                                content: Text('The category is edited'),
                                duration: Duration(seconds: 1),
                              );

                              _scaffoldKey.currentState.showSnackBar(snackBar);
                      }
                    } else if (title == "Add") {
                      if (itemToBeAddedController.text.isEmpty) {
                        //  BuildContext newcontext=context;
                        // Scaffold.of(newcontext).showSnackBar(displaySnackBar("Please enter value to be added"));
                        final snackBar = SnackBar(
                            content:
                                Text('Please enter the value to be added.'),
                            duration: Duration(seconds: 3));

                        // Find the Scaffold in the widget tree and use it to show a SnackBar.
                        _scaffoldKey.currentState.showSnackBar(snackBar);
                      } else {
                        var val =
                            []; //blank list for add elements which you want to delete
                        val.add('${itemToBeAddedController.text}');

                        print(itemToBeAddedController.text);

                        //editing the value
                        Firestore.instance
                            .collection('Categories')
                            .document(uid)
                            .collection('categoriesData')
                            .document(categoryDocumentId)
                            .updateData(
                          {
                            "Category Name": FieldValue.arrayUnion(val),
                          },
                        );
                        _scaffoldKey.currentState.removeCurrentSnackBar();
                        Navigator.of(context).pop();
                        getUserIdForCategory();

                        final snackBar = SnackBar(
                            content:
                                Text('New Category is added'),
                            duration: Duration(seconds: 1));

                        
                        _scaffoldKey.currentState.showSnackBar(snackBar);
                      }
                    }
                  },
                  child: Text("$title", style: TextStyle(color: Colors.green))),
            ],
          );
        });
    return res;
  }
}
