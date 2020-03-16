import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker_app/categories.dart';


import 'package:expense_tracker_app/decorations.dart';
import 'package:expense_tracker_app/login_registration_page.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DisplayCategoryPage extends StatefulWidget {
  @override
  DisplayCategoryPageState createState() => DisplayCategoryPageState();
}

class DisplayCategoryPageState extends State<DisplayCategoryPage> {

   //variable for storing user id
  String uid;

  //variable for storing data of category
   List listOfCategory;

  //variable for storing length of the array of a category
   var lengthOfCategory;
   
  String categoryDocumentId;

  //boolean value for displaying data in user interface
  bool showData = false;

  CatagoriesState catagoriesStateObj  =new CatagoriesState(); 

  var sendBackValue;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserIdForCategory();
  }

    
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
      catagoriesStateObj.addCategoryDataToFireStore(uid);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Choose category"),
        backgroundColor: setNaturalGreenColor(),
      ),
      body: Container(
        child:categoryList()
      )
    );
  }

  categoryList(){
    if (showData == true) {
      return ListView(
        children: <Widget>[
          for (var i = 0; i < lengthOfCategory; i++)
             ListTile(
               onTap: (){
                      sendBackValue=listOfCategory[0].data["Category Name"][i];
                      Navigator.of(context).pop(sendBackValue); 
               },
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
        ],
      );
    }
    return Center(child: CircularProgressIndicator());
  }
}