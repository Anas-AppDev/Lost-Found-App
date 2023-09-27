import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lostfound/Authentication/Login.dart';

import '../ToastUtil.dart';

class SignupS extends StatefulWidget {
  const SignupS({super.key});

  @override
  State<SignupS> createState() => _SignupSState();
}

class _SignupSState extends State<SignupS> {

  var formKey = GlobalKey<FormState>();
  var cumailCtrl = TextEditingController();
  var passCtrl = TextEditingController();
  var nameCtrl = TextEditingController();

  var auth = FirebaseAuth.instance;
  var firestore = FirebaseFirestore.instance.collection("LostFound");

  late Timer timer;
  bool isResendButtonEnabled = true;


  @override
  void dispose() {
    super.dispose();
    // timer.cancel();
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
              Text("SIGN UP"),
              Form(child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: nameCtrl,
                    decoration: InputDecoration(
                      hintText: "Enter name",
                      prefixIcon: Icon(CupertinoIcons.person_alt_circle),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLength: 20,
                    maxLines: 1,
                    validator: (value){
                      if (value!.isEmpty){
                        return "Enter Name";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20,),
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
                      hintText: "Enter password",
                      prefixIcon: Icon(CupertinoIcons.mail),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLength: 15,
                    maxLines: 1,
                    validator: (value){
                      if (value!.isEmpty){
                        return "Enter password";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20,),
                  SizedBox(height: 20,),
                ],
              ),
                key: formKey,),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    try {
                      print("aaa ${auth.currentUser}");
                      final userCredential = await auth.createUserWithEmailAndPassword(
                        email: cumailCtrl.text.trim().toLowerCase(),
                        password: passCtrl.text.trim(),
                      );
                      print("bb ${auth.currentUser}");

                      if (userCredential.user != null) {
                        // Send email verification
                        await userCredential.user!.sendEmailVerification();
                        setState(() {
                          isResendButtonEnabled = false;
                        });

                        // Start a timer to re-enable the button after a certain duration (e.g., 60 seconds)
                        Timer(Duration(seconds: 60), () {
                          setState(() {
                            isResendButtonEnabled = true;
                          });
                        });

                        // Show a toast message or alert indicating that a verification email has been sent
                        ToastUtil().toast("Verification email sent. Please verify your email before logging in.");

                        // Delay navigation to allow time for the user to see the toast message
                        timer = Timer.periodic(Duration(seconds: 3), (timer) async{
                          await auth.currentUser!.reload();
                          if (auth.currentUser!.emailVerified){

                            firestore.doc('VerifiedUsers').collection("Students").add({auth.currentUser!.uid : auth.currentUser!.email.toString()});
                            firestore.doc("Users").collection("Students").doc(auth.currentUser!.uid).set(
                                {
                                  "name": nameCtrl.text,
                                  "uniUid": cumailCtrl.text.split("@")[0],
                                  "studUid": auth.currentUser!.uid,
                                }
                            );

                            timer.cancel();
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Login()));
                            ToastUtil().toast("CU Mail verified");
                          }
                        });
                      }
                    } catch (e) {
                      // Handle registration errors, such as invalid email or weak password
                      ToastUtil().toast("Registration failed: $e");
                    }
                  }
                },
                child: Text("Sign Up"),
              ),

              SizedBox(height: 20,),
              TextButton(onPressed: () async{

                try {

                  if (!(auth.currentUser!.emailVerified)){
                    if (isResendButtonEnabled){

                      final user = auth.currentUser;
                      if (user != null) {
                        await user.sendEmailVerification();

                        setState(() {
                          isResendButtonEnabled = false;
                        });

                        // Start a timer to re-enable the button after a certain duration (e.g., 60 seconds)
                        Timer(Duration(seconds: 60), () {
                          setState(() {
                            isResendButtonEnabled = true;
                          });
                        });
                        // Show a toast message or alert indicating that a new verification email has been sent
                        ToastUtil().toast("New verification email sent. Please check your inbox.");
                        timer = Timer.periodic(Duration(seconds: 3), (timer) async{
                          await auth.currentUser!.reload();
                          if (auth.currentUser!.emailVerified){
                            print("cc ${auth.currentUser}");
                            timer.cancel();
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Login()));
                            ToastUtil().toast("CU Mail verified");
                          }
                        });
                        // You can also update the UI if needed, e.g., disable the Resend button for a cooldown period
                      }

                    }
                    else{
                      ToastUtil().toast("Wait 1 min before sending another request");
                    }
                  }
                  else{
                    ToastUtil().toast("already verified");
                  }


                } catch (e) {
                  // Handle any errors that may occur during email sending
                  ToastUtil().toast("Failed to send verification email: $e");
                }

              }, child: Text("Resend Verification Link")),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? "),
                  TextButton(onPressed: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Login()));
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
