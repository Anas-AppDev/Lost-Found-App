import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lostfound/ToastUtil.dart';

import 'Login2.dart';

class Forgot2 extends StatefulWidget {
  const Forgot2({super.key});

  @override
  State<Forgot2> createState() => _Forgot2State();
}

class _Forgot2State extends State<Forgot2> {

  var formKey = GlobalKey<FormState>();
  var cumailCtrl = TextEditingController();

  var auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(
            color: Colors.black
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20,),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: cumailCtrl,
                  decoration: InputDecoration(
                    hintText: "Enter your CU Mail",
                    prefixIcon: Icon(CupertinoIcons.mail),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  maxLines: 1,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter CU Mail Id";
                    }
                    if (!(value.endsWith("@cuchd.in"))) {
                      return "Enter CU Mail Id only";
                    }
                    return null;
                  },
                ),
              ],
            )),
            ElevatedButton(onPressed: (){

              auth.sendPasswordResetEmail(email: cumailCtrl.text.toLowerCase()).then((value){
                ToastUtil().toast("Check your cumail");
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Login2()));
              }).onError((error, stackTrace){
                ToastUtil().toast(error.toString());
              });

            }, child: Text("Send")),
          ],
        ),
      ),
    );
  }
}
