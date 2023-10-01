import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lostfound/Admin/ClaimA1.dart';
import 'package:lostfound/Admin/HomeA.dart';
import 'package:lostfound/Admin/HomeA2.dart';
import 'package:lostfound/Admin/RequestA2.dart';
import 'package:lostfound/Authentication/Login2.dart';
import 'package:lostfound/Authentication/SignupS.dart';
import 'package:lostfound/Authentication/SignupS2.dart';
import 'package:lostfound/Authentication/SplashPage.dart';
import 'package:lostfound/Student/HomeS2.dart';
import 'package:lostfound/Student/RequestS2.dart';
import 'package:smooth_corner/smooth_corner.dart';

import 'AddItemA2.dart';

class HomeA2 extends StatefulWidget {
  const HomeA2({super.key});

  @override
  State<HomeA2> createState() => _HomeA2State();
}

class _HomeA2State extends State<HomeA2> {

  var imgLink = "https://i.pinimg.com/564x/df/00/14/df001467ef17f34e505f54a7f60e4440.jpg";
  var searchCtrl = TextEditingController();

  var auth = FirebaseAuth.instance;
  var real = FirebaseDatabase.instance.ref("LostFound");
  var firestore = FirebaseFirestore.instance.collection("LostFound");

  double value = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: Colors.white,),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Container(
                        width: 270,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Color(0xffF5F5F5),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: InkWell(
                                  onTap: (){

                                  },
                                  child: Icon(CupertinoIcons.search)),
                            ),
                            Expanded(
                              child: TextField(
                                controller: searchCtrl,
                                decoration: InputDecoration(
                                  hintText: "Search Item...",
                                  border: InputBorder.none,
                                ),
                                onChanged: (value){
                                  setState(() {

                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10,),
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Color(0xffF5F5F5)
                        ),
                        child: Transform.scale(
                            scale: 0.5,
                            child: SvgPicture.asset('assets/icons/filter.svg', color: Colors.black,)
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 40,),
                  Row(
                    children: [
                      SizedBox(width: 15,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Items", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.black, fontSize: 28, height: 1.2, letterSpacing: 1.2),),
                          Text("10 Results", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.black, fontSize: 28, height: 1.2, letterSpacing: 1.2),),
                        ],
                      ),
                      SizedBox(width: 125,),
                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> AddItemA2()));
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Color(0xff418AFF),
                          ),
                          child: Icon(CupertinoIcons.add, color: Colors.white, size: 24,),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20,),

                  StreamBuilder(
                    stream: firestore.doc("Inventory").collection("items").where("adminUid", isEqualTo: auth.currentUser!.uid).snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){


                      if (snapshot.hasError){
                        return Center(child: Text("Something went wrong"));
                      }
                      if (snapshot.connectionState == ConnectionState.waiting){
                        return Center(child: CupertinoActivityIndicator());
                      }
                      if (snapshot.data!.docs.isEmpty){
                        return Center(child: Text("No data found"));
                      }

                      if (snapshot!=null && snapshot.data!=null){
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index){
                            var pid = snapshot.data!.docs[index].id;
                            var iName = snapshot.data!.docs[index]['iName'];
                            var iType = snapshot.data!.docs[index]['iType'];
                            return InkWell(
                              onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> ClaimA1(pid: pid, iName: iName, iType: iType,))),
                              onLongPress: (){
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context){
                                    return CupertinoAlertDialog(
                                      title: Text("Remove Item"),
                                      content: Column(
                                        children: [
                                          SizedBox(height: 10,),
                                          Container(
                                            height: 88,
                                            width: 88,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(18),
                                              color: Colors.green,
                                            ),
                                          ),
                                          Text("Are you sure you want to remove this item ?"),
                                        ],
                                      ),
                                      actions: [
                                        CupertinoDialogAction(
                                          onPressed: (){
                                            Navigator.pop(context);
                                          },
                                          child: Text("No"),
                                        ),
                                        CupertinoDialogAction(
                                          onPressed: (){
                                            firestore.doc("Inventory").collection("items").doc(pid).delete();
                                            firestore.doc("Stud Requests").collection("Claims Pending").doc(pid).delete();
                                            Navigator.pop(context);
                                          },
                                          child: Text("Yes"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 20),
                                height: 180,
                                width: MediaQuery.of(context).size.width,
                                decoration: ShapeDecoration(
                                  shape: SmoothRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    smoothness: 1,
                                  ),
                                  color: Colors.amber,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xFF3E2445).withOpacity(0.6),
                                        spreadRadius: -20,
                                        blurRadius: 20,
                                        offset: Offset(0, 30),
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    children: [
                                      SmoothClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        smoothness: 1,
                                        child: Image.network(
                                          imgLink,
                                          fit: BoxFit.cover,
                                          height: MediaQuery.of(context).size.height,
                                          width: MediaQuery.of(context).size.width,
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(width: 25,),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  // Text(snapshot.data!.docs[index]['iLoc'], style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.normal, color: Colors.white, fontSize: 12, height: 1.2),),
                                                  Container(
                                                      width: 290,
                                                      child: Text(iName, style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 24, height: 1.2),)),
                                                  SizedBox(height: 26,),
                                                  Text(snapshot.data!.docs[index]['foundDate'], style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16, height: 1),),
                                                  Text(snapshot.data!.docs[index]['iLoc'], style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.normal, color: Colors.white, fontSize: 12, height: 1.2),),
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }

                      // print(snapshot.data!.docs[0]['b']);
                      return Container();
                    },
                  ),




                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}