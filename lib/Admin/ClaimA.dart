import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lostfound/Admin/ClaimA2.dart';

class ClaimA extends StatefulWidget {

  String pid, iName, iType;
  ClaimA({super.key, required this.pid, required this.iName, required this.iType});

  @override
  State<ClaimA> createState() => _ClaimAState();
}

class _ClaimAState extends State<ClaimA> {

  var auth = FirebaseAuth.instance;
  var firestore = FirebaseFirestore.instance.collection("LostFound");


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
              stream: firestore.doc("Users").collection("Admins/${auth.currentUser!.uid}/items/${widget.pid}/Claims").snapshots(),
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
                      var studUid = snapshot.data!.docs[index]["uid"];
                      return InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> ClaimA2(pid: widget.pid, studUid: studUid, iName: widget.iName, iType: widget.iType,)));
                        },
                        child: Card(
                          child: Column(
                            children: [
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
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (context, index) {
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(snapshot.data!
                                                      .docs[index]['name']),
                                                  SizedBox(width: 10,),
                                                  Text(snapshot.data!
                                                      .docs[index]['uid']),
                                                ],
                                              ),
                                            ],

                                          );
                                        }
                                    );
                                  }
                                  return Container();
                                },
                              ),
                              ListTile(
                                title: Text(snapshot.data!.docs[index]['iDesc']),
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
