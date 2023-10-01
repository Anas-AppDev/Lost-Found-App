import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lostfound/Authentication/Login.dart';
import 'package:lostfound/Authentication/Login2.dart';
import '../Admin/HomeA.dart';
import '../Student/HomeS.dart';


class Splash2Route{

  void isLogin(BuildContext context){
    Future.delayed(Duration(seconds: 1),(){
      if (FirebaseAuth.instance.currentUser!=null){
        if (FirebaseAuth.instance.currentUser!.email.toString().endsWith("@cuchd.in")){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomeS()));
        }
        else{
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomeA()));
        }
      }
      else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login2()));
      }
    });
  }
}