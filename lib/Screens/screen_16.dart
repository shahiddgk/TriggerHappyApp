import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/change_password.dart';
import 'package:flutter_quiz_app/Screens/login_screen.dart';
import 'package:flutter_quiz_app/Screens/screen_3.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/Widgets/logo_widget_for_all_screens.dart';
import 'package:flutter_quiz_app/Widgets/option_mcq_widget.dart';
import 'package:flutter_quiz_app/Widgets/question_text_widget.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  _getUserData() async {
    setState(() {
      _isUserDataLoading = true;
    });
    SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      name = _sharedPreferences.getString("username")!;
      id = _sharedPreferences.getString("userid")!;
      _isUserDataLoading = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(!_isUserDataLoading ? name:""),
        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ChangePassword()));
          }, icon: Icon(Icons.person,color: AppColors.textWhiteColor,)),
          IconButton(onPressed: () async {
            SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
            setState(() {
              _sharedPreferences.setBool("user_logged_in",false);
              googleSignIn.signOut();
            });
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
                    (Route<dynamic> route) => false
            );
          }, icon: Icon(Icons.logout,color: AppColors.textWhiteColor,))
        ],
      ),
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
                       // Navigator.pushAndRemoveUntil(
                       //     context,
                       //     MaterialPageRoute(builder: (BuildContext context) => Screen3()),
                       //         (Route<dynamic> route) => false
                       // );
                     }, child: const Text("Let's do this again",style: TextStyle(color: AppColors.textWhiteColor)),)
                  ),
                )
          ],
        ),
      ),
    );
  }
}
