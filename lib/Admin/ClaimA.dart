import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
              stream: firestore.doc("Inventory").collection("items").doc(widget.pid).collection("Claims Pending").snapshots(),
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
                      var iName = snapshot.data!.docs[index]['iName'];
                      var iDesc = snapshot.data!.docs[index]['iDesc'];
                      var iType = snapshot.data!.docs[index]['iType'];
                      var iColor = snapshot.data!.docs[index]['iColor'];
                      var iLoc = snapshot.data!.docs[index]['iLoc'];
                      var iUniq = snapshot.data!.docs[index]['iUniq'];
                      var studUid = snapshot.data!.docs[index]['studUid'];
                      var lostDate = snapshot.data!.docs[index]['lostDate'];
                      var lostTime = snapshot.data!.docs[index]['lostTime'];
                      var iImg = snapshot.data!.docs[index]['iImg'];
                      var iReqDate = snapshot.data!.docs[index]['iReqDate'];
                      return InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> ClaimA2(pid: widget.pid, studUid: studUid, iName: widget.iName, iType: widget.iType,)));
                        },
                        child: Card(
                          child: Column(
                            children: [
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
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (context, index) {
                                          return Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(height: 10,),
                                                  Text(snapshot.data!
                                                      .docs[index]['name']),
                                                  SizedBox(width: 10,),
                                                  Text(snapshot.data!
                                                      .docs[index]['uniUid']),
                                                ],

                                              ),

                                              SizedBox(width: 188,),
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
                                                                print("object " + studUid);
                                                                firestore.doc("Stud Requests").collection("Claims Accepted").doc(widget.pid+"_"+studUid).set(
                                                                    {
                                                                      "iName": iName ?? "",
                                                                      "iDesc": iDesc ?? "",
                                                                      "iType": iType ?? "",
                                                                      "iColor": iColor ?? "",
                                                                      "iLoc": iLoc ?? "",
                                                                      "iUniq": iUniq ?? "",
                                                                      "studUid": studUid ?? "",
                                                                      "lostDate": lostDate ?? "",
                                                                      "lostTime": lostTime ?? "",
                                                                      "iImg": iImg ?? "",
                                                                      "iReqDate": iReqDate ?? "",
                                                                      "iAcceptDate": DateFormat('d MMMM y').format(DateTime.now()),
                                                                      "pid": widget.pid,
                                                                      "adminUid": auth.currentUser!.uid,
                                                                    }
                                                                );
                                                                firestore.doc("Inventory").collection("items").doc(widget.pid).collection("Claims Pending").doc(studUid).delete();
                                                                firestore.doc("Stud Requests").collection("Claims Pending").doc(widget.pid+"_"+studUid).delete();
                                                                Navigator.pop(context);
                                                              },
                                                              child: Text("Yes"),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Icon(CupertinoIcons.rectangle_split_3x1_fill)),
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
