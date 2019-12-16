import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddEnvelopePage extends StatefulWidget {
  @override
  AddEnvelopePageState createState() => AddEnvelopePageState();
}

class AddEnvelopePageState extends State<AddEnvelopePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.close),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: (){

            },
          )
        ],
        title: Text("New Envelope"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: envelopeForm(),
      ),
    );
  }

  Widget envelopeForm(){
    return Column(
      children: <Widget>[
        TextField(
          decoration: InputDecoration(
            hintText: "Envelope name"
          ),
        ),
        DropdownButton(
          onChanged:(String value){

          },
          items: itemsOfDropDown,
        ),
        TextField(
          decoration: InputDecoration(
            hintText: "Initial value"
          ),
        ),
      ],
    );
  }

  List<DropdownMenuItem<String>> itemsOfDropDown=[DropdownMenuItem(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Icon(Icons.ondemand_video),
        Text("Cash")
      ],
    ),
  )];
}