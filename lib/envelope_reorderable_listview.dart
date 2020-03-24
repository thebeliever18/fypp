import 'package:expense_tracker_app/edit_envelope_page.dart';
import 'package:expense_tracker_app/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:expense_tracker_app/decorations.dart';

//Code for Envelope settings page 
class EnvelopeReorderableListView extends StatefulWidget {
  bool valueChooseMethod;
  EnvelopeReorderableListView(this.valueChooseMethod);
  @override
  EnvelopeReorderableListViewState createState() => EnvelopeReorderableListViewState(this.valueChooseMethod);
}

class EnvelopeReorderableListViewState extends State<EnvelopeReorderableListView> {
  bool valueChooseMethod;
  EnvelopeReorderableListViewState(this.valueChooseMethod);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: setNaturalGreenColor(),
        title: valueChooseMethod ? Text("Choose envelope"): Text("Envelope settings"),
      ),
      body: bodyMethod(),
    );
  }
  
  bodyMethod(){
    if(valueChooseMethod==true){
      //for transaction page
      return chooseEnvelope();
    }else{
      return reorderableListView();
    }
    
  }

  //widget for transaction page
  Widget chooseEnvelope(){
    return ListView(
      children: <Widget>[
        for (var item = 0; item < HomePageState.listEnvelopeFirestoreData.length; item++)
          ListTile(
            onTap: (){
              Navigator.of(context).pop([HomePageState.listEnvelopeFirestoreData[item].data['Envelope Name'],
              HomePageState.listEnvelopeFirestoreData[item].data['Initial Value']]);
            },
            leading:  Container(
                height: 40,
                width: 40,
                child:Center(child: choosingIcons(HomePageState.listEnvelopeFirestoreData[item].data['Envelope Type']),
                )
              ),
              //trailing: Text("${HomePageState.listEnvelopeFirestoreData[item].data['Initial Value']}"),
              title: Text("${HomePageState.listEnvelopeFirestoreData[item].data['Envelope Name']}",    
          )
          )],
    );
  }

  //Widget for reordering the order of items listed 
  Widget reorderableListView(){
    //ReorderableListView creates a reorderable list
    return ReorderableListView(
      //onReorder is called when a list child is dropped into a new position to shuffle the underlying list
      onReorder: (oldIndex,newIndex){
        updateItems(oldIndex,newIndex);
      },
      children: <Widget>[
        for (var item = 0; item < HomePageState.listEnvelopeFirestoreData.length; item++)
        
          Card(
            key:  ValueKey(HomePageState.listEnvelopeFirestoreData[item]),
            child: ListTile(
              onTap: (){
                
                //Pushing towards edit envelope page
                
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return EditEnvelopePage(HomePageState.listEnvelopeFirestoreData[item].data['Envelope Name'],
                    HomePageState.listEnvelopeFirestoreData[item].data['Initial Value'],
                    HomePageState.listEnvelopeFirestoreData[item].data['Additional notes'],
                    HomePageState.listEnvelopeFirestoreData[item].data['Envelope Type'],
                    HomePageState.listEnvelopeFirestoreData[item].documentID
                    );
                  }));
              },
              
              leading:  Container(
                height: 40,
                width: 40,
                child:Center(child: choosingIcons(HomePageState.listEnvelopeFirestoreData[item].data['Envelope Type']),
                )
              ),
              title: Text("${HomePageState.listEnvelopeFirestoreData[item].data['Envelope Name']}",
              style: TextStyle(fontWeight:FontWeight.bold),),
              subtitle: Text("${HomePageState.listEnvelopeFirestoreData[item].data['Envelope Type']}"),
              trailing: Icon(Icons.menu),
            ),
          ),
      ],
    );
  }
 
  //Method for displaying a specific icon for a specific Envelope type
  choosingIcons(envelopeType){
    if (envelopeType=="Cash") {
      return Icon(Icons.attach_money);
    } else if(envelopeType=="Bank"){
      return Icon(Icons.account_balance);
    } else if(envelopeType=="Credit Card"){
      return Icon(Icons.credit_card);
    }
  }

  //This method is called whenever the order of the items listed in the list is changed
  updateItems(oldIndex,newIndex){
    setState(() {
      if(newIndex > oldIndex){
        newIndex = newIndex-1;
      }
      var item=HomePageState.listEnvelopeFirestoreData.removeAt(oldIndex);
      HomePageState.listEnvelopeFirestoreData.insert(newIndex,item);
    });
  }
}