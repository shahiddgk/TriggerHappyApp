// ignore_for_file: unused_field

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/screen_5.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/widgets/AppBar.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/Widgets/logo_widget_for_all_screens.dart';
import 'package:flutter_quiz_app/Widgets/question_text_widget.dart';
import 'package:flutter_quiz_app/Widgets/two_buttons_widget.dart';
import 'package:flutter_quiz_app/model/reponse_model/question_answer_response_model.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../Widgets/video_player_in_pop_up.dart';

// ignore: must_be_immutable
class Screen11 extends StatefulWidget {
  List<QuestionListResponseModel> questionListResponse;

  Screen11(this.questionListResponse,{Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _Screen11State createState() => _Screen11State();
}

class _Screen11State extends State<Screen11> {

  late Timer _timer;
  int _start = 30;
  int badgeCount1 = 0;
  int badgeCountShared = 0;

  String name = "";
  String id = "";
  bool _isUserDataLoading = true;
  List selectedAnswer = [];
  final GoogleSignIn googleSignIn = GoogleSignIn();

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    _getUserData();
    startTimer();
    super.initState();
  }

  _getUserData() async {
    setState(() {
      _isUserDataLoading = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      badgeCount1 = sharedPreferences.getInt("BadgeCount")!;
      badgeCountShared = sharedPreferences.getInt("BadgeShareResponseCount")!;

      name = sharedPreferences.getString("username")!;
      id = sharedPreferences.getString("userid")!;
      _isUserDataLoading = false;
    });

  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBarWidget().appBarGeneralButtons(
          context,
              () {
            // Navigator.pushAndRemoveUntil(
            //     context,
            //     MaterialPageRoute(builder: (BuildContext context) =>const Dashboard()),
            //         (Route<dynamic> route) => false
            // );
          }, true, true, true, id, false,true,badgeCount1,false,badgeCountShared),
      bottomNavigationBar: Container(
        color: AppColors.backgroundColor,
        child: PriviousNextButtonWidget((){
          if(_start == 0) {
           // print(widget.answersList);
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => Screen5(
                   widget.questionListResponse,9,
                    12)));
          } else {
            showToast(
                "Wait for timer to complete", shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)
            ),
                context: context,
                fullWidth: true,
                alignment: Alignment.topCenter,
                duration: const Duration(seconds: 3),
                backgroundColor: Colors.red
            );
          }
        },(){
          Navigator.of(context).pop();
        },true)
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: AppColors.backgroundColor,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  LogoScreen("PIRE"),

                  Align(
                      alignment: Alignment.topLeft,
                      child: QuestionTextWidget(widget.questionListResponse[8].title,widget.questionListResponse[8].videoUrl,(){
                        String urlQ1 = "https://youtu.be/T4-coEpZvgY";
                        String? videoId = YoutubePlayer.convertUrlToId(urlQ1);
                        YoutubePlayerController youtubePlayerController = YoutubePlayerController(
                            initialVideoId: videoId!,
                            flags: const YoutubePlayerFlags(
                              autoPlay: false,
                              controlsVisibleAtStart: false,
                            )

                        );
                        videoPopupDialog(context, "Introduction to question#11", youtubePlayerController);
                      },true)),

                  Container(
                    height: MediaQuery.of(context).size.height/2,
                    width: MediaQuery.of(context).size.width/2,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primaryColor,width: 5),
                      // borderRadius: BorderRadius.circular(100),
                    ),
                    child: _start == 0 ?const Text("Well done!",style: TextStyle(fontSize: 25,color: AppColors.textWhiteColor),) :Text("$_start",style: const TextStyle(fontSize: 25,color: AppColors.textWhiteColor),),
                  )
                ],
              ),

              // Align(alignment: Alignment.bottomCenter,
              //   child: Align(
              //       alignment: Alignment.bottomCenter,
              //       child:
              //   ),)
            ],
          ),
        )
      ),
    );
  }
}
