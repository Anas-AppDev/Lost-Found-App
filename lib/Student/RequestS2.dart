import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lostfound/Student/DetailOfRequestS2.dart';
import 'package:smooth_corner/smooth_corner.dart';

import '../Admin/AddItemA2.dart';

class RequestS2 extends StatefulWidget {

  String adminUid;

  RequestS2({super.key, this.adminUid=""});

  @override
  State<RequestS2> createState() => _RequestS2State();
}

class _RequestS2State extends State<RequestS2> {

  var searchCtrl = TextEditingController();
  var imgLink = "https://i.pinimg.com/564x/df/00/14/df001467ef17f34e505f54a7f60e4440.jpg";

  var firestore = FirebaseFirestore.instance.collection("LostFound");
  var auth = FirebaseAuth.instance;

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
                  StreamBuilder(
                    stream: firestore.doc("Stud Requests").collection("Claims Pending").where("studUid", isEqualTo: auth.currentUser!.uid).snapshots(),
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

                            var pid = snapshot.data!.docs[index]['pid'];
                            // var adminUid = snapshot.data!.docs[index]['adminUid'];
                            return InkWell(
                              onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailOfRequestS2(pid: pid))),
                              child: Container(
                                height: 80,
                                margin: EdgeInsets.only(bottom: 5),
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
                                                Text(snapshot.data!.docs[index]['iReqDate'], style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.normal, color: Colors.white, fontSize: 10, height: 1.5),),
                                                Container(
                                                    width: 250,
                                                    child: Text(snapshot.data!.docs[index]['iName'], style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18, height: 1.0),)),
                                              ],
                                            ),
                                            SizedBox(width: 5,),
                                            InkWell(
                                              onTap: (){
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context){
                                                    return CupertinoAlertDialog(
                                                      title: Text("Remove Request"),
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
                                                          Text("Are you sure you want to remove request ?"),
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
                                                            firestore.doc("Inventory").collection("items").doc(pid).collection("Claims Pending").doc(auth.currentUser!.uid).delete();
                                                            firestore.doc("Stud Requests").collection("Claims Pending").doc(pid+"_"+auth.currentUser!.uid).delete();
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
                            );
                          },
                        );
                      }
                      return Container();
                    },
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
                  StreamBuilder(
                    stream: firestore.doc("Stud Requests").collection("Pending Requests").where("studUid", isEqualTo: auth.currentUser!.uid).snapshots(),
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
                            // DocumentSnapshot document = snapshot.data!.docs[index];
                            // Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                            var pid = snapshot.data!.docs[index].id;
                            // var adminUid = snapshot.data!.docs[index]['adminUid'];
                            return InkWell(
                              onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailOfRequestS2(pid: pid))),
                              child: Container(
                                height: 80,
                                margin: EdgeInsets.only(bottom: 5),
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
                                                Text(snapshot.data!.docs[index]['iReqDate'], style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.normal, color: Colors.white, fontSize: 10, height: 1.5),),
                                                Container(
                                                    width: 250,
                                                    child: Text(snapshot.data!.docs[index]['iName'], style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18, height: 1.0),)),
                                              ],
                                            ),
                                            SizedBox(width: 5,),
                                            InkWell(
                                              onTap: (){
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context){
                                                    return CupertinoAlertDialog(
                                                      title: Text("Remove Request"),
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
                                                          Text("Are you sure you want to remove request ?"),
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
                                                            firestore.doc("Stud Requests").collection("Pending Requests").doc(pid).delete();
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
                            );
                          },
                        );
                      }
                      return Container();
                    },
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
                  StreamBuilder(
                    stream: firestore.doc("Stud Requests").collection("Claims Accepted").where("studUid", isEqualTo: auth.currentUser!.uid).snapshots(),
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

                            var pid = snapshot.data!.docs[index]['pid'];
                            var adminUid = snapshot.data!.docs[index]['adminUid'];
                            return InkWell(
                              onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailOfRequestS2(pid: pid))),
                              child: Container(
                                height: 80,
                                margin: EdgeInsets.only(bottom: 5),
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
                                                Text(snapshot.data!.docs[index]['iReqDate'], style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.normal, color: Colors.white, fontSize: 10, height: 1.5),),
                                                Container(
                                                    width: 250,
                                                    child: Text(snapshot.data!.docs[index]['iName'], style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18, height: 1.0),)),
                                              ],
                                            ),
                                            SizedBox(width: 5,),
                                            InkWell(
                                              onTap: (){
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context){
                                                    return CupertinoAlertDialog(
                                                      title: Text("Remove Request"),
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
                                                          Text("Are you sure you want to remove request ?"),
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
                                                            firestore.doc("Stud Requests").collection("Claims Accepted").doc(pid+"_"+auth.currentUser!.uid).delete();
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
                            );
                          },
                        );
                      }
                      return Container();
                    },
                  ),

                  //--------------------Accepted Requests-----------------------

                  SizedBox(height: 40,),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Accepted Requests", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.black, fontSize: 28, height: 1.2, letterSpacing: 1.2),),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 10,),
                  StreamBuilder(
                    stream: firestore.doc("Stud Requests").collection("Accepted Requests").where("studUid", isEqualTo: auth.currentUser!.uid).snapshots(),
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
                            // DocumentSnapshot document = snapshot.data!.docs[index];
                            // Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                            var pid = snapshot.data!.docs[index].id;
                            // var adminUid = snapshot.data!.docs[index]['adminUid'];
                            return InkWell(
                              onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailOfRequestS2(pid: pid))),
                              child: Container(
                                height: 80,
                                margin: EdgeInsets.only(bottom: 5),
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
                                                Text(snapshot.data!.docs[index]['iReqDate'], style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.normal, color: Colors.white, fontSize: 10, height: 1.5),),
                                                Container(
                                                    width: 250,
                                                    child: Text(snapshot.data!.docs[index]['iName'], style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18, height: 1.0),)),
                                              ],
                                            ),
                                            SizedBox(width: 5,),
                                            InkWell(
                                              onTap: (){
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context){
                                                    return CupertinoAlertDialog(
                                                      title: Text("Remove Request"),
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
                                                          Text("Are you sure you want to remove request ?"),
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
                                                            firestore.doc("Stud Requests").collection("Accepted Requests").doc(pid).delete();
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
          ),
        ],
      ),
    );
  }
}
