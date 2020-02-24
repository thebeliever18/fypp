import 'package:flutter/material.dart';

import 'login_registration_page.dart';
//Underline color of text field

setFocusedBorder() {
  return UnderlineInputBorder(
      borderSide: BorderSide(color: Color.fromRGBO(80, 213, 162, 1.0)));
}

setLightGreenColor(){
   return Color.fromRGBO(7, 226, 177, 1.0);
}

setNaturalGreenColor(){
  return Color.fromRGBO(80, 213, 162, 1.0);
}

Future<String> getUserId() async{
  LoginRegistrationPageState obj =
                    new LoginRegistrationPageState();
  String uid = await obj.getCurrentUserId();
  return uid;
}
