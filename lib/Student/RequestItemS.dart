import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class RequestItemS extends StatefulWidget {
  const RequestItemS({super.key});

  @override
  State<RequestItemS> createState() => _RequestItemSState();
}

class _RequestItemSState extends State<RequestItemS> {

  var auth = FirebaseAuth.instance;
  var firestore = FirebaseFirestore.instance.collection("LostFound");

  var formKey = GlobalKey<FormState>();

  var iNameCtrl = TextEditingController();
  var iDescCtrl = TextEditingController();
  var iUniqueCtrl = TextEditingController();

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

  String? typeListSelected = null;
  var typesList = [
    'gadget',
    'furniture',
    'clothes',
    'keys',
    'jewelery',
  ];

  String? locListSelected = null;
  var locList = [
    'D1',
    'B3',
    'B1',
    'B4',
    'B6',
  ];

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
  void initState() {
    super.initState();
  }

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
            SizedBox(height: 25,),
            Text("Request a Item", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),),
            SizedBox(height: 25,),
            Form(child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: iNameCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: "Enter Item Name",
                  ),
                  maxLines: 1,
                  validator: (value){
                    if (value!.isEmpty){
                      return "Item Name is required";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 5,),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: iDescCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: "Enter Description",
                  ),
                  maxLines: 5,
                  maxLength: 250,
                  validator: (value){
                    if (value!.isEmpty){
                      return "Item Description is required";
                    }
                    return null;
                  },
                ),
                DropdownButton(
                  value: typeListSelected,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: typesList.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      typeListSelected = newValue!;
                    });
                  },
                ),
                DropdownButton(
                  value: colorListSelected,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: colorList.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      colorListSelected = newValue!;
                    });
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: iUniqueCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: "Enter Uniqueness",
                  ),
                  maxLines: 1,
                ),
                DropdownButton(
                  value: locListSelected,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: locList.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      locListSelected = newValue!;
                    });
                  },
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
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
                      child: Text("Pick date"),
                    ),
                    Text(lostDate != null ? DateFormat('d MMMM y').format(lostDate!) : ''),
                  ],
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
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
                      child: Text("Pick time"),
                    ),
                    Text(lostTime != null ? DateFormat.jm().format(lostTime!) : ''),
                  ],
                ),
                SizedBox(height: 20,),
                InkWell(
                  onTap: (){
                    getImage(source: ImageSource.gallery);
                  },
                  child: Container(
                    height: 200,
                    width: 420,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.black12,
                      border: Border.all(width: 2, color: Colors.black),
                    ),
                    child: (imgFile != null) ? ClipRRect(
                      borderRadius: BorderRadius.circular(12), // Adjust the radius to match your container
                      child: Image.file(
                        imgFile!.absolute,
                        fit: BoxFit.cover, // Adjust the fit property here
                      ),
                    ) : Icon(CupertinoIcons.photo_fill),
                  ),
                ),
              ],
            ),
              key: formKey,),

            SizedBox(height: 40,),
            ElevatedButton(onPressed: () async{
              if (formKey.currentState!.validate()){


                imgFile!=null ? await uploadImageToFirebaseStorage(imgFile!) : print("img file : "+ imgFile.toString());

                var pid = DateTime.now().microsecondsSinceEpoch.toString();

                await firestore.doc("Requests").collection("Pending").doc(pid).set(
                    {

                      "iName": iNameCtrl.text,
                      "iDesc": iDescCtrl.text,
                      "iType": typeListSelected ?? "",
                      "iColor": colorListSelected ?? "",
                      "iLoc": locListSelected ?? "",
                      "iUniq": iUniqueCtrl.text ?? "",
                      "uid": auth.currentUser!.uid,
                      "lostDate": lostDate != null ? DateFormat('d MMMM y').format(lostDate!) : '',
                      "lostTime": lostTime != null ? DateFormat.jm().format(lostTime!) : '',
                      "iImg": downloadUrl ?? "",
                      "iReqDate": DateFormat('d MMMM y').format(DateTime.now()),
                      "pid": pid,

                    }
                );
              }

            }, child: Text("Submit")),
          ],
        ),
      ),
    );
  }
}
