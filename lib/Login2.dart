import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lostfound/HomePage.dart';
import 'package:lostfound/Signup2.dart';

import 'SignupPage.dart';
import 'ToastUtil.dart';

class Login2 extends StatefulWidget {
  const Login2({super.key});

  @override
  State<Login2> createState() => _Login2State();
}

class _Login2State extends State<Login2> {

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
                Text("LOGIN"),
                SizedBox(height: 20,),
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
                    if(formKey.currentState!.validate()){
                      try {
                        // Sign in the user with email and password
                        final userCredential = await auth.signInWithEmailAndPassword(
                          email: cumailCtrl.text.trim(),
                          password: passCtrl.text.trim(),
                        );

                        // Check if the user is verified
                        if (userCredential.user != null && userCredential.user!.emailVerified) {
                          // User is verified, allow login
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage()));
                        } else {
                          // User is not verified, display an error message
                          ToastUtil().toast("Please verify your email before logging in.");
                        }
                      } catch (e) {
                        // Handle login errors, e.g., invalid email or password
                        ToastUtil().toast("Login failed: $e");
                      }
                    }
                }, child: Text("Login")),
                SizedBox(height: 10,),
                TextButton(onPressed: (){
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=> ))
                }, child: Text("Forgot Pass?")),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? "),
                    TextButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> Signup2()));
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