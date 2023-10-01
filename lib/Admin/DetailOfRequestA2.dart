import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailOfRequestA2 extends StatefulWidget {

  String pid, studUid;
  DetailOfRequestA2({super.key, required this.pid, required this.studUid});

  @override
  State<DetailOfRequestA2> createState() => _DetailOfRequestA2State();
}

class _DetailOfRequestA2State extends State<DetailOfRequestA2> {


  var firestore = FirebaseFirestore.instance.collection("LostFound");
  var auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor:
          Colors.transparent, // Make the AppBar background transparent
          leading: BackButton(color: Color(0xffffffff)),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff0B69FF), Color(0xff418AFF)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xff0B69FF),
                  Color(0xff418AFF),
                ],
              ),
            ),
            child: Column(
              children: [
                StreamBuilder(
                  stream: firestore.doc("Stud Requests").collection("Claims Pending").where("pid", isEqualTo: widget.pid).where("studUid", isEqualTo: widget.studUid).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                    if (snapshot.hasError){
                      return Center(child: Text("Something went wrong"));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting){
                      return Center(child: CupertinoActivityIndicator());
                    }
                    if (snapshot.data!.docs.isEmpty){
                      return Container();
                    }

                    if (snapshot!=null && snapshot.data!=null){
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index){

                          var iName = snapshot.data!.docs[index]['iName'];
                          var iDesc = snapshot.data!.docs[index]['iDesc'];
                          var iType = snapshot.data!.docs[index]['iType'];
                          var iColor = snapshot.data!.docs[index]['iColor'];
                          var iLoc = snapshot.data!.docs[index]['iLoc'];
                          var iUniq = snapshot.data!.docs[index]['iUniq'];
                          var lostDate = snapshot.data!.docs[index]['lostDate'];
                          var lostTime = snapshot.data!.docs[index]['lostTime'];
                          var iImg = snapshot.data!.docs[index]['iImg'];

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 30,),
                              Text("Claim", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 40, height: 1.2),),
                              Text("This Item", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 40, height: 1.2),),

                              SizedBox(height: 30,),
                              Text("  Item Name *", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),),
                              SizedBox(height: 5,),
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 15,),
                                    Expanded(
                                      child: Text(iName),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 20,),
                              Text("  Description *", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),),
                              SizedBox(height: 5,),
                              Container(
                                height: 150,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 15,),
                                    Container(
                                      padding: EdgeInsets.only(top: 15),
                                      width: 300,
                                      child: Text(iDesc),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("  Type", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),),
                                      SizedBox(height: 5,),
                                      Container(
                                        height: 50,
                                        width: 150,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12.0),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            SizedBox(width: 15,),
                                            Expanded(
                                              child: Text(iType),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("   Color", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),),
                                      SizedBox(height: 5,),
                                      Container(
                                        height: 50,
                                        width: 150,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12.0),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            SizedBox(width: 15,),
                                            Expanded(
                                              child: Text(iColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              SizedBox(height: 20,),
                              Text("  Unique Identifier", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),),
                              SizedBox(height: 10,),
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 15,),
                                    Expanded(
                                      child: Text(iUniq),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 20,),
                              Text("  Lost Location", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),),
                              SizedBox(height: 10,),
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 15,),
                                    Expanded(
                                      child: Text(iLoc),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("  Lost Date", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),),
                                      SizedBox(height: 5,),
                                      Container(
                                        height: 50,
                                        width: 150,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12.0),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            SizedBox(width: 15,),
                                            Expanded(
                                              child: Text(lostDate),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("   Lost Time", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),),
                                      SizedBox(height: 5,),
                                      Container(
                                        height: 50,
                                        width: 150,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12.0),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            SizedBox(width: 15,),
                                            Expanded(
                                              child: Text(lostTime),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              SizedBox(height: 20,),
                              Text("  Image Upload", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),),
                              SizedBox(height: 10,),
                              Container(
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: (iImg!="") ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12), // Adjust the radius to match your container
                                  child: Image.network(iImg, fit: BoxFit.cover,),
                                ) : Icon(CupertinoIcons.photo_fill),
                              ),

                              SizedBox(height: 20,),

                            ],
                          );
                        },
                      );
                    }
                    return Container();
                  },
                ),


                StreamBuilder(
                  stream: firestore.doc("Stud Requests").collection("Pending Requests").where("pid", isEqualTo: widget.pid).where("studUid", isEqualTo: widget.studUid).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                    if (snapshot.hasError){
                      return Center(child: Text("Something went wrong"));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting){
                      return Center(child: CupertinoActivityIndicator());
                    }
                    if (snapshot.data!.docs.isEmpty){
                      return Container();
                    }

                    if (snapshot!=null && snapshot.data!=null){
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index){

                          var iName = snapshot.data!.docs[index]['iName'];
                          var iDesc = snapshot.data!.docs[index]['iDesc'];
                          var iType = snapshot.data!.docs[index]['iType'];
                          var iColor = snapshot.data!.docs[index]['iColor'];
                          var iLoc = snapshot.data!.docs[index]['iLoc'];
                          var iUniq = snapshot.data!.docs[index]['iUniq'];
                          var lostDate = snapshot.data!.docs[index]['lostDate'];
                          var lostTime = snapshot.data!.docs[index]['lostTime'];
                          var iImg = snapshot.data!.docs[index]['iImg'];

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 30,),
                              Text("Accept", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 40, height: 1.2),),
                              Text("This Item", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 40, height: 1.2),),

                              SizedBox(height: 30,),
                              Text("  Item Name *", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),),
                              SizedBox(height: 5,),
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 15,),
                                    Expanded(
                                      child: Text(iName),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 20,),
                              Text("  Description *", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),),
                              SizedBox(height: 5,),
                              Container(
                                height: 150,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 15,),
                                    Container(
                                      padding: EdgeInsets.only(top: 15),
                                      width: 300,
                                      child: Text(iDesc),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("  Type", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),),
                                      SizedBox(height: 5,),
                                      Container(
                                        height: 50,
                                        width: 150,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12.0),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            SizedBox(width: 15,),
                                            Expanded(
                                              child: Text(iType),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("   Color", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),),
                                      SizedBox(height: 5,),
                                      Container(
                                        height: 50,
                                        width: 150,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12.0),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            SizedBox(width: 15,),
                                            Expanded(
                                              child: Text(iColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              SizedBox(height: 20,),
                              Text("  Unique Identifier", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),),
                              SizedBox(height: 10,),
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 15,),
                                    Expanded(
                                      child: Text(iUniq),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 20,),
                              Text("  Lost Location", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),),
                              SizedBox(height: 10,),
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 15,),
                                    Expanded(
                                      child: Text(iLoc),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("  Lost Date", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),),
                                      SizedBox(height: 5,),
                                      Container(
                                        height: 50,
                                        width: 150,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12.0),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            SizedBox(width: 15,),
                                            Expanded(
                                              child: Text(lostDate),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("   Lost Time", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),),
                                      SizedBox(height: 5,),
                                      Container(
                                        height: 50,
                                        width: 150,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12.0),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            SizedBox(width: 15,),
                                            Expanded(
                                              child: Text(lostTime),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              SizedBox(height: 20,),
                              Text("  Image Upload", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),),
                              SizedBox(height: 10,),
                              Container(
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: (iImg!="") ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12), // Adjust the radius to match your container
                                  child: Image.network(iImg, fit: BoxFit.cover,),
                                ) : Icon(CupertinoIcons.photo_fill),
                              ),

                              SizedBox(height: 20,),

                            ],
                          );
                        },
                      );
                    }
                    return Container();
                  },
                ),

              ],
            ),
          ),
        )
    );
  }
}
