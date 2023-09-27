import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lostfound/Student/DetailsOfRequestS.dart';

class RequestS extends StatefulWidget {


  String adminUid;

  RequestS({super.key, this.adminUid=""});

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(height: 12,),
            Text("Claims Pending", style: TextStyle(fontSize: 28),),
            SizedBox(height: 12,),

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
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailsOfRequestS(pid: pid,)));
                        },
                        child: Card(
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(snapshot.data!.docs[index]['iName']),
                                subtitle: Text(snapshot.data!.docs[index]['iReqDate']),
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
                                    child: Icon(CupertinoIcons.app_badge_fill)
                                ),
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

            SizedBox(height: 12,),
            Text("Claims Accepted", style: TextStyle(fontSize: 28),),
            SizedBox(height: 12,),

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
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailsOfRequestS(pid: pid,)));
                        },
                        child: Card(
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(snapshot.data!.docs[index]['iName']),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(snapshot.data!.docs[index]['iReqDate']),
                                    Text(snapshot.data!.docs[index]['adminUid']),
                                    StreamBuilder(
                                      stream: firestore.doc('Users').collection('Admins').where("adminUid", isEqualTo: adminUid).snapshots(),
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
                                                    SizedBox(height: 11,),
                                                    Text(snapshot.data!
                                                        .docs[index]['name']),
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
                                    child: Icon(CupertinoIcons.app_badge_fill)
                                ),
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

            SizedBox(height: 22,),
            Text("Pending Requests", style: TextStyle(fontSize: 28),),
            SizedBox(height: 12,),

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
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailsOfRequestS(pid: pid,)));
                        },
                        child: Card(
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(snapshot.data!.docs[index]['iName']),
                                subtitle: Text(snapshot.data!.docs[index]['iReqDate']),
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
                                    child: Icon(CupertinoIcons.app_badge_fill)
                                ),
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

            SizedBox(height: 22,),
            Text("Accepted Requests", style: TextStyle(fontSize: 28),),
            SizedBox(height: 12,),

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
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailsOfRequestS(pid: pid,)));
                        },
                        child: Card(
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(snapshot.data!.docs[index]['iName']),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(snapshot.data!.docs[index]['iReqDate']),
                                    SizedBox(height: 10,),
                                    StreamBuilder(
                                      stream: firestore.doc('Users').collection('Admins').where("adminUid", isEqualTo: snapshot.data!.docs[index]['adminUid']).snapshots(),
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
                                                    Text(snapshot.data!
                                                        .docs[index]['name']),
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
                                    child: Icon(CupertinoIcons.app_badge_fill)
                                ),
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
      )
    );
  }
}

