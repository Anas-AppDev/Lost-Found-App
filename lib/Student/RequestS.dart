import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RequestS extends StatefulWidget {
  const RequestS({super.key});

  @override
  State<RequestS> createState() => _RequestSState();
}

class _RequestSState extends State<RequestS> {
  
  var firestore = FirebaseFirestore.instance.collection("LostFound");
  var auth = FirebaseAuth.instance;
  // Query query = firestore.doc("Requests").collection("Pending").where("uid", isEqualTo: auth.currentUser!.uid);
  
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

            StreamBuilder(
              // stream: firestore.doc("Requests").collection("Pending").doc(auth.currentUser!.uid).collection("items").snapshots(),
              stream: firestore.doc("Requests").collection("Pending").where("uid", isEqualTo: auth.currentUser!.uid).snapshots(),
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
      )
    );
  }
}
