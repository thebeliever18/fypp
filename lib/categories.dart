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
  String uid;

  var listOfCategory;

  var lengthOfCategory;

  String categoryDocumentId;
  //boolean value for displaying data in user interface
  bool showData = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
      getUserId();
    
  }

  getUserId() async {
    LoginRegistrationPageState obj = new LoginRegistrationPageState();
    uid = await obj.getCurrentUserId();

    
      QuerySnapshot querySnapshot = await Firestore.instance
        .collection('Categories')
        .document(uid)
        .collection('categoriesData')
        .getDocuments();

    //storing extracted list of documents in a variable
    listOfCategory = querySnapshot.documents;

    try{
      lengthOfCategory = listOfCategory[0].data["Category Name"].length;
    }catch(e){
       //if category list is empty then categories are added
       addCategoryDataToFireStore();
       getUserId();
    }
    
    
    categoryDocumentId=listOfCategory[0].documentID;

    print(categoryDocumentId);

    print(lengthOfCategory);

    if (lengthOfCategory != null) {
      setState(() {
        showData = true;
      });
    }
  }

  //if category list is empty then categories are added
  addCategoryDataToFireStore(){
    return Firestore.instance
                    .collection('Categories')
                    .document(uid)
                    .collection('categoriesData')
                    .document()
                    .setData({
                  'Category Name': ['Food','Clothing','Medicine','Work','Entertainment']
                });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Category list"),
          backgroundColor: setNaturalGreenColor(),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.add),
                color: Colors.white,
                onPressed: () {
                  print("plusadded");
                })
          ],
        ),
        body: titleOfCategory());
  }

  Widget titleOfCategory() {
    //showData is true then all the data are displayed in user interface
    if (showData == true) {
      return ListView(children: <Widget>[
        for (var i = 0; i < lengthOfCategory; i++)
          Dismissible(
            key: ValueKey(i),
            background: Container(
              color:Colors.green,
              child:Icon(Icons.edit)
            ),
            secondaryBackground: Container(
              color: Colors.red,
              child: Icon(Icons.delete),
            ),
            onDismissed: (direction) {
              if (direction == DismissDirection.endToStart) {
                setState(() {
                  //print("deleted");
                  deleteData(i);
                });
              } else if (direction == DismissDirection.startToEnd) {
                setState(() {
                  print("edited");
                  //editData();
                });
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
    return CircularProgressIndicator();
  }

  deleteData(index){
    try{
      var a= listOfCategory[0].data["Category Name"][index];
      print("a is"+a);
      var val=[];   //blank list for add elements which you want to delete
      val.add('$a');
      Firestore.instance.collection('Categories').document(uid).collection('categoriesData').document(categoryDocumentId).updateData({

                                        "Category Name":FieldValue.arrayRemove(val) });

    }catch(e){
      print(e);
    }
    
  }
}
