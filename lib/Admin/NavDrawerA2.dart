import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
import 'package:lostfound/Student/ClaimS2.dart';
import 'package:lostfound/Student/HomeS2.dart';
import 'package:lostfound/Student/RequestS2.dart';
import 'package:smooth_corner/smooth_corner.dart';

class NavDrawerA2 extends StatefulWidget {
  const NavDrawerA2({super.key});

  @override
  State<NavDrawerA2> createState() => _NavDrawerA2State();
}

class _NavDrawerA2State extends State<NavDrawerA2> {

  var imgLink = "https://i.pinimg.com/564x/df/00/14/df001467ef17f34e505f54a7f60e4440.jpg";
  var searchCtrl = TextEditingController();

  var currIndex = 0;
  var auth = FirebaseAuth.instance;
  var firestore = FirebaseFirestore.instance.collection("LostFound");

  double NavValue = 0;

  List<Widget> pagesList = [
    HomeA2(),
    RequestA2(),
  ];

  List<IconData> iconsList = [
    CupertinoIcons.home,
    CupertinoIcons.hammer_fill,
  ];



  double returnValue(){
    return NavValue;
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff0B69FF), Color(0xff418AFF)],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),

          SafeArea(
            child: Container(
              width: 220,
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DrawerHeader(
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.white)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            decoration: ShapeDecoration(
                              shape: SmoothRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                smoothness: 1,
                              ),
                              color: Colors.amber,
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
                              ],
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text("['name']", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15, height: 1.2),),
                          Text("['uniEid']", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.normal, color: Colors.white, fontSize: 11,),),


                        ],
                      )),

                  Expanded(
                      child: ListView(
                        itemExtent: 30,
                        children: [
                          ListTile(
                            leading: Text("Cabin No.", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.normal, color: Colors.white, fontSize: 14, ),),
                            trailing: Text("['cabin']", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.normal, color: Colors.white, fontSize: 14, ),),
                          ),
                          ListTile(
                            leading: Text("Block", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.normal, color: Colors.white, fontSize: 14, ),),
                            trailing: Text("['block']", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.normal, color: Colors.white, fontSize: 14, ),),
                          ),
                        ],
                      )),

                  SizedBox(height: 400,),

                  InkWell(
                    onTap: (){
                      auth.signOut();
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Login2()));
                    },
                    child: Container(
                      height: 40,
                      width: 140,
                      decoration: ShapeDecoration(
                        shape: SmoothRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          smoothness: 1,
                        ),
                        color: Colors.black,
                      ),
                      child: Center(child: Text("Log Out", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12, ),),),
                    ),
                  ),
                ],
              ),
            ),
          ),



          GestureDetector(
            onTap: (){
              if (NavValue==1){
                setState(() {
                  NavValue=0;
                });
              }
            },
            child: TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: NavValue),
              duration: Duration(milliseconds: 500),
              curve: Curves.easeIn,
              builder: (_,double val,__){
                return(
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..setEntry(0, 3, 200*val)
                        ..rotateY((pi/6)*val),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Scaffold(
                          appBar: AppBar(
                            elevation: 0,
                            backgroundColor: Colors.white,
                            leading: IconButton(
                              onPressed: () {
                                setState(() {
                                  NavValue == 0 ? NavValue=1 : NavValue=0;
                                });
                              },
                              icon: SvgPicture.asset('assets/icons/hamburgerIcon.svg', height: 80, color: Colors.black,),
                            ),
                          ),
                          body: pagesList[currIndex],
                          extendBody: true,
                          bottomNavigationBar: Padding(
                            padding: EdgeInsets.all(25),
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 80),
                              height: 60,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xff327ffa),
                                    Color(0xff5a9aff),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(.1),
                                    blurRadius: 30,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ListView.builder(
                                itemCount: iconsList.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) => InkWell(
                                  onTap: () {
                                    setState(() {
                                      currIndex = index;
                                    },
                                    );
                                  },
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      AnimatedContainer(
                                        duration: Duration(milliseconds: 1500),
                                        curve: Curves.fastLinearToSlowEaseIn,
                                        margin: EdgeInsets.only(
                                          bottom: index == currIndex ? 0 : 11,
                                          right: 20,
                                          left: 20,
                                        ),
                                        width: 50,
                                        height: index == currIndex ? 5 : 0,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.vertical(
                                            bottom: Radius.circular(50),
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        iconsList[index],
                                        size: 30,
                                        color: index == currIndex
                                            ? Colors.white
                                            : Color(0xFFC5C5C5),
                                      ),
                                      SizedBox(height: 14),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),


                        ),
                      ),
                    )
                );
              },
            ),
          ),

          GestureDetector(
            onHorizontalDragUpdate: (e){
              if (e.delta.dx>0){
                setState(() {
                  NavValue=1;
                });
              }
              else{
                setState(() {
                  NavValue=0;
                });
              }
            },
          ),
        ],
      ),
    );
  }
}

