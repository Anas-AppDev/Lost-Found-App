import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lostfound/Authentication/Forgot.dart';
import 'package:lostfound/Authentication/Login2.dart';
import 'package:lostfound/ToastUtil.dart';

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
        elevation: 0,
        backgroundColor: Colors.white,
        leading: BackButton(
          color: Color(0xff418AFF),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white
        ),
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            height: 491,
            margin: EdgeInsets.only(top: 250),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                    Color(0xff0B69FF),
                    Color(0xff418AFF),
                  ],
                ),
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
                  Text("Forgot", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 40),),
                  Text("Password", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 40),),

                  Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 50,),
                        Text("   CU Mail", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),),
                        SizedBox(height: 10,),
                        Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18.0),
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
                                      border: InputBorder.none,
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
                    onTap: () {

                      if (formKey.currentState!.validate()) {
                        auth.sendPasswordResetEmail(email: cumailCtrl.text.toLowerCase()).then((value){
                          ToastUtil().toast("Check your cumail");
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Login2()));
                        }).onError((error, stackTrace){
                          ToastUtil().toast(error.toString());
                        });
                      }
                    },
                    child: Center(
                      child: Container(
                        height: 60,
                        width: 240,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(21)),
                        child: Center(
                          child: Text(
                            'Send',
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff418AFF),
                            ),
                          ),
                        ),
                      ),
                    ),
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
