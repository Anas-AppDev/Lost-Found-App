import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lostfound/main.dart';

class ClaimS2 extends StatefulWidget {

  String iName, iType, adminUid, pid;
  ClaimS2({super.key, required this.iName, required this.iType, required this.adminUid, required this.pid,});
  

  @override
  State<ClaimS2> createState() => _ClaimS2State();
}

class _ClaimS2State extends State<ClaimS2> {

  var auth = FirebaseAuth.instance;
  var firestore = FirebaseFirestore.instance.collection("LostFound");

  var formKey = GlobalKey<FormState>();

  var iDescCtrl = TextEditingController();
  var iUniqueCtrl = TextEditingController();
  var iLocCtrl = TextEditingController();

  late DateTime? lostDate =  null;
  late DateTime? lostTime =  null;

  String? colorListSelected = null;
  var colorList = [
    'black',
    'grey',
    'blue',
    'red',
    'orange',
    'pink',
    'purple',
    'yellow',
    'green',
  ];
  var iColorCtrl = TextEditingController();

  String? downloadUrl;
  File? imgFile;
  void getImage({required ImageSource source}) async{
    var pickedImg = await ImagePicker().pickImage(source: source);

    if (pickedImg != null){
      setState(() {
        imgFile = File(pickedImg.path);
        // print("PickedImg : " + pickedImg.path);
      });

    }
    else{
      print("Pick an image");
    }
  }

  Future<void> uploadImageToFirebaseStorage(File file) async {
    try {
      var fstorage = FirebaseStorage.instance;
      Reference storageReference = fstorage.ref().child('LostFound/${auth.currentUser!.uid}/${DateTime.now()}.jpg');

      UploadTask uploadTask = storageReference.putFile(file);

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

      downloadUrl = await taskSnapshot.ref.getDownloadURL();
      print("Image uploaded. Download URL: $downloadUrl");

    } catch (e) {
      print("Error uploading image: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent, // Make the AppBar background transparent
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
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30,),
                  Text("Claim", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 40, height: 1.2),),
                  Text("Your Item", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 40, height: 1.2),),

