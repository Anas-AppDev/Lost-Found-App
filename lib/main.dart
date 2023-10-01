import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:lostfound/Admin/AddItemA.dart';
import 'package:lostfound/Admin/ClaimA1.dart';
import 'package:lostfound/Admin/HomeA.dart';
import 'package:lostfound/Admin/HomeA2.dart';
import 'package:lostfound/Admin/NavDrawerA2.dart';
import 'package:lostfound/Admin/RequestA2.dart';
import 'package:lostfound/Authentication/Login2.dart';
import 'package:lostfound/Authentication/SignupS.dart';
import 'package:lostfound/Authentication/SignupS2.dart';
import 'package:lostfound/Authentication/SplashPage.dart';
import 'package:lostfound/Student/ClaimS2.dart';
import 'package:lostfound/Student/HomeS2.dart';
import 'package:lostfound/Student/NavDrawerS2.dart';
import 'package:lostfound/Student/RequestS2.dart';
import 'package:smooth_corner/smooth_corner.dart';

import 'Admin/AddItemA2.dart';
import 'Admin/HomeA2.dart';
import 'Authentication/SignupA2.dart';
import 'Student/HomeS.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    home: NavDrawerA2(),
  ));
}

class AutoDropdown extends StatefulWidget {

  TextEditingController ctrl;
  List list;
  String? listSelected;
  String? hint;
  double widths;

  AutoDropdown({required this.ctrl, required this.list, required this.listSelected, required this.widths, required this.hint});

  @override
  State<AutoDropdown> createState() => _AutoDropdownState();
}

class _AutoDropdownState extends State<AutoDropdown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.widths, // Adjust the width as needed
      child: TypeAheadFormField(
        hideSuggestionsOnKeyboardHide: true,
        textFieldConfiguration: TextFieldConfiguration(
          controller: widget.ctrl,
          style: TextStyle(color: Colors.black, fontSize: 16),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(
              fontFamily: "Poppins",
              color: Color(0xff468DFF), // Change this color to your desired hint text color
            ),
            border: InputBorder.none,
            suffixIcon: Icon(Icons.keyboard_arrow_down, color: Color(0xff468DFF), size: 30,),
          ),
        ),
        suggestionsCallback: (pattern) {
          return widget.list.where((color) =>
              color.toLowerCase().contains(pattern.toLowerCase()));
        },
        itemBuilder: (context, suggestion) {
          return Column(
            children: [
              ListTile(
                title: Text(suggestion),
              ),
              Container(
                height: 1,
                width: widget.widths-10,
                color: Colors.grey, // Set the color of the divider line
              ),
            ],
          );
        },
        onSuggestionSelected: (suggestion) {
          setState(() {
            widget.listSelected = suggestion;
            widget.ctrl.text = suggestion; // Update the text controller
          });
        },
      ),
    );
  }
}



