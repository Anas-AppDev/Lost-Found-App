import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lostfound/main.dart';

class AddItemA2 extends StatefulWidget {
  const AddItemA2({super.key});

  @override
  State<AddItemA2> createState() => _AddItemA2State();
}

class _AddItemA2State extends State<AddItemA2> {

  late String currDate;
  var real = FirebaseDatabase.instance.ref("LostFound");
  var firestore = FirebaseFirestore.instance.collection("LostFound");
  var auth = FirebaseAuth.instance;

  var formKey = GlobalKey<FormState>();

  var iNameCtrl = TextEditingController();
  var iTypeCtrl = TextEditingController();
  var iLocCtrl = TextEditingController();

  late String pid;

  String? typeListSelected = null;
  var typesList = [
    'gadget',
    'furniture',
    'clothes',
    'keys',
    'jewelery',
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor:
        Colors.transparent, // Make the AppBar background transparent
        leading: BackButton(color: Color(0xffffffff)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff0B69FF), Color(0xff418AFF)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xff0B69FF),
                Color(0xff418AFF),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30,),
              Text("Add", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 40, height: 1.2),),
              Text("Your Item", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 40, height: 1.2),),



              Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 40,),
                      Text("  Item Name *", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),),
                      SizedBox(height: 8,),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                controller: iNameCtrl,
                                decoration: InputDecoration(
                                  prefixText: "   ",
                                  hintText: "Item Name",
                                  hintStyle: TextStyle(
                                    fontFamily: "Poppins",
                                    color: Color(0xff468DFF), // Change this color to your desired hint text color
                                  ),
                                  border: InputBorder.none,
                                ),
                                maxLines: 1,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Item Name required";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 30,),
                      Text("  Type", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),),
                      SizedBox(height: 8,),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: 15,),
                            Expanded(
                              child: AutoDropdown(ctrl: iTypeCtrl, list: typesList, listSelected: typeListSelected, widths: 300, hint: "Type"),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 30,),
                      Text("  Found Location", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),),
                      SizedBox(height: 8,),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                controller: iLocCtrl,
                                decoration: InputDecoration(
                                  prefixText: "   ",
                                  hintText: "Found Location",
                                  hintStyle: TextStyle(
                                    fontFamily: "Poppins",
                                    color: Color(0xff468DFF), // Change this color to your desired hint text color
                                  ),
                                  border: InputBorder.none,
                                ),
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ],
                  ),
                key: formKey,
              ),









              SizedBox(height: 161,),
              InkWell(
                onTap: () {
                  if (formKey.currentState!.validate()){
                    pid = DateTime.now().microsecondsSinceEpoch.toString();
                    currDate = DateFormat('d MMMM y').format(DateTime.now());

                    firestore.doc("Inventory").collection("items").doc(pid).set(
                        {
                          "iName": iNameCtrl.text,
                          "iType": typeListSelected ?? "Miscellaneous",
                          "iLoc": iLocCtrl.text ?? "",
                          "adminUid": auth.currentUser!.uid,
                          "foundDate": currDate,
                        }
                    );

                  }
                },
                child: Center(
                  child: Container(
                    height: 60,
                    width: 240,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(21)),
                    child: Center(
                      child: Text(
                        'Send',
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30,),

            ],
          ),
        ),
      )
    );
  }
}
