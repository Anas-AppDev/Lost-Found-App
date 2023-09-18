import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lostfound/Admin/AddItemA.dart';
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
              stream: firestore.doc('Users').collection('Admins').doc(auth.currentUser!.uid).collection("items").snapshots(),
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
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index){
                      return Card(
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(snapshot.data!.docs[index]['iName']),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(snapshot.data!.docs[index]['iType']),
                                  Text(snapshot.data!.docs[index]['iLoc']),
                                  Text(snapshot.data!.docs[index]['date']),
                                  Text(snapshot.data!.docs[index]['uid']),
                                ],
                              ),
                            ),
                            StreamBuilder(
                              stream: firestore.doc('Users').collection('Admins').doc(auth.currentUser!.uid).collection("profile").snapshots(),
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
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(snapshot.data!
                                              .docs[index]['name']),
                                          Text(snapshot.data!
                                              .docs[index]['block']),
                                          Text(snapshot.data!
                                              .docs[index]['cabin']),
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
