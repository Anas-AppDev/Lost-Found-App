import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lostfound/Student/RequestItemS.dart';
import 'package:lostfound/Student/RequestS.dart';
import '../Authentication/Login.dart';

class HomeS extends StatefulWidget {
  const HomeS({super.key});

  @override
  State<HomeS> createState() => _HomeSState();
}

class _HomeSState extends State<HomeS> {

  var auth = FirebaseAuth.instance;
  var firestore = FirebaseFirestore.instance.collection("LostFound");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              StreamBuilder(
                stream: firestore.doc("Inventory").collection("items").snapshots(),
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
                        var adminUid = snapshot.data!.docs[index]['uid'];
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
                                    Text(adminUid),
                                  ],
                                ),
                              ),
                              StreamBuilder(
                                stream: firestore.doc('Users').collection('Admins').doc(adminUid).collection("profile").snapshots(),
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
                  return Container();
                },
              ),

              SizedBox(height: 40,),
              ElevatedButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> RequestItemS()));
              }, child: Icon(Icons.add)),
              SizedBox(height: 40,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(onPressed: (){
                    auth.signOut();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Login()));
                  }, child: Text("Log out")),
                  SizedBox(width: 20,),
                  ElevatedButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> RequestS()));
                  }, child: Text("Requests")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
