import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lostfound/Admin/AddItemA.dart';
import 'package:lostfound/Admin/ClaimA.dart';
import 'package:lostfound/Authentication/Login.dart';
import 'RequestA.dart';

class HomeA extends StatefulWidget {
  const HomeA({super.key});

  @override
  State<HomeA> createState() => _HomeAState();
}

class _HomeAState extends State<HomeA> {

  var real = FirebaseDatabase.instance.ref("LostFound");
  var firestore = FirebaseFirestore.instance.collection("LostFound");
  var auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> AddItemPage()));
            }, child: Icon(CupertinoIcons.add)),
            Text("Space for teacher specific inventory"),
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
                        onTap: (){
                          print(pid);
                          print(iName);
                          print(iType);
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> ClaimA(pid: pid, iName: iName, iType: iType,)));
                        },
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
                        child: Card(
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(iName),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(iType),
                                    Text(snapshot.data!.docs[index]['iLoc']),
                                    Text(snapshot.data!.docs[index]['foundDate']),
                                    Text(snapshot.data!.docs[index]['adminUid']),
                                  ],
                                ),
                              ),
                              StreamBuilder(
                                stream: firestore.doc('Users').collection('Admins').where("adminUid", isEqualTo: auth.currentUser!.uid).snapshots(),
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

                                        print(snapshot.data!.docs[index]['name']);
                                        print(snapshot.data!.docs[index]['block']);
                                        print(snapshot.data!.docs[index]['cabin']);
                                        print(snapshot.data!.docs[index]['uniEid']);

                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(snapshot.data!.docs[index]['name']),
                                            Text(snapshot.data!
                                                .docs[index]['block']),
                                            Text(snapshot.data!
                                                .docs[index]['cabin']),
                                            Text(snapshot.data!
                                                .docs[index]['uniEid']),
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

                // print(snapshot.data!.docs[0]['b']);
                return Container();
              },
            ),





            Row(
              children: [
                ElevatedButton(onPressed: (){
                  auth.signOut();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Login()));
                }, child: Text("Log out")),
                SizedBox(width: 20,),
                ElevatedButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> RequestA()));
                }, child: Text("Requests")),
              ],
            ),
          ],
        ),
      )
    );
  }
}
