import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lostfound/Authentication/Login2.dart';
import 'package:lostfound/HomePage.dart';
import 'package:lostfound/ToastUtil.dart';


class Splash2Route{

  void isLogin(BuildContext context){
    Future.delayed(Duration(seconds: 1),(){
      if (FirebaseAuth.instance.currentUser!=null){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomePage()));
      }
      else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login2()));
      }
    });
  }
}