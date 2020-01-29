import 'package:expense_tracker_app/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:expense_tracker_app/decorations.dart';

class EnvelopeReorderableListView extends StatefulWidget {
  @override
  EnvelopeReorderableListViewState createState() => EnvelopeReorderableListViewState();
}

class EnvelopeReorderableListViewState extends State<EnvelopeReorderableListView> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: setNaturalGreenColor(),
        title: Text("Envelope settings"),
      ),
      body: reorderableListView(),
    );
  }

  Widget reorderableListView(){
    return ReorderableListView(
      onReorder: (oldIndex,newIndex){
        updateItems(oldIndex,newIndex);
      },
      children: <Widget>[
        for (var item = 0; item < HomePageState.listEnvelopeFirestoreData.length; item++)
          ListTile(
            leading: Icon(Icons.group),
            title: Text("${HomePageState.listEnvelopeFirestoreData[item].data['Envelope Name']}"),
            subtitle: Text("${HomePageState.listEnvelopeFirestoreData[item].data['Envelope Type']}"),
            trailing: Icon(Icons.menu),
          )
      ],
    );
    
  }
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