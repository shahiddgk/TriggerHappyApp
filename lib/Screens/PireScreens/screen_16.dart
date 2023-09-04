// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/video_screen.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/widgets/AppBar.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/Widgets/logo_widget_for_all_screens.dart';
import 'package:flutter_quiz_app/Widgets/option_mcq_widget.dart';
import 'package:flutter_quiz_app/Widgets/question_text_widget.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../Widgets/video_player_in_pop_up.dart';
import '../utill/userConstants.dart';

class Screen16 extends StatefulWidget {
  Screen16(this.number,{Key? key}) : super(key: key);

  String number;

  @override
  // ignore: library_private_types_in_public_api
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
    // print("Data getting called");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    name = sharedPreferences.getString(UserConstants().userName)!;
    id = sharedPreferences.getString(UserConstants().userId)!;
    email = sharedPreferences.getString(UserConstants().userEmail)!;
    timeZone = sharedPreferences.getString(UserConstants().timeZone)!;
    userType = sharedPreferences.getString(UserConstants().userType)!;
    setState(() {
      _isUserDataLoading = false;
    });
  }

  Future<bool> _onWillPop() async {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => const VideoScreen()),
            (Route<dynamic> route) => false
    );
    // int count = 0;
    // Navigator.of(context).popUntil((_) => count++ >= 11);
      return true;
    }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar:  _isUserDataLoading ? AppBarWidget().appBar(context,false,false,"","",false) : AppBarWidget().appBar(context,false,false,name,id,false),
        body: Container(
          color: AppColors.backgroundColor,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
            const  Padding(padding: EdgeInsets.only(top: 40)),
              LogoScreen("PIRE"),
             // QuestionTextWidget(widget.number),
              QuestionTextWidget(widget.number=="Worse" ?
              "I'm so sorry…This will get easier, promise!"
                  : widget.number=="Same"
                  ? "That's okay. Often it just takes a little practice."
                  :widget.number=="Mixed Emotions"
                  ? "That's totally normal when processing hard situations. It will get better."
                  : widget.number=="Better"
                  ? "That's great! Keep up the good work."
                  : widget.number=="Awesome" ? "Yes! That's wonderful. Enjoy!" : "","",(){
                String urlQ1 = "https://www.youtube.com/watch?v=RHiFWm5-r3g";
                String? videoId = YoutubePlayer.convertUrlToId(urlQ1);
                YoutubePlayerController youtubePlayerController = YoutubePlayerController(
                    initialVideoId: videoId!,
                    flags: const YoutubePlayerFlags(
                      autoPlay: false,
                      controlsVisibleAtStart: false,
                    )

                );
                videoPopupDialog(context, "Introduction to question#1", youtubePlayerController);
              },true),
                  const SizedBox(
                    height: 10,
                  ),
                  //QuestionTextWidget("Good luck"),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) =>const VideoScreen()),
                              (Route<dynamic> route) => false
                      );
                    },
                    child: OptionMcqAnswer(
                       TextButton(onPressed: () {
                         // int count = 0;
                         // Navigator.of(context).popUntil((_) => count++ >= 11);
                         Navigator.pushAndRemoveUntil(
                             context,
                             MaterialPageRoute(builder: (BuildContext context) =>const VideoScreen()),
                                 (Route<dynamic> route) => false
                         );
                       }, child: const Text("Back to Home Screen",style: TextStyle(color: AppColors.textWhiteColor)),)
                    ),
                  )
            ],
          ),
        ),
      ),
    );
  }
}
