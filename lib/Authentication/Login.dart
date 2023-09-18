import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lostfound/Authentication/Forgot.dart';
import 'package:lostfound/Authentication/SignupA.dart';
import '../Admin/HomeA.dart';
import '../Student/HomeS.dart';
import 'SignupS.dart';
import '../ToastUtil.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var formKey = GlobalKey<FormState>();
  var cumailCtrl = TextEditingController();
  var passCtrl = TextEditingController();

  var auth = FirebaseAuth.instance;
  var real = FirebaseDatabase.instance.ref("LostFound");
  var firestore = FirebaseFirestore.instance.collection("LostFound");

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
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 40,),
                  Text("LOGIN"),
                  SizedBox(
                    height: 20,
                  ),
                  Form(
                    child: Column(
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
                            if (!(value.endsWith("@gmail.com") || value.endsWith('@cuchd.in'))) {
                              return "Enter CU Mail Id only";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          controller: passCtrl,
                          decoration: InputDecoration(
                            hintText: "Enter password",
                            prefixIcon: Icon(CupertinoIcons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          maxLength: 15,
                          maxLines: 1,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter Password (6-digit)";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    key: formKey,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          try {
                            // Sign in the user with email and password
                            final userCredential =
                                await auth.signInWithEmailAndPassword(
                              email: cumailCtrl.text.trim().toLowerCase(),
                              password: passCtrl.text.trim(),
                            );


                            QuerySnapshot querySnapshot = await firestore.doc("VerifiedUsers").collection("Students")
                                .where(auth.currentUser!.uid, isEqualTo: cumailCtrl.text.toLowerCase())
                                .get();

                            if (querySnapshot.docs.isNotEmpty) {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeS()));
                            } else {
                              querySnapshot = await firestore.doc("VerifiedUsers").collection("Admins")
                                  .where(auth.currentUser!.uid, isEqualTo: cumailCtrl.text.toLowerCase())
                                  .get();

                              if (querySnapshot.docs.isNotEmpty){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeA()));
                              }
                              else{
                                ToastUtil().toast("Email not verified");
                              }

                            }



                          } catch (e) {
                            // Handle login errors, e.g., invalid email or password
                            ToastUtil().toast("Login failed: $e");
                          }
                        }
                      },
                      child: Text("Login")),
                  SizedBox(
                    height: 10,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> Forgot()));

                      },
                      child: Text("Forgot Pass?")),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? "),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignupA()));
                          },
                          child: Text("Signup Admin")),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? "),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignupS()));
                          },
                          child: Text("Signup Student")),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
