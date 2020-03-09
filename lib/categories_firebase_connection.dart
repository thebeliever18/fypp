// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:expense_tracker_app/categories.dart';
// import 'package:expense_tracker_app/login_registration_page.dart';
// import 'package:flutter/material.dart';

//  //variable for storing user id
// String uid;

//   //variable for storing data of category
//    List listOfCategory;

//   //variable for storing length of the array of a category
//    var lengthOfCategory;
   
//   String categoryDocumentId;

//   //boolean value for displaying data in user interface
//   bool showData = false;

//   CatagoriesState catagoriesStateObj  =new CatagoriesState(); 



// // class CategoriesFirebaseConnection extends StatefulWidget {
// //   @override
// //   _CategoriesFirebaseConnectionState createState() => _CategoriesFirebaseConnectionState();
// // }

// // class _CategoriesFirebaseConnectionState extends State<CategoriesFirebaseConnection> {

// //   @override
// //   void initState() {
// //     // TODO: implement initState
// //     super.initState();
// //     getUserIdForCategory(context);
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       child: CircularProgressIndicator(),
// //     );
// //   }
// // }




// getUserIdForCategory(BuildContext context) async {
//     LoginRegistrationPageState obj = new LoginRegistrationPageState();
//     uid = await obj.getCurrentUserId();

//     QuerySnapshot querySnapshot = await Firestore.instance
//         .collection('Categories')
//         .document(uid)
//         .collection('categoriesData')
//         .getDocuments();

//     //storing extracted list of documents in a variable
//     listOfCategory = querySnapshot.documents;

//     try {
//       lengthOfCategory = listOfCategory[0].data["Category Name"].length;
//     } catch (e) {
//       //if category list is empty then categories are added
//       catagoriesStateObj.addCategoryDataToFireStore(uid);
//       getUserIdForCategory(context);
//     }

//     categoryDocumentId = listOfCategory[0].documentID;

//     print(categoryDocumentId);

//     print(lengthOfCategory);

    
//     if (lengthOfCategory != null) {
      
//         Navigator.push(context, MaterialPageRoute(builder: (context) {
//                   return Catagories();
//                 }));
                     
//     }
   
// }