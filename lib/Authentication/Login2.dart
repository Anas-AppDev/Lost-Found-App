import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lostfound/Admin/HomeA.dart';
import 'package:lostfound/Admin/HomeA2.dart';
import 'package:lostfound/Admin/NavDrawerA2.dart';
import 'package:lostfound/Authentication/Forgot.dart';
import 'package:lostfound/Authentication/Forgot2.dart';
import 'package:lostfound/Authentication/SignupA.dart';
import 'package:lostfound/Authentication/SignupA2.dart';
import 'package:lostfound/Authentication/SignupS.dart';
import 'package:lostfound/Authentication/SignupS2.dart';
import 'package:lostfound/Student/HomeS.dart';
import 'package:lostfound/ToastUtil.dart';

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
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              Color(0xff0B69FF),
              Color(0xff418AFF),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            height: 644,
            margin: EdgeInsets.only(top: 200),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
                color: Colors.white
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40,),
                  Text("Log in", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Color(0xff418AFF), fontSize: 40),),
                  SizedBox(height: 50,),
                  Text("   CU Mail", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Color(0xff418AFF), fontSize: 20),),
                  SizedBox(height: 10,),
                  Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: Color(0xffE7F0FF),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: cumailCtrl,
                                  decoration: InputDecoration(
                                      hintText: "Enter CU Mail",
                                      hintStyle: TextStyle(
                                        fontFamily: "Poppins",
                                        color: Color(0xff468DFF), // Change this color to your desired hint text color
                                      ),
                                      prefixIcon: Icon(CupertinoIcons.mail, color: Color(0xff418AFF),),
                                      border: InputBorder.none
                                  ),
                                  maxLines: 1,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Enter CU Mail Id";
                                    }
                                    if (!(value.endsWith("@gmail.com") || value.endsWith('@cuchd.in'))) {
                                      return "Enter only CU Mail Id";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 40,),
                        Text("   Password", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Color(0xff418AFF), fontSize: 20),),
                        SizedBox(height: 10,),
                        Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: Color(0xffE7F0FF),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: passCtrl,
                                  decoration: InputDecoration(
                                    hintText: "Enter password",
                                    hintStyle: TextStyle(
                                      fontFamily: "Poppins",
                                      color: Color(0xff468DFF), // Change this color to your desired hint text color
                                    ),
                                    prefixIcon: Icon(CupertinoIcons.lock, color: Color(0xff418AFF),),
                                    border: InputBorder.none,
                                    counterText: "",
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
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    key: formKey,
                  ),

                  SizedBox(height: 50,),
                  InkWell(
                    onTap: () async{
                      if (formKey.currentState!.validate()) {
                        try {
                          final userCredential = await auth.signInWithEmailAndPassword(
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
                              Navigator.push(context, MaterialPageRoute(builder: (context) => NavDrawerA2()));
                            }
                            else{
                              ToastUtil().toast("Email not verified");
                            }
                          }
                        } catch (e) {
                          ToastUtil().toast("Login failed: $e");
                        }
                      }
                    },
                    child: Center(
                      child: Container(
                        height: 60,
                        width: 240,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Color(0xff0B69FF),
                              Color(0xff5999FF),
                            ]),
                            borderRadius: BorderRadius.circular(21)),
                        child: Center(
                          child: Text(
                            'Log In',
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: TextButton(
                      onPressed: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Forgot2()));
                      },
                      child: Text(
                        "Forget Password?",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                            color: Color(0xff468DFF)),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignupA2()));
                        },
                        child: Text(
                          "SignUp as Admin",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Text("|", style: TextStyle(color: Color(0xff468DFF)),),
                      SizedBox(width: 10,),
                      InkWell(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignupS2()));
                        },
                        child: Text(
                          "SignUp as Student",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.bold,
                              color: Color(0xff468DFF)),
                        ),
                      ),
                    ],),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


