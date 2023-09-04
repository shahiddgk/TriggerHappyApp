
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/Widgets/toast_message.dart';
import 'package:flutter_quiz_app/Screens/utill/UserState.dart';
import 'package:flutter_quiz_app/network/http_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../Widgets/constants.dart';
import '../../../model/request_model/logout_user_request.dart';
import '../../AuthScreens/login_screen.dart';
import '../../AuthScreens/settings_screen.dart';
import '../../instruction_and_summaryPage.dart';

// ignore: must_be_immutable
class PopMenuButton extends StatefulWidget {
   PopMenuButton(this.isSummaryVisible,this.isSetting,this.userId,{Key? key}) : super(key: key);

  bool isSummaryVisible;
  bool isSetting;
  String userId;

  @override
  // ignore: library_private_types_in_public_api
  _PopMenuButtonState createState() => _PopMenuButtonState();
}

class _PopMenuButtonState extends State<PopMenuButton> {

  final GoogleSignIn googleSignIn = GoogleSignIn();

  _logout(String userID)  {
    //googleSignIn.disconnect();

    googleSignIn.signOut();
    setState(() {
      UserStatePrefrence().clearAnswerText();
    });
    // ignore: use_build_context_synchronously
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => const LoginPage()),
            (Route<dynamic> route) => false
    );
    
    HTTPManager().logoutUser(LogoutRequestModel(userId: userID)).then((value) {
      showToastMessage(context, "Logged out successfully", false);

    }).catchError((e) {
      showToastMessage(context, e.toString(), false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      // add icon, by default "3 dot" icon
      // icon: Icon(Icons.book)
        itemBuilder: (context){
          return [
            if(widget.isSummaryVisible)
            const PopupMenuItem<int>(
              value: 0,
              child: Text("Summary",style: TextStyle(fontSize: AppConstants.defaultFontSize),),
            ),

            // const PopupMenuItem<int>(
            //   value: 1,
            //   child: Text("Instruction"),
            // ),
            if(true)
            const PopupMenuItem<int>(
              value: 2,
              child: Text("Settings",style: TextStyle(fontSize: AppConstants.defaultFontSize),),
            ),
            const PopupMenuItem<int>(
              value: 3,
              child: Text("Logout",style: TextStyle(fontSize: AppConstants.defaultFontSize),),
            ),
          ];
        },
        onSelected:(value){
          if(value == 0){
            // print("Summary menu is selected.");
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SummaryAndInstructions(0)));
          }else if(value == 1){
            // print("Instruction menu is selected.");
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SummaryAndInstructions(1)));
          }else if(value == 2){
            // print("Setting menu is selected.");
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Settings("")));
          }else if(value == 3){
            // print("Logout menu is selected.");
            _logout(widget.userId);
          }
        }
    );
  }
}
