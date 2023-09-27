import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddItemPage extends StatefulWidget {
  const AddItemPage({super.key});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {


  late String currDate;
  var real = FirebaseDatabase.instance.ref("LostFound");
  var firestore = FirebaseFirestore.instance.collection("LostFound");
  var auth = FirebaseAuth.instance;

  var formKey = GlobalKey<FormState>();

  var iCtrl = TextEditingController();

  late String pid;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(
            color: Colors.black
        ),
        automaticallyImplyLeading: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20,),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: iCtrl,
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

              ],
            ),
            key: formKey,),

            ElevatedButton(onPressed: (){
              if (formKey.currentState!.validate()){
                pid = DateTime.now().microsecondsSinceEpoch.toString();
                currDate = DateFormat('d MMMM y').format(DateTime.now());
                
                // firestore.doc("Users").collection("Admins").doc(auth.currentUser!.uid).collection("items").doc(pid).set(
                //   {
                //
                //       "iName": iCtrl.text,
                //       "iType": typeListSelected,
                //       "iLoc": locListSelected,
                //       "adminUid": auth.currentUser!.uid,
                //       "foundDate": currDate,
                //
                //   }
                // );

                firestore.doc("Inventory").collection("items").doc(pid).set(
                  {
                    "iName": iCtrl.text,
                    "iType": typeListSelected,
                    "iLoc": locListSelected,
                    "adminUid": auth.currentUser!.uid,
                    "foundDate": currDate,
                  }
                );

              }
            }, child: Text("Add Item")),
          ],
        ),
      ),
    );
  }

}


