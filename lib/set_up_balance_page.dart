import 'package:expense_tracker_app/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SetUpBalancePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SetUpBalancePageState();
  }
}

var deletedOutput;
var output = "0 NPR";
var _output = "";

textStyle() {
  return TextStyle(color: Colors.grey[600], fontSize: 40.0);
}

class SetUpBalancePageState extends State<SetUpBalancePage> {

  void buttonPressed(var buttonText) {

    if(buttonText=="."){
      if(_output.contains(".")){
        return;
      }
    }

    if(_output.length<10){
      _output = _output + buttonText;
    }
    
    setState(() {
      output = _output;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 50,
        ),
        Column(
          children: <Widget>[
            /**
                 *  Adding dollar symbol in card
                 */
            Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Container(
                height: 100,
                width: 100,
                child: Image.asset(
                  'images/dollar.jpg',
                  fit: BoxFit.contain,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(200),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text("Set up your balance",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0)),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Text(
                "How much cash do you have in your pocket?",
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Container(
                  height: 70,
                  color: Colors.grey[200],
                  child: Center(
                      child: Text(
                output,
                style: textStyle(),
              ))),
            ),
            
            Container(
              height: 70,
              color: Colors.grey[200],
              child: IconButton(
                icon: Icon(Icons.backspace),
                onPressed: () {
                  
                    int len = output.length;
                    print(len);
                    if (len > 1 && output !="0 NPR") {
                      deletedOutput = output.substring(0, len - 1);
                    }
                    print(deletedOutput);
                    setState(() {
                      if(len==1){
                        output = "0 NPR";
                        _output="";
                      }else if(output !="0 NPR"){
                        output = deletedOutput;
                        _output = deletedOutput;
                      }
                    });
                },
              ),
            )
          ],
        ),
        SizedBox(
          height: 50,
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              flatButton("1"),
              flatButton("2"),
              flatButton("3"),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              flatButton("4"),
              flatButton("5"),
              flatButton("6"),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              flatButton("7"),
              flatButton("8"),
              flatButton("9"),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              flatButton("."),
              flatButton("0"),
              FlatButton(
                child: Icon(
                  Icons.done_outline,
                  color: Colors.green,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return HomePage(output);
                  }));
                },
              ),
            ],
          ),
        ),
      ],
    ));
  }

  Widget flatButton(String buttonText) {
    return FlatButton(
      child: Text(buttonText, style: textStyle()),
      onPressed: () {
        buttonPressed(buttonText);
      },
    );
  }
}
