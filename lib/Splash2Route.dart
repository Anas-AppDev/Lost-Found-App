import 'package:flutter/material.dart';
import 'package:lostfound/Login2.dart';


class Splash2Route{

  void isLogin(BuildContext context){
    Future.delayed(Duration(seconds: 1),(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login2()));
    });
  }
}