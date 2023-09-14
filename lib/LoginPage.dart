import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lostfound/HomePage.dart';
import 'package:lostfound/SignupPage.dart';
import 'package:lostfound/ToastUtil.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

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
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: Container(
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
                      validator: (value){
                        if (value!.isEmpty){
                          return "Enter CU Mail Id";
                        }
                        if (auth.currentUser != null){
                          if (!(auth.currentUser!.emailVerified)){
                            return "CU Mail not verified yet";
                          }
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
                  if (auth.currentUser!=null){
                    await auth.currentUser!.reload();
                  }
                  if(formKey.currentState!.validate()){
                    auth.signInWithEmailAndPassword(email:cumailCtrl.text.toString(), password:passCtrl.text.toString()).then((value){

                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomePage()));
                    }).onError((error, stackTrace){
                      ToastUtil().toast(error.toString());
                    });
                  }
                }, child: Text("Login")),
                SizedBox(height: 10,),
                TextButton(onPressed: (){
                  print(auth.currentUser!.emailVerified);
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=> ))
                }, child: Text("Forgot Pass?")),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? "),
                    TextButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> SignupPage()));
                    }, child: Text("Signup")),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
