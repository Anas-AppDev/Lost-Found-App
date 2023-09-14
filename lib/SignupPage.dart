import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lostfound/HomePage.dart';
import 'package:lostfound/LoginPage.dart';
import 'package:lostfound/SignupPage.dart';

import 'ToastUtil.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  var formKey = GlobalKey<FormState>();
  var cumailCtrl = TextEditingController();
  var passCtrl = TextEditingController();

  var auth = FirebaseAuth.instance;
  late Timer timer;

  @override
  void dispose() {
    super.dispose();
    cumailCtrl.dispose();
    passCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(
            color: Colors.black
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
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
                    validator: (value){
                      if (value!.isEmpty){
                        return "Enter CU Mail Id";
                      }
                      if (!(value.endsWith("@cuchd.in"))){
                        return "Enter CU Mail Id only";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: passCtrl,
                    decoration: InputDecoration(
                      hintText: "Enter your CU Mail",
                      prefixIcon: Icon(CupertinoIcons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLength: 6,
                    maxLines: 1,
                    validator: (value){
                      if (value!.isEmpty){
                        return "Enter Password (6-digit)";
                      }
                      return null;
                    },
                  ),
                ],
              ),
                key: formKey,),
              SizedBox(height: 20,),
              ElevatedButton(onPressed: () async{
                if (formKey.currentState!.validate()){
                    await auth.createUserWithEmailAndPassword(email: cumailCtrl.text, password: passCtrl.text).then((value) async{

                      auth.currentUser!.sendEmailVerification();
                      ToastUtil().toast("Verification link sent to your CU Mail");
                      timer = Timer.periodic(Duration(seconds: 5), (timer) async{
                          await auth.currentUser!.reload();
                          if (auth.currentUser!.emailVerified){
                                  timer.cancel();
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomePage()));
                                  ToastUtil().toast("CU Mail verified");
                              }
                          });
                    }).onError((error, stackTrace){
                      ToastUtil().toast(error.toString());
                    });



                }
              }, child: Text("Sign Up")),
              SizedBox(height: 20,),
              TextButton(onPressed: (){
                if (auth.currentUser != null){
                  if (auth.currentUser!.emailVerified){
                    ToastUtil().toast("Already Verfied");
                  }
                  else{
                    auth.currentUser!.sendEmailVerification();
                    ToastUtil().toast("Verification Link sent");
                    timer = Timer.periodic(Duration(seconds: 5), (timer) async{
                      await auth.currentUser!.reload();
                      if (auth.currentUser!.emailVerified){
                        timer.cancel();
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginPage()));
                        ToastUtil().toast("CU Mail verified");
                      }
                    });
                  }
                }

              }, child: Text("Resend Verification Link")),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? "),
                  TextButton(onPressed: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginPage()));
                  }, child: Text("Login")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
