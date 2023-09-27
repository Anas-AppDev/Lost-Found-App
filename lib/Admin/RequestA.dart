import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lostfound/Admin/DetailsOfRequestA.dart';

class RequestA extends StatefulWidget {
  const RequestA({super.key});

  @override
  State<RequestA> createState() => _RequestAState();
}

class _RequestAState extends State<RequestA> {

  var firestore = FirebaseFirestore.instance.collection("LostFound");
  var auth = FirebaseAuth.instance;

  //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(
            color: Colors.black
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(height: 10,),
            Text("Claims Pending", style: TextStyle(fontSize: 25),),
            SizedBox(height: 14,),
            StreamBuilder(
              stream: firestore.doc("Stud Requests").collection("Claims Pending").where("adminUid", isEqualTo: auth.currentUser!.uid).snapshots(),
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
                      var studUid = snapshot.data!.docs[index]['studUid'];
                      var pid = snapshot.data!.docs[index]['pid'];
                      return InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailsOfRequestA(pid: pid, studUid: studUid,)));
                        },
                        child: Card(
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(snapshot.data!.docs[index]['iName']),
                                trailing: InkWell(
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
                                                Text("Are you sure you want to accept this request ?"),
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
                                                  firestore.doc("Stud Requests").collection("Claims Accepted").doc(pid+"_"+studUid).set(
                                                      {
                                                        "iName": snapshot.data!.docs[index]['iName'] ?? "",
                                                        "iDesc": snapshot.data!.docs[index]['iDesc'] ?? "",
                                                        "iType": snapshot.data!.docs[index]['iType'] ?? "",
                                                        "iColor": snapshot.data!.docs[index]['iColor'] ?? "",
                                                        "iLoc": snapshot.data!.docs[index]['iLoc'] ?? "",
                                                        "iUniq": snapshot.data!.docs[index]['iUniq'] ?? "",
                                                        "studUid": snapshot.data!.docs[index]['studUid'] ?? "",
                                                        "lostDate": snapshot.data!.docs[index]['lostDate'] ?? "",
                                                        "lostTime": snapshot.data!.docs[index]['lostTime'] ?? "",
                                                        "iImg": snapshot.data!.docs[index]['iImg'] ?? "",
                                                        "iReqDate": snapshot.data!.docs[index]['iReqDate'] ?? "",
                                                        "iAcceptDate": DateFormat('d MMMM y').format(DateTime.now()),
                                                        "pid": pid,
                                                        "adminUid": auth.currentUser!.uid,
                                                      }
                                                  );
                                                  firestore.doc("Inventory").collection("items").doc(pid).collection("Claims Pending").doc(studUid).delete();
                                                  firestore.doc("Stud Requests").collection("Claims Pending").doc(pid+"_"+studUid).delete();
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Yes"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Icon(CupertinoIcons.rectangle_split_3x1_fill)
                                ),
                              ),
                              StreamBuilder(
                                stream: firestore.doc('Users').collection('Students').where("studUid", isEqualTo: studUid).snapshots(),
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
                                        itemBuilder: (context, index) {
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: 10,),
                                              Text(snapshot.data!
                                                  .docs[index]['name']),
                                              Text(snapshot.data!
                                                  .docs[index]['uniUid']),
                                            ],

                                          );
                                        }
                                    );
                                  }

                                  // print(snapshot.data!.docs[0]['b']);
                                  return Container();
                                },
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

            SizedBox(height: 24,),
            Text("Pending Requests", style: TextStyle(fontSize: 25),),
            SizedBox(height: 14,),
            StreamBuilder(
              stream: firestore.doc("Stud Requests").collection("Pending Requests").snapshots(),
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
                      var studUid = snapshot.data!.docs[index]['studUid'];
                      var pid = snapshot.data!.docs[index].id;
                      return InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailsOfRequestA(pid: pid, studUid: studUid,)));
                        },
                        child: Card(
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(snapshot.data!.docs[index]['iName']),
                                trailing: InkWell(
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
                                                Text("Are you sure you want to accept this request ?"),
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
                                                  firestore.doc("Stud Requests").collection("Accepted Requests").doc(pid).set(
                                                    {
                                                      "iName": snapshot.data!.docs[index]['iName'] ?? "",
                                                      "iDesc": snapshot.data!.docs[index]['iDesc'] ?? "",
                                                      "iType": snapshot.data!.docs[index]['iType'] ?? "",
                                                      "iColor": snapshot.data!.docs[index]['iColor'] ?? "",
                                                      "iLoc": snapshot.data!.docs[index]['iLoc'] ?? "",
                                                      "iUniq": snapshot.data!.docs[index]['iUniq'] ?? "",
                                                      "studUid": snapshot.data!.docs[index]['studUid'] ?? "",
                                                      "lostDate": snapshot.data!.docs[index]['lostDate'] ?? "",
                                                      "lostTime": snapshot.data!.docs[index]['lostTime'] ?? "",
                                                      "iImg": snapshot.data!.docs[index]['iImg'] ?? "",
                                                      "iReqDate": snapshot.data!.docs[index]['iReqDate'] ?? "",
                                                      "iAcceptDate": DateFormat('d MMMM y').format(DateTime.now()),
                                                      "pid": pid,
                                                      "adminUid": auth.currentUser!.uid,
                                                    }
                                                  );
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
                                    child: Icon(CupertinoIcons.rectangle_split_3x1_fill)
                                ),
                              ),
                              StreamBuilder(
                                stream: firestore.doc('Users').collection('Students').where("studUid", isEqualTo: studUid).snapshots(),
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
                                        itemBuilder: (context, index) {
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: 10,),
                                              Text(snapshot.data!
                                                  .docs[index]['name']),
                                              Text(snapshot.data!
                                                  .docs[index]['uniUid']),
                                            ],

                                          );
                                        }
                                    );
                                  }

                                  // print(snapshot.data!.docs[0]['b']);
                                  return Container();
                                },
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
    );
  }
}
