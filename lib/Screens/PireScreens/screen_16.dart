// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/screen_3.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/widgets/AppBar.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/Widgets/logo_widget_for_all_screens.dart';
import 'package:flutter_quiz_app/Widgets/option_mcq_widget.dart';
import 'package:flutter_quiz_app/Widgets/question_text_widget.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../AuthScreens/login_screen.dart';
import '../utill/userConstants.dart';

class Screen16 extends StatefulWidget {
  Screen16(this.number,{Key? key}) : super(key: key);

  String number;

  @override
  _Screen16State createState() => _Screen16State();
}

class _Screen16State extends State<Screen16> {

  String name = "";
  String id = "";
  bool _isUserDataLoading = true;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  void initState() {
    _getUserData();
    // TODO: implement initState
    super.initState();
  }

  String email = "";
  String timeZone = "";
  String userType = "";

  _getUserData() async {
    setState(() {
      _isUserDataLoading = true;
    });
    print("Data getting called");
    SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();

    name = _sharedPreferences.getString(UserConstants().userName)!;
    id = _sharedPreferences.getString(UserConstants().userId)!;
    email = _sharedPreferences.getString(UserConstants().userEmail)!;
    timeZone = _sharedPreferences.getString(UserConstants().timeZone)!;
    userType = _sharedPreferences.getString(UserConstants().userType)!;
    setState(() {
      _isUserDataLoading = false;
    });
  }

  Future<bool> _onWillPop() async {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => Screen3()),
            (Route<dynamic> route) => false
    );
      return true;
    }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar:  _isUserDataLoading ? AppBarWidget().appBar(false,false,"","",false) : AppBarWidget().appBar(false,false,name,id,false),
        body: Container(
          color: AppColors.backgroundColor,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
            const  Padding(padding: EdgeInsets.only(top: 40)),
              LogoScreen(),
             // QuestionTextWidget(widget.number),
              QuestionTextWidget(widget.number=="Worse" ?
              "I'm so sorry…This will get easier, promise!"
                  : widget.number=="Same"
                  ? "That's okay. Often it just takes a little practice."
                  :widget.number=="Mixed Emotions"
                  ? "That's totally normal when processing hard situations. It will get better."
                  : widget.number=="Better"
                  ? "That's great! Keep up the good work."
                  : widget.number=="Awesome" ? "Yes! That's wonderful. Enjoy!" : ""),
                  const SizedBox(
                    height: 10,
                  ),
                  //QuestionTextWidget("Good luck"),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) => Screen3()),
                              (Route<dynamic> route) => false
                      );
                    },
                    child: OptionMcqAnswer(
                       TextButton(onPressed: () {
                         Navigator.pushAndRemoveUntil(
                             context,
                             MaterialPageRoute(builder: (BuildContext context) => Screen3()),
                                 (Route<dynamic> route) => false
                         );
                       }, child: const Text("Let's process another issue",style: TextStyle(color: AppColors.textWhiteColor)),)
                    ),
                  )
            ],
          ),
        ),
      ),
    );
  }
}
