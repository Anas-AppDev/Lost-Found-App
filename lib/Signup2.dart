import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lostfound/Login2.dart';

import 'ToastUtil.dart';

class Signup2 extends StatefulWidget {
  const Signup2({super.key});

  @override
  State<Signup2> createState() => _Signup2State();
}

class _Signup2State extends State<Signup2> {

  var formKey = GlobalKey<FormState>();
  var cumailCtrl = TextEditingController();
  var passCtrl = TextEditingController();

  var auth = FirebaseAuth.instance;
  var real = FirebaseDatabase.instance.ref("LostFound");

  late Timer timer;
  bool isResendButtonEnabled = true;

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
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
                        timer = Timer(Duration(seconds: 60), () {
                          setState(() {
                            isResendButtonEnabled = true;
                          });
                        });

                        // Show a toast message or alert indicating that a verification email has been sent
                        ToastUtil().toast("Verification email sent. Please verify your email before logging in.");

                        // Delay navigation to allow time for the user to see the toast message
                        Timer.periodic(Duration(seconds: 3), (timer) async{
                          await auth.currentUser!.reload();
                          if (auth.currentUser!.emailVerified){
                            await real.child('VerifiedUsers').set({ auth.currentUser!.uid : auth.currentUser!.email.toString()});
                            timer.cancel();
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Login2()));
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
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Login2()));
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
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Login2()));
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
