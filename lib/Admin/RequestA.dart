import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
          children: [
            SizedBox(height: 20,),
            Text("Pending Requests"),
            StreamBuilder(
              // stream: firestore.doc("Requests").collection("Pending").doc(auth.currentUser!.uid).collection("items").snapshots(),
              stream: firestore.doc("Requests").collection("Pending").snapshots(),
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
                      var studUid = snapshot.data!.docs[index]['uid'];
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
                                  Text(snapshot.data!.docs[index]['lostDate']),
                                  Text(snapshot.data!.docs[index]['lostTime']),
                                ],
                              ),
                            ),
                            StreamBuilder(
                              stream: firestore.doc('Users').collection('Students').doc(studUid).collection("profile").snapshots(),
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
                                                .docs[index]['uid']),
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

          ],
        ),
      ),
    );
  }
}
