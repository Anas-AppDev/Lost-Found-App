import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailsOfRequestA extends StatefulWidget {

  String pid, studUid;
  DetailsOfRequestA({super.key, required this.pid, required this.studUid});

  @override
  State<DetailsOfRequestA> createState() => _DetailsOfRequestAState();
}

class _DetailsOfRequestAState extends State<DetailsOfRequestA> {

  var firestore = FirebaseFirestore.instance.collection("LostFound");
  var auth = FirebaseAuth.instance;


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
                        children: [
                          SizedBox(height: 20,),
                          Container(
                            height: 40,
                            width: 350,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(iName),
                          ),
                          Container(
                            height: 40,
                            width: 350,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(iDesc),
                          ),
                          Container(
                            height: 40,
                            width: 350,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(iType),
                          ),
                          Container(
                            height: 40,
                            width: 350,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(iColor),
                          ),
                          Container(
                            height: 40,
                            width: 350,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(iLoc),
                          ),
                          Container(
                            height: 40,
                            width: 350,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(iUniq),
                          ),
                          Container(
                            height: 40,
                            width: 350,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(lostDate),
                          ),
                          Container(
                            height: 40,
                            width: 350,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(lostTime),
                          ),
                          Container(
                            height: 300,
                            width: 350,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: (iImg!="") ? ClipRRect(
                              borderRadius: BorderRadius.circular(12), // Adjust the radius to match your container
                              child: Image.network(iImg, fit: BoxFit.cover,),
                            ) : Icon(CupertinoIcons.photo_fill),
                          ),
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
                        children: [
                          SizedBox(height: 20,),
                          Container(
                            height: 40,
                            width: 350,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(iName),
                          ),
                          Container(
                            height: 40,
                            width: 350,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(iDesc),
                          ),
                          Container(
                            height: 40,
                            width: 350,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(iType),
                          ),
                          Container(
                            height: 40,
                            width: 350,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(iColor),
                          ),
                          Container(
                            height: 40,
                            width: 350,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(iLoc),
                          ),
                          Container(
                            height: 40,
                            width: 350,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(iUniq),
                          ),
                          Container(
                            height: 40,
                            width: 350,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(lostDate),
                          ),
                          Container(
                            height: 40,
                            width: 350,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(lostTime),
                          ),
                          Container(
                            height: 300,
                            width: 350,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: (iImg!="") ? ClipRRect(
                              borderRadius: BorderRadius.circular(12), // Adjust the radius to match your container
                              child: Image.network(iImg, fit: BoxFit.cover,),
                            ) : Icon(CupertinoIcons.photo_fill),
                          ),
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
    );
  }
}
