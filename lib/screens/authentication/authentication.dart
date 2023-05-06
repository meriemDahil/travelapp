import 'package:travel_app/screens/authentication/register.dart';
import 'package:travel_app/screens/authentication/signIn.dart';

import 'package:flutter/material.dart';


class authentication extends StatefulWidget {
  const authentication({super.key});

  @override
  State<authentication> createState() => _authenticationState();
}

class _authenticationState extends State<authentication> {
   bool login =true;
   void toogleScreens () async{
    setState((){
    login =  !login;
   });
   }
  
  @override
  Widget build(BuildContext context) {
    
    if (login) {
      return Register(showlogin:toogleScreens);
    } else {
      return SignIn(showregister:toogleScreens);
    }
    
  }
}