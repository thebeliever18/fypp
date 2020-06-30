import 'package:expense_tracker_app/decorations.dart';
import 'package:expense_tracker_app/shopping_module/items_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Page for writing and creating name of your shopping list
class CreateNewShoppingListPage extends StatefulWidget {
  @override
  CreateNewShoppingListPageState createState() =>
      CreateNewShoppingListPageState();
}

class CreateNewShoppingListPageState extends State<CreateNewShoppingListPage> {

  FocusNode focusNodeNameOfShoppingList = new FocusNode();
  bool autoValidate = false;
  final _formKey = GlobalKey<FormState>();
  var shoppingListName = TextEditingController();

  //initState method is executed first
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    focusNodeNameOfShoppingList.addListener(() {
      setState(() {});
    });
  }

  //method for disposing focus node
  @override
  void dispose() {
    
    super.dispose();
    focusNodeNameOfShoppingList.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: setNaturalGreenColor(),
        title: Text("New shopping list"),
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: createNewShoppingListPageBody(),
    );
  }

  createNewShoppingListPageBody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 25.0,
          ),
          Text(
            "Name your list",
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Text(
            "Weekend shopping? Gifts for your family? :-)",
            style: TextStyle(color: Colors.grey[600]),
          ),
          SizedBox(
            height: 20.0,
          ),
          Form(
            key: _formKey,
            child: Container(
              width: 290,
              child: TextFormField(
                controller: shoppingListName,
                autovalidate: autoValidate,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter name of your list';
                  }
                  return null;
                },
                focusNode: focusNodeNameOfShoppingList,
                keyboardType: TextInputType.text,
                autofocus: true,
                decoration: InputDecoration(
                  focusedBorder: setFocusedBorder(),
                  //Underline color of text field
                  filled: true,
                  fillColor: Colors.grey[300],
                  labelText: "Name",
                  hintText: "Name your list",
                  labelStyle: changingFocus(focusNodeNameOfShoppingList),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          ButtonTheme(
            minWidth: 290,
            height: 37,
            child: RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {

                  //navigating to the page which contains different item to be purchased
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ItemsList(shoppingListName.text,false);
                  }));
                } else {
                  setState(() {
                    autoValidate = true;
                  });
                }
              },
              child: Text(
                "CREATE LIST",
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
              color: setNaturalGreenColor(),
            ),
          )
        ],
      ),
    );
  }

  //method for changing focus colour in textformfield
  changingFocus(focusType) {
    return TextStyle(
        color: focusType.hasFocus ? setNaturalGreenColor() : Colors.grey);
  }
}
