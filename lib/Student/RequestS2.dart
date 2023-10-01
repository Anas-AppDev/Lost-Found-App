import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lostfound/Student/DetailOfRequestS2.dart';
import 'package:smooth_corner/smooth_corner.dart';

import '../Admin/AddItemA2.dart';

class RequestS2 extends StatefulWidget {
  const RequestS2({super.key});

  @override
  State<RequestS2> createState() => _RequestS2State();
}

class _RequestS2State extends State<RequestS2> {

  var searchCtrl = TextEditingController();
  var imgLink = "https://i.pinimg.com/564x/df/00/14/df001467ef17f34e505f54a7f60e4440.jpg";

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
                        width: 330,
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
                    ],
                  ),

                  SizedBox(height: 40,),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Claims Pending", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.black, fontSize: 28, height: 1.2, letterSpacing: 1.2),),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 10,),
                  InkWell(
                    onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailOfClaimS2())),
                    child: Container(
                      height: 80,
                      width: MediaQuery.of(context).size.width,
                      decoration: ShapeDecoration(
                        shape: SmoothRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          smoothness: 1,
                        ),
                        color: Colors.amber,
                      ),
                      child: Stack(
                        children: [
                          SmoothClipRRect(
                            borderRadius: BorderRadius.circular(18),
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
                                  Container(
                                    width: 8,
                                    height: 43,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Student Uid", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.normal, color: Colors.white, fontSize: 10, height: 1.5),),
                                      Container(
                                          width: 250,
                                          child: Text("Item Name", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18, height: 1.0),)),
                                    ],
                                  ),
                                  SizedBox(width: 5,),
                                  InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailOfClaimS2()));
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.black,
                                      ),
                                      child: Icon(CupertinoIcons.color_filter, color: Colors.white, size: 20,),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  //--------------------Pending Requests-----------------------

                  SizedBox(height: 40,),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Pending Requests", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.black, fontSize: 28, height: 1.2, letterSpacing: 1.2),),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 10,),
                  InkWell(
                    onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailOfClaimS2())),
                    child: Container(
                      height: 80,
                      width: MediaQuery.of(context).size.width,
                      decoration: ShapeDecoration(
                        shape: SmoothRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          smoothness: 1,
                        ),
                        color: Colors.amber,
                      ),
                      child: Stack(
                        children: [
                          SmoothClipRRect(
                            borderRadius: BorderRadius.circular(18),
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
                                  Container(
                                    width: 8,
                                    height: 43,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Student Uid", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.normal, color: Colors.white, fontSize: 10, height: 1.5),),
                                      Container(
                                          width: 250,
                                          child: Text("Item Name", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18, height: 1.0),)),
                                    ],
                                  ),
                                  SizedBox(width: 5,),
                                  InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailOfClaimS2()));
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.black,
                                      ),
                                      child: Icon(CupertinoIcons.color_filter, color: Colors.white, size: 20,),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  //--------------------Claims Accepted-----------------------

                  SizedBox(height: 40,),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Claims Accepted", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.black, fontSize: 28, height: 1.2, letterSpacing: 1.2),),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 10,),
                  InkWell(
                    onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailOfClaimS2())),
                    child: Container(
                      height: 80,
                      width: MediaQuery.of(context).size.width,
                      decoration: ShapeDecoration(
                        shape: SmoothRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          smoothness: 1,
                        ),
                        color: Colors.amber,
                      ),
                      child: Stack(
                        children: [
                          SmoothClipRRect(
                            borderRadius: BorderRadius.circular(18),
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
                                  Container(
                                    width: 8,
                                    height: 43,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Student Uid", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.normal, color: Colors.white, fontSize: 10, height: 1.5),),
                                      Container(
                                          width: 250,
                                          child: Text("Item Name", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18, height: 1.0),)),
                                    ],
                                  ),
                                  SizedBox(width: 5,),
                                  InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailOfClaimS2()));
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.black,
                                      ),
                                      child: Icon(CupertinoIcons.color_filter, color: Colors.white, size: 20,),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  //--------------------Accepted Requests-----------------------

                  SizedBox(height: 40,),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Accepted Requets", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.black, fontSize: 28, height: 1.2, letterSpacing: 1.2),),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 10,),
                  InkWell(
                    onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailOfClaimS2())),
                    child: Container(
                      height: 80,
                      width: MediaQuery.of(context).size.width,
                      decoration: ShapeDecoration(
                        shape: SmoothRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          smoothness: 1,
                        ),
                        color: Colors.amber,
                      ),
                      child: Stack(
                        children: [
                          SmoothClipRRect(
                            borderRadius: BorderRadius.circular(18),
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
                                  Container(
                                    width: 8,
                                    height: 43,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Student Uid", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.normal, color: Colors.white, fontSize: 10, height: 1.5),),
                                      Container(
                                          width: 250,
                                          child: Text("Item Name", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18, height: 1.0),)),
                                    ],
                                  ),
                                  SizedBox(width: 5,),
                                  InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailOfClaimS2()));
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.black,
                                      ),
                                      child: Icon(CupertinoIcons.color_filter, color: Colors.white, size: 20,),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