                  SizedBox(height: 30,),
                  Text("  Item Name *", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),),
                  SizedBox(height: 5,),
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
                          child: Text(widget.iName),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20,),
                  Text("  Description *", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),),
                  SizedBox(height: 5,),
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 320,
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            controller: iDescCtrl,
                            decoration: InputDecoration(
                              prefixText: "   ",
                              hintText: "Description (150 words)...",
                              hintStyle: TextStyle(
                                fontFamily: "Poppins",
                                color: Color(0xff468DFF), // Change this color to your desired hint text color
                              ),
                              border: InputBorder.none,
                              counterText: "",
                            ),
                            maxLines: 6,
                            maxLength: 150,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Description is required";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("  Type", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),),
                          SizedBox(height: 5,),
                          Container(
                            height: 50,
                            width: 150,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(width: 15,),
                                Expanded(
                                  child: Text(widget.iType),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("   Color", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),),
                          SizedBox(height: 5,),
                          Container(
                            height: 50,
                            width: 150,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: 15,),
                                AutoDropdown(ctrl: iColorCtrl, list: colorList, listSelected: colorListSelected, widths: 135, hint: "Colors",)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 20,),
                  Text("  Unique Identifier", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),),
                  SizedBox(height: 10,),
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
                            controller: iUniqueCtrl,
                            decoration: InputDecoration(
                              prefixText: "   ",
                              hintText: "Unique Identifier",
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

                  SizedBox(height: 20,),
                  Text("  Lost Location", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),),
                  SizedBox(height: 10,),
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
                              hintText: "Lost Location",
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

                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("  Lost Date", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),),
                          SizedBox(height: 10,),
                          InkWell(
                            onTap: (){
                              showCupertinoModalPopup(context: context, builder: (context) {
                                return Container(
                                  height: MediaQuery.of(context).size.height * 0.4,
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          if (lostDate == null) {
                                            setState(() {
                                              lostDate = DateTime.now();
                                            });
                                          }
                                        },
                                        child: Text("Done"),
                                      ),
                                      Expanded(
                                        child: CupertinoDatePicker(
                                          initialDateTime: lostDate ?? DateTime.now(),
                                          mode: CupertinoDatePickerMode.date,
                                          minimumDate: DateTime(2000),
                                          maximumDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59),
                                          use24hFormat: false,
                                          onDateTimeChanged: (date) {
                                            setState(() {
                                              lostDate = date;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              });
                            },
                            child: Container(
                              height: 50,
                              width: 170,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(width: 15,),
                                  Container(
                                    width: 115,
                                    child: lostDate != null ? Text(DateFormat('d MMMM y').format(lostDate!)) : Text("Lost Date", style: TextStyle (fontFamily: "Poppins", color: Color(0xff468DFF), fontSize: 16,),),
                                  ),
                                  Icon(Icons.keyboard_arrow_down, color: Color(0xff468DFF), size: 30,),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("  Lost Time", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),),
                          SizedBox(height: 10,),
                          InkWell(
                            onTap: (){
                              showCupertinoModalPopup(context: context, builder: (context) {
                                return Container(
                                  height: MediaQuery.of(context).size.height * 0.4,
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          // If the user didn't make any changes, set to the current date and time
                                          if (lostTime == null) {
                                            setState(() {
                                              lostTime = DateTime.now();
                                            });
                                          }
                                        },
                                        child: Text("Done"),
                                      ),
                                      Expanded(
                                        child: CupertinoDatePicker(
                                          initialDateTime: lostTime ?? DateTime.now(),
                                          mode: CupertinoDatePickerMode.time,
                                          use24hFormat: false,
                                          onDateTimeChanged: (time) {
                                            setState(() {
                                              lostTime = time;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              });
                            },
                            child: Container(
                              height: 50,
                              width: 130,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(width: 15,),
                                  Container(
                                    width: 75,
                                    child: lostTime != null ? Text(DateFormat.jm().format(lostTime!)) : Text("Lost Time", style: TextStyle (fontFamily: "Poppins", color: Color(0xff468DFF), fontSize: 16,),),
                                  ),
                                  Icon(Icons.keyboard_arrow_down, color: Color(0xff468DFF), size: 30,),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 20,),
                  Text("  Image Upload", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),),
                  SizedBox(height: 10,),
                  InkWell(
                    onTap: (){
                      getImage(source: ImageSource.gallery);
                    },
                    child: Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: (imgFile != null) ? ClipRRect(
                          borderRadius: BorderRadius.circular(12), // Adjust the radius to match your container
                          child: Image.file(
                            imgFile!.absolute,
                            fit: BoxFit.cover, // Adjust the fit property here
                          ),
                        ) : Icon(CupertinoIcons.game_controller_solid, size: 50,),
                    ),
                  ),

                  SizedBox(height: 30,),
                  InkWell(
                    onTap: () async{
                      if (formKey.currentState!.validate()){

                        imgFile!=null ? await uploadImageToFirebaseStorage(imgFile!) : print("img file : "+ imgFile.toString());

                      await firestore.doc("Inventory").collection("items").doc(widget.pid).collection("Claims Pending").doc(auth.currentUser!.uid).set(
                      {

                      "iName": widget.iName,
                      "iDesc": iDescCtrl.text,
                      "iType": widget.iType,
                      "iColor": iColorCtrl.text ?? "",
                      "iLoc": iLocCtrl.text ?? "",
                      "iUniq": iUniqueCtrl.text ?? "",
                      "studUid": auth.currentUser!.uid,
                      "lostDate": lostDate != null ? DateFormat('d MMMM y').format(lostDate!) : '',
                      "lostTime": lostTime != null ? DateFormat.jm().format(lostTime!) : '',
                      "iImg": downloadUrl ?? "",
                      "iReqDate": DateFormat('d MMMM y').format(DateTime.now()),
                      "pid": widget.pid,
                      "adminUid": widget.adminUid ?? "",

                      }
                      );

                      await firestore.doc("Stud Requests").collection("Claims Pending").doc(widget.pid+"_"+auth.currentUser!.uid).set(
                      {

                      "iName": widget.iName,
                      "iDesc": iDescCtrl.text,
                      "iType": widget.iType,
                      "iColor": iColorCtrl.text ?? "",
                      "iLoc": iLocCtrl.text ?? "",
                      "iUniq": iUniqueCtrl.text ?? "",
                      "studUid": auth.currentUser!.uid,
                      "lostDate": lostDate != null ? DateFormat('d MMMM y').format(lostDate!) : '',
                      "lostTime": lostTime != null ? DateFormat.jm().format(lostTime!) : '',
                      "iImg": downloadUrl ?? "",
                      "iReqDate": DateFormat('d MMMM y').format(DateTime.now()),
                      "pid": widget.pid,
                      "adminUid": widget.adminUid ?? "",

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
                  SizedBox(height: 20,),

                ],
              ),
            ),
          ),
        )
    );
  }
}
